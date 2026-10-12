#!/usr/bin/env python3
"""Publish I Like to Google Play via the Android Publisher API (v3).

Everything happens inside one "edit"; nothing goes live until the edit is
committed. Without --commit the edit is only validated and then discarded.

Usage examples:
  # Check access and show what is on Play right now (changes nothing)
  python tool/play_publish.py --status

  # Validate a full upload (bundle + listings + images) without publishing
  python tool/play_publish.py --bundle build/app/outputs/bundle/release/app-release.aab \\
      --track internal --listings --images

  # ...and publish it
  python tool/play_publish.py --bundle ... --track internal --listings --images --commit

Store content lives in store/:
  store/listings/<lang>/title.txt, short_description.txt, full_description.txt
  store/listings/<lang>/images/icon.png, featureGraphic.png, phoneScreenshots/*.png
  store/release-notes/<lang>.txt

The service-account key is read from --key or $PLAY_SERVICE_ACCOUNT_JSON.
Never commit that file.
"""
from __future__ import annotations

import argparse
import os
import re
import sys
from pathlib import Path

from google.auth.transport.requests import AuthorizedSession
from google.oauth2 import service_account

PACKAGE = "de.langenk.ilike"
API = "https://androidpublisher.googleapis.com/androidpublisher/v3/applications"
UPLOAD = "https://androidpublisher.googleapis.com/upload/androidpublisher/v3/applications"
SCOPES = ["https://www.googleapis.com/auth/androidpublisher"]
ROOT = Path(__file__).resolve().parent.parent
STORE = ROOT / "store"

# Folder/file name -> API image type
IMAGE_TYPES = {
    "icon": "icon",
    "featureGraphic": "featureGraphic",
    "phoneScreenshots": "phoneScreenshots",
    "sevenInchScreenshots": "sevenInchScreenshots",
    "tenInchScreenshots": "tenInchScreenshots",
}

# Play's limits for listing texts
LIMITS = {"title": 30, "shortDescription": 80, "fullDescription": 4000}


class Play:
    def __init__(self, key: str, package: str):
        creds = service_account.Credentials.from_service_account_file(key, scopes=SCOPES)
        self.s = AuthorizedSession(creds)
        self.package = package
        self.edit = None

    def _url(self, path: str = "", upload: bool = False) -> str:
        base = UPLOAD if upload else API
        return f"{base}/{self.package}/edits/{self.edit}{path}"

    def _check(self, r):
        if r.status_code >= 400:
            raise SystemExit(f"API error {r.status_code} for {r.request.method} {r.url}:\n{r.text}")
        return r.json() if r.content else {}

    def open(self):
        self.edit = self._check(self.s.post(f"{API}/{self.package}/edits"))["id"]

    def discard(self):
        if self.edit:
            self.s.delete(self._url())
            self.edit = None

    def get(self, path: str):
        return self._check(self.s.get(self._url(path)))

    def upload_bundle(self, path: Path) -> int:
        size_mb = path.stat().st_size / 1e6
        print(f"Uploading {path.name} ({size_mb:.1f} MB) …")
        with path.open("rb") as f:
            r = self.s.post(
                self._url("/bundles", upload=True),
                params={"uploadType": "media"},
                data=f,
                headers={"Content-Type": "application/octet-stream"},
                timeout=900,
            )
        version_code = self._check(r)["versionCode"]
        print(f"  → version code {version_code}")
        return version_code

    def set_track(self, track: str, version_code: int, name: str, notes: dict[str, str],
                  draft: bool = False):
        release = {
            "name": name,
            "versionCodes": [str(version_code)],
            # A "draft app" (never rolled out beyond internal testing) only
            # accepts draft releases on other tracks; roll those out in Play Console.
            "status": "draft" if draft else "completed",
            "releaseNotes": [{"language": lang, "text": text} for lang, text in notes.items()],
        }
        self._check(self.s.put(self._url(f"/tracks/{track}"), json={"track": track, "releases": [release]}))
        print(f"Track '{track}': release '{name}' with version code {version_code}"
              + (" (draft)" if draft else ""))

    def update_listing(self, lang: str, listing: dict):
        self._check(self.s.put(self._url(f"/listings/{lang}"), json={"language": lang, **listing}))
        print(f"Listing {lang}: title, short and full description")

    def replace_images(self, lang: str, image_type: str, files: list[Path]):
        self._check(self.s.delete(self._url(f"/listings/{lang}/{image_type}")))
        for f in files:
            mime = "image/png" if f.suffix.lower() == ".png" else "image/jpeg"
            with f.open("rb") as fh:
                self._check(self.s.post(
                    self._url(f"/listings/{lang}/{image_type}", upload=True),
                    params={"uploadType": "media"},
                    data=fh,
                    headers={"Content-Type": mime},
                    timeout=300,
                ))
        print(f"Images {lang}/{image_type}: {len(files)} uploaded")

    def validate(self):
        self._check(self.s.post(self._url(":validate")))

    def commit(self):
        self._check(self.s.post(self._url(":commit")))
        self.edit = None


