# Privacy Policy – I Like

*Last updated: October 2026* · [Deutsche Version](https://github.com/klangenk/i-like/blob/main/PRIVACY.md)

## 1. Controller

This app is operated privately. If you have any questions about privacy, please contact the developer via the contact address listed in the app store.

---

## 2. Principle: your data stays on your device

**I Like** stores all ratings exclusively in a local SQLite database on your device. There is no server of its own, no user account and no synchronisation. Nobody but you has access to your data.

---

## 3. Permissions

### Camera
- **Purpose:** Barcode scanner (products, books, board games) and – if you want – your own photo for a rating
- **When:** Only when you open the scanner or actively choose "Take photo"
- **Stored:** Scanning takes no photos. Photos you take for a rating are stored only locally in the app

### Photos (gallery)
- **Purpose:** Choosing an existing photo as the image for a rating
- **When:** Only when you actively tap "Choose from gallery"; the app only sees the photo you select
- **Stored:** A copy of the selected photo is stored locally in the app and is not transmitted

### On-device text recognition
When you add a photo, the app suggests a title and a category. To do so it reads the text in the photo and roughly recognises what it shows. This happens entirely on your device using [Google ML Kit](https://developers.google.com/ml-kit) – photos and recognised text never leave your device.

---

## 4. External services

When you use certain features, requests are sent to the following external services. Your IP address is transmitted for technical reasons. No personal data is intentionally shared.

| Feature | Service | Privacy policy |
|---|---|---|
| Product lookup via barcode (food) | [Open Food Facts](https://world.openfoodfacts.org) | [openfoodfacts.org/privacy](https://world.openfoodfacts.org/privacy) |
| Product lookup via barcode (general) | [UPC Item DB](https://www.upcitemdb.com) | [upcitemdb.com/privacy](https://www.upcitemdb.com/privacy) |
| Book search & ISBN lookup | [Open Library (Internet Archive)](https://openlibrary.org) | [archive.org/about/terms.php](https://archive.org/about/terms.php) |
| Board game search (incl. images) | [Wikipedia API](https://www.mediawiki.org/wiki/API) | [wikimedia.org/wiki/Privacy_policy](https://foundation.wikimedia.org/wiki/Privacy_policy) |
| Details for a link (title, image) | The website you open, e.g. Amazon | Depends on the website |

Requests are only made when you actively use the corresponding feature.

---

## 5. Receiving shared content

The app can receive text and URLs that you share from other apps (e.g. "Share" in a browser). This content is processed locally only and is not passed on to third parties.

---

## 6. Export

When you export ratings as JSON or CSV, you create a file on your device that you can then share or save yourself. The app itself does not transmit this file.

---

## 7. No trackers, no ads, no analytics

The app contains no:
- Analytics or tracking SDKs (e.g. Firebase, Crashlytics, Sentry)
- Advertising
- Third-party SDKs that track your behaviour

**Exception Google ML Kit:** According to Google, the text recognition library sends anonymous usage and performance data to Google (e.g. device type, app version and how often recognition is used) to improve the library. This does not include photos, recognised text or your ratings. Details: [ML Kit – data disclosure](https://developers.google.com/ml-kit/android-data-disclosure).

---

## 8. Deleting your data

Since all data is stored locally, you can delete it at any time:
- **Individual ratings:** directly in the app
- **All data:** uninstall the app

---

## 9. Children

The app is not specifically aimed at children under 13 and deliberately collects no personal data at all.

---

## 10. Changes

If this privacy policy changes significantly, the date at the top will be updated. You can always find the current version in the app under **Settings → About → Privacy policy** and at:

**https://github.com/klangenk/i-like/blob/main/PRIVACY.en.md**

---

## 11. Contact

If you have any questions or comments about privacy, please contact the developer via the app store.
