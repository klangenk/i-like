# Datenschutzerklärung – I Like

*Zuletzt aktualisiert: Oktober 2026* · [English version](https://github.com/klangenk/i-like/blob/main/PRIVACY.en.md)

## 1. Verantwortlicher

Diese App wird privat betrieben. Bei Fragen zum Datenschutz wende dich an den Entwickler über die im App-Store hinterlegte Kontaktadresse.

---

## 2. Grundsatz: Daten bleiben auf deinem Gerät

**I Like** speichert alle Bewertungen ausschließlich lokal in einer SQLite-Datenbank auf deinem Gerät. Es gibt keinen eigenen Server, kein Benutzerkonto und keine Synchronisierung. Niemand außer dir hat Zugriff auf deine Daten.

---

## 3. Berechtigungen

### Kamera
- **Wofür:** Barcode-Scanner (Produkte, Bücher, Brettspiele) und – wenn du möchtest – ein eigenes Foto für eine Bewertung
- **Wann:** Nur wenn du den Scanner öffnest oder aktiv „Foto aufnehmen“ wählst
- **Gespeichert:** Beim Scannen werden keine Fotos aufgenommen. Fotos, die du für eine Bewertung aufnimmst, werden ausschließlich lokal in der App gespeichert

### Fotos (Galerie)
- **Wofür:** Ein vorhandenes Foto als Bild für eine Bewertung auswählen
- **Wann:** Nur wenn du aktiv „Aus Galerie wählen“ antippst; die App sieht dabei nur das Foto, das du auswählst
- **Gespeichert:** Eine Kopie des gewählten Fotos wird lokal in der App gespeichert und nicht übertragen

### Texterkennung auf dem Gerät
Wenn du ein Foto hinzufügst, schlägt die App einen Titel und eine Kategorie vor. Dafür liest sie den Text auf dem Foto und erkennt grob, was abgebildet ist. Das geschieht vollständig auf deinem Gerät mit [Google ML Kit](https://developers.google.com/ml-kit) – Fotos und erkannte Texte verlassen dein Gerät nicht.

---

## 4. Externe Dienste

Wenn du bestimmte Funktionen nutzt, werden Anfragen an folgende externe Dienste gesendet. Dabei wird deine IP-Adresse technisch bedingt übertragen. Es werden keine personenbezogenen Daten absichtlich weitergegeben.

| Funktion | Dienst | Datenschutzerklärung |
|---|---|---|
| Produktsuche via Barcode (Lebensmittel) | [Open Food Facts](https://world.openfoodfacts.org) | [openfoodfacts.org/privacy](https://world.openfoodfacts.org/privacy) |
| Produktsuche via Barcode (Kosmetik, Haushalt) | [Open Beauty Facts](https://world.openbeautyfacts.org), [Open Products Facts](https://world.openproductsfacts.org) | [openfoodfacts.org/privacy](https://world.openfoodfacts.org/privacy) |
| Produktsuche via Barcode (allgemein) | [UPC Item DB](https://www.upcitemdb.com) | [upcitemdb.com/privacy](https://www.upcitemdb.com/privacy) |
| Buchsuche & ISBN-Lookup | [Open Library (Internet Archive)](https://openlibrary.org) | [archive.org/about/terms.php](https://archive.org/about/terms.php) |
| ISBN-Lookup (wenn Open Library das Buch nicht kennt), inkl. Cover | [Deutsche Nationalbibliothek](https://www.dnb.de) | [dnb.de/datenschutz](https://www.dnb.de/datenschutz) |
| Brettspielsuche (inkl. Bilder) | [Wikipedia API](https://www.mediawiki.org/wiki/API) | [wikimedia.org/wiki/Privacy_policy](https://foundation.wikimedia.org/wiki/Privacy_policy) |
| Details zu einem Link (Titel, Bild) | Die jeweils aufgerufene Website, z. B. Amazon | Abhängig von der Website |
| Details zu einem Link, wenn die Website die App nicht lädt (z. B. wegen eines Bot-Schutzes): der Link wird an einen Vorschau-Dienst geschickt | [Microlink](https://microlink.io) | [microlink.io/privacy](https://microlink.io/privacy) |
| „Im Web suchen" auf der Detailseite (öffnet deinen Browser mit dem Titel als Suchbegriff) | [Google](https://www.google.com) | [policies.google.com/privacy](https://policies.google.com/privacy) |

Alle Anfragen erfolgen nur dann, wenn du die entsprechende Funktion aktiv verwendest.

---

## 5. Geteilte Inhalte empfangen

Die App kann Text und URLs empfangen, die du aus anderen Apps heraus teilst (z. B. „Teilen" in einem Browser). Der geteilte Text wird nur lokal verarbeitet. Enthält er einen Link, ruft die App diese Seite ab, um Titel und Bild zu übernehmen; lässt die Seite das nicht zu, wird nur der Link an Microlink geschickt (siehe Abschnitt 4).

---

## 6. Export-Funktion

Wenn du Bewertungen als JSON oder CSV exportierst, erstellst du eine Datei auf deinem Gerät, die du anschließend selbst teilen oder speichern kannst. Die App selbst überträgt diese Datei nicht.

**Sicherung im Google-Konto (optional, nur Android):** Standardmäßig ausgeschaltet. Schaltest du sie in den Einstellungen ein, legt die App eine Kopie deiner Bewertungen und Fotos in einem Ordner ab, den die Android-Sicherung (Auto Backup) verschlüsselt in **deinem eigenen Google-Konto** speichert, sofern die Gerätesicherung auf deinem Handy aktiv ist. Beim Einrichten eines neuen Handys stellt Android sie wieder her. Wir haben keinen Zugriff auf diese Sicherung; es gelten die [Datenschutzbestimmungen von Google](https://policies.google.com/privacy). Schaltest du die Sicherung aus, löscht die App die Kopie, und bei der nächsten Gerätesicherung wird nichts mehr von I Like gespeichert.

---

## 7. Keine Tracker, keine Werbung, keine Analyse

Die App enthält keinerlei:
- Analyse- oder Tracking-SDKs (z. B. Firebase, Crashlytics, Sentry)
- Werbung
- Drittanbieter-SDKs, die dein Verhalten verfolgen

**Ausnahme Google ML Kit:** Die Bibliothek für die Texterkennung übermittelt laut Google anonyme Nutzungs- und Leistungsdaten an Google (z. B. Gerätetyp, App-Version und wie oft die Erkennung genutzt wird), um die Bibliothek zu verbessern. Fotos, erkannte Texte und deine Bewertungen gehören nicht dazu. Details: [ML Kit – Datenoffenlegung](https://developers.google.com/ml-kit/android-data-disclosure).

---

## 8. Datenlöschung

Da alle Daten lokal gespeichert sind, kannst du sie jederzeit löschen:
- **Einzelne Bewertungen:** direkt in der App
- **Alle Daten:** App deinstallieren

---

## 9. Kinder

Die App richtet sich nicht gezielt an Kinder unter 13 Jahren und erhebt bewusst keinerlei personenbezogene Daten.

---

## 10. Änderungen

Wenn sich diese Datenschutzerklärung wesentlich ändert, wird das Datum oben aktualisiert. Die jeweils aktuelle Version findest du in der App unter **Einstellungen → Über → Datenschutz** sowie unter folgender Adresse:

**https://github.com/klangenk/i-like/blob/main/PRIVACY.md**

---

## 11. Kontakt

Bei Fragen oder Anmerkungen zum Datenschutz wende dich bitte über den App-Store an den Entwickler.
