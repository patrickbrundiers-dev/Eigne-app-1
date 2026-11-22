# Entwicklungsstand (für die nächste Sitzung)

Neueste Einträge oben. Jede Sitzung: zuerst diese Datei, [AI_TASK_QUEUE.md](AI_TASK_QUEUE.md),
[AI_DECISIONS.md](AI_DECISIONS.md) und `git status` / offene PRs lesen, dann an der nächsten offenen Aufgabe
weiterarbeiten.

## 2026-11-22 – Bestandsaufnahme, Wettbewerb, Gewichts-Dashboard

Thread „Sattly auf Niveau führender Apps bringen“, Branch `claude/project-thread-58v9es`.

Erledigt:
- Technische Bestandsaufnahme am Code: [BESTANDSAUFNAHME.md](BESTANDSAUFNAHME.md)
- Wettbewerbsanalyse ergänzt um Lifesum und aktuellen Stand YAZIO/MFP, Vergleichsmatrix:
  [WETTBEWERB-MATRIX.md](WETTBEWERB-MATRIX.md)
- Priorisierte gemeinsame Aufgabenliste P1–P7: [AI_TASK_QUEUE.md](AI_TASK_QUEUE.md)
- Umgesetzt: Gewichts-Dashboard „Fortschritt“ auf der Gewichtsseite
  - Rechenkern `apps/mydiet/lib/src/core/weight_progress.dart`: Start/bisher/verbleibend aus dem
    7-Tage-Mittel, Vergleich zur Vorwoche, 30-Tage-Trend (Ausgleichsgerade, Veränderung entlang der Geraden,
    Streuung der Einzelmessungen, Aussagekraft), Prognose nur bei ausreichender Datenlage, Ernährung der
    letzten 7 Tage (Ø kcal gegen Ziel, Bilanz gegen geschätzten Verbrauch, erwartete kg/Woche,
    Proteinziel an x von y Tagen)
  - UI `features/weight/progress_card.dart`, eingebunden in `weight_page.dart`; Modus „Zahlen ausblenden“
    wird bei Kalorien beachtet; Erklärung „Wie wird gerechnet?“
  - Vergleich „Bilanz erklärt X kg/Woche, Waage zeigt Y“ mit möglichen Ursachen (ohne Diagnose)
- Doku: `docs/BERECHNUNGEN.md` (Abschnitt Gewichts-Dashboard), `docs/SICHERHEIT.md` (Netzwerk-Aussage
  korrigiert), CHANGELOG, `CLAUDE.md`

Tests: `flutter analyze` ohne Befund, `dart format` sauber, `flutter test` 173 Tests grün (vorher 156)
(16 neue Unit-Tests in `test/weight_progress_test.dart`, 1 Widget-Test in `test/app_test.dart`, Handy- und
Breitbild).

Offen / bekannt:
- Kein Schema-Eingriff; Abstimmung mit Phase-2-Thread: der baut W5 mit Schema v6 und eine neue
  Dashboard-Kachel am Ende des `DashTile`-Enums. Eine Fortschritts-Kachel fürs Dashboard (Aufgabe 2.2)
  erst nach W5.
- Lokal installiertes Flutter: `git clone --depth 1 -b stable https://github.com/flutter/flutter.git /opt/flutter`.

Nächster Schritt: Aufgabe 3.1 „Texteingabe ohne KI“ (siehe Aufgabenliste).
