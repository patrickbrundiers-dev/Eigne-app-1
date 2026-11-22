# Sicherheits- und Datenschutzkonzept

Gesundheits- und Ernährungsdaten sind besondere Kategorien personenbezogener Daten (Art. 9 DSGVO).
Grundsatz: so wenig Daten wie nötig, so lange wie möglich nur auf dem eigenen Gerät.

## Stand Phase 1

| Thema | Umsetzung |
|---|---|
| Speicherort | SQLite-Datei im privaten App-Speicher (Android: App-Sandbox, nur die App hat Zugriff; Windows: Benutzerprofil) |
| Netzwerk | Nur auf Anforderung: Open Food Facts beim Scannen eines unbekannten Barcodes (nur der Barcode) und beim Rezept-Import die eingegebene Webadresse (eine Abfrage, ohne Cookies und Nutzerdaten); jeweils generischer User-Agent. Keine Analyse- oder Werbe-SDKs. |
| Export | Nur auf ausdrücklichen Wunsch, Speicherort wählt der Benutzer. Export-Dateien sind per `.gitignore` ausgeschlossen. Hinweis: Export ist unverschlüsselt. |
| Import | Formatprüfung, eine Transaktion, bei Fehlern keine Änderung |
| Eingaben | Wertebereiche für Gewicht, Mengen, Nährwerte; Plausibilitätsprüfung von Nährwerten; SQL nur über Platzhalter |
| Medizinische Aussagen | Hinweise sind regelbasiert und ausdrücklich keine Beratung; Sicherheitsgrenzen beim Kalorienziel (max. 1 % Gewichtsverlust/Woche, min. 1500/1200 kcal) |

Bekannte Lücke in Phase 1: Die Datenbank auf dem Gerät ist nicht zusätzlich verschlüsselt. Schutz
besteht über die Geräteverschlüsselung (Android ab Version 10 standardmäßig, Windows mit BitLocker)
und die App-Sandbox. Geplant für Phase 5: SQLCipher mit Schlüssel im Android Keystore bzw. Windows DPAPI
und optionale App-Sperre.

## Ab Phase 4 (Sync über gehostetes PostgreSQL in der EU)

- Anbieter mit Rechenzentrum in der EU und Auftragsverarbeitungsvertrag (AVV).
- Übertragung nur über TLS 1.2+; Zertifikatsprüfung nicht abschaltbar.
- Anmeldung über Konto (E-Mail/Passwort mit starker Passwort-Hash-Funktion beim Anbieter oder Google-Login);
  Tokens im sicheren Speicher des Geräts (Android Keystore / Windows Credential Manager).
- Row-Level-Security: jede Zeile hat `user_id`, Richtlinien erlauben nur Zugriff auf eigene Zeilen.
- Verschlüsselung ruhender Daten beim Anbieter; zusätzlich geprüft wird Ende-zu-Ende-Verschlüsselung
  besonders sensibler Felder (Notizen, Körperwerte).
- Automatische Backups beim Anbieter plus regelmäßiger verschlüsselter Export.
- Löschung des Kontos löscht alle Zeilen serverseitig (Recht auf Löschung).

## KI (Phase 3)

- Nur Daten senden, die für die Anfrage nötig sind (z. B. Mahlzeitentext, keine Stammdaten).
- Anbieter ohne Training auf Kundendaten, bevorzugt EU-Verarbeitung oder lokales Modell.
- KI-Ergebnisse werden nie ungeprüft als Fakten gespeichert: Schätzwerte sind markiert und
  bestätigungspflichtig.

## Entwicklung

- Keine Geheimnisse im Repository (`.gitignore` für Schlüssel, `key.properties`, `.env`).
- Android-Release-Signatur nur über GitHub-Secrets (`ANDROID_KEYSTORE_*`).
- CI prüft Formatierung, Analyse und alle Tests bei jedem Pull Request.