def read_listing(lang_dir: Path) -> dict:
    fields = {
        "title": "title.txt",
        "shortDescription": "short_description.txt",
        "fullDescription": "full_description.txt",
    }
    listing = {}
    for key, name in fields.items():
        path = lang_dir / name
        if not path.exists():
            continue
        text = path.read_text(encoding="utf-8").strip()
        if len(text) > LIMITS[key]:
            raise SystemExit(f"{path}: {len(text)} characters, Play allows {LIMITS[key]}")
        if key == "shortDescription" and re.search("[–—]|--", text):
            # Play flags dashes in the short description as a policy issue
            raise SystemExit(f"{path}: avoid dashes in the short description")
        listing[key] = text
    return listing


def image_files(lang_dir: Path) -> dict[str, list[Path]]:
    images = lang_dir / "images"
    result = {}
    for name, image_type in IMAGE_TYPES.items():
        single = [p for p in images.glob(f"{name}.*") if p.is_file()]
        folder = sorted((images / name).glob("*.*")) if (images / name).is_dir() else []
        files = single or folder
        if files:
            result[image_type] = files
    return result


def version_from_pubspec() -> str:
    """pubspec "1.0.2+3" -> release name "1.0.2 (3)"."""
    match = re.search(r"^version:\s*([^+\s]+)\+?(\S*)", (ROOT / "pubspec.yaml").read_text(encoding="utf-8"), re.M)
    if not match:
        return "?"
    name, build = match.groups()
    return f"{name} ({build})" if build else name


def main():
    sys.stdout.reconfigure(encoding="utf-8")
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--key", default=os.environ.get("PLAY_SERVICE_ACCOUNT_JSON"),
                    help="service-account JSON (default: $PLAY_SERVICE_ACCOUNT_JSON)")
    ap.add_argument("--package", default=PACKAGE)
    ap.add_argument("--status", action="store_true", help="show tracks and listings, change nothing")
    ap.add_argument("--bundle", type=Path, help="AAB to upload")
    ap.add_argument("--version-code", type=int,
                    help="put an already uploaded build on --track instead of uploading one")
    ap.add_argument("--track", default="internal", help="internal, alpha, beta or production")
    ap.add_argument("--listings", action="store_true", help="update texts from store/listings")
    ap.add_argument("--images", action="store_true", help="replace graphics from store/listings/*/images")
    ap.add_argument("--draft", action="store_true",
                    help="create the release as a draft (needed for a first release beyond internal testing)")
    ap.add_argument("--commit", action="store_true", help="publish; without it the edit is only validated")
    args = ap.parse_args()

    if not args.key or not Path(args.key).is_file():
        sys.exit("Service-account key not found: pass --key or set PLAY_SERVICE_ACCOUNT_JSON")
    if args.track == "production" and args.commit:
        sys.exit("Production releases are done by hand in Play Console.")

    play = Play(args.key, args.package)
    play.open()
    try:
        if args.status:
            for t in play.get("/tracks").get("tracks", []):
                for rel in t.get("releases", []):
                    print(f"Track {t['track']}: {rel.get('name')} {rel.get('versionCodes')} [{rel.get('status')}]")
            for l in play.get("/listings").get("listings", []):
                print(f"Listing {l['language']}: {l.get('title')!r} – {l.get('shortDescription')!r}")
            return

        langs = sorted(p for p in (STORE / "listings").iterdir() if p.is_dir())
        if args.bundle or args.version_code:
            # A build already on another track (e.g. internal) can't be uploaded again
            version_code = args.version_code or play.upload_bundle(args.bundle)
            notes = {
                p.stem: p.read_text(encoding="utf-8").strip()
                for p in sorted((STORE / "release-notes").glob("*.txt"))
            }
            play.set_track(args.track, version_code, version_from_pubspec(), notes, draft=args.draft)
        if args.listings:
            for lang_dir in langs:
                play.update_listing(lang_dir.name, read_listing(lang_dir))
        if args.images:
            for lang_dir in langs:
                for image_type, files in image_files(lang_dir).items():
                    play.replace_images(lang_dir.name, image_type, files)

        play.validate()
        if args.commit:
            play.commit()
            print("✓ Committed – changes are live on Google Play.")
        else:
            print("✓ Validated. Nothing was published (run again with --commit).")
    finally:
        play.discard()


if __name__ == "__main__":
    main()
