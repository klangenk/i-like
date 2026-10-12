#!/usr/bin/env python3
"""Compose the Play Store phone screenshots from raw app renders.

1. Render the raw screens with the example photos in store/photos
   (credits in store/CREDITS.md):
     for L in de en; do flutter test test/store_shots_test.dart --update-goldens \\
       --dart-define=STORE_SHOTS=true --dart-define=LANG=$L; done
2. python tool/store_screenshots.py
   -> store/listings/<lang>/images/phoneScreenshots/1.png … 6.png
3. Upload with: python tool/play_publish.py --images [--commit]
"""
import glob
import os
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
FONT = ROOT / 'assets/fonts/SchibstedGrotesk-Black.ttf'
INK = (0x1C, 0x1B, 0x22)
RASPBERRY = (0xD4, 0x1D, 0x55)
WHITE = (255, 255, 255)
W, H = 1080, 1920

# (raw render, background, caption de, caption en) in store order
SHOTS = [
    ('1_home', RASPBERRY, 'Alles, was du magst –\nauf einen Blick', 'Everything you like,\nat a glance'),
    ('4_add', INK, 'Barcode scannen,\nLink teilen, fertig', 'Scan a barcode,\nshare a link, done'),
    ('2_rate', RASPBERRY, 'Bewerte in Worten:\nvon Nope bis Liebe', 'Rate in words:\nfrom Nope to Love'),
    ('3_detail', INK, 'Jede Bewertung mit\nFoto und Details', 'Every rating with\nphoto and details'),
    ('5_grouped', RASPBERRY, 'Nach Kategorie\ngruppiert', 'Grouped by\ncategory'),
    ('6_settings', INK, 'Deine Daten bleiben\nauf deinem Gerät', 'Your data stays\non your device'),
]


def rounded(im, radius):
    mask = Image.new('L', im.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, im.size[0] - 1, im.size[1] - 1], radius, fill=255)
    out = Image.new('RGBA', im.size, (0, 0, 0, 0))
    out.paste(im, (0, 0), mask)
    return out


def main():
    font = ImageFont.truetype(str(FONT), 78)
    for lang, code in [('de', 'de-DE'), ('en', 'en-US')]:
        out = ROOT / f'store/listings/{code}/images/phoneScreenshots'
        out.mkdir(parents=True, exist_ok=True)
        for old in glob.glob(str(out / '*.png')):
            os.remove(old)
        for i, (raw, bg, cap_de, cap_en) in enumerate(SHOTS, start=1):
            canvas = Image.new('RGBA', (W, H), bg + (255,))
            ImageDraw.Draw(canvas).multiline_text(
                (W // 2, 120), cap_de if lang == 'de' else cap_en,
                font=font, fill=WHITE, anchor='ma', align='center', spacing=14)
            shot = Image.open(ROOT / f'test/store/{lang}_{raw}.png').convert('RGB')
            sh = 1450
            sw = int(shot.width * sh / shot.height)
            phone = rounded(shot.resize((sw, sh), Image.Resampling.LANCZOS), 48)
            x, y = (W - sw) // 2, H - sh - 30
            shadow = Image.new('RGBA', (W, H), (0, 0, 0, 0))
            ImageDraw.Draw(shadow).rounded_rectangle([x, y + 18, x + sw, y + sh + 18], 48, fill=(0, 0, 0, 110))
            canvas = Image.alpha_composite(canvas, shadow.filter(ImageFilter.GaussianBlur(28)))
            canvas.paste(phone, (x, y), phone)
            canvas.convert('RGB').save(out / f'{i}.png')
        print(f'{code}: {len(SHOTS)} screenshots')


if __name__ == '__main__':
    main()
