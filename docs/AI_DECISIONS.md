# Technische Entscheidungen

Kurz und datiert. Neue Entscheidungen unten anhängen, alte nicht löschen, sondern als „ersetzt durch“ markieren.
Ausführliche Begründungen stehen in [ANALYSE.md](ANALYSE.md), [ARCHITEKTUR.md](ARCHITEKTUR.md),
[DATENMODELL.md](DATENMODELL.md) und [SICHERHEIT.md](SICHERHEIT.md).

| Nr. | Datum | Entscheidung | Grund | Wer |
|---|---|---|---|---|
| D-01 | 2026-11-22 | Flutter/Dart, eine Codebasis für Android + Windows, iOS später | einziges Framework mit offiziellem Windows- und Android-Support und gutem Offline-DB-Ökosystem | Phase 1 |
| D-02 | 2026-11-22 | SQLite mit Drift, offline-first; UUID, `updatedAt`, Tombstones in jeder Tabelle | gleiche relationale Struktur wie späteres PostgreSQL, Transaktionen, reaktive Streams | Phase 1 |
| D-03 | 2026-11-22 | Sync später über gehostetes PostgreSQL in der EU (z. B. Supabase Frankfurt), kein eigener Server, nicht vorgezogen | Patrick, Entscheidungskarte | Patrick |
| D-04 | 2026-11-22 | App-Name „Sattly“; interne Kennungen (`mydiet_ai`, DB `mydiet`, applicationId, Tag-Schema `mydiet-vX.Y.Z`) bleiben | Updates dürfen keine Daten verlieren | Patrick / Branding-PR #21 |
| D-05 | 2026-11-22 | Kein State-Management-Paket; Drift-Streams + `StreamBuilder` | wenig Abhängigkeiten, reicht für die Datenmenge | Phase 1 |
| D-06 | 2026-11-22 | Lebensmitteldaten nur aus freien Quellen (Open Food Facts, später USDA), fremde Apps werden nicht ausgelesen | Recht und Datenqualität | Patrick |
| D-07 | 2026-11-22 | KI „lokal zuerst“: Regeln und Lernen aus eigenen Einträgen auf dem Gerät; externe KI-Dienste optional, mit Datenvorschau, Schlüssel nur im sicheren Speicher; KI erfindet keine Nährwerte, Schätzungen sind gekennzeichnet und bestätigungspflichtig | Datenschutz, Offline-Nutzung, Nachvollziehbarkeit | Master-Auftrag Abschn. 7 |
| D-08 | 2026-11-22 | Gewichtszahlen kommen immer aus Trends (7-Tage-Mittel, Ausgleichsgerade), nie aus einer Einzelmessung; jeder Trend zeigt seine Aussagekraft (zu wenig / gering / mittel / gut) und wird bei zu wenig Daten nicht angezeigt | Schwankungen von 1–2 kg/Tag dürfen nicht überbewertet werden | dieser Thread |
| D-09 | 2026-11-22 | Ernährungsauswertungen zählen heute nie mit und schließen Tage unter 800 kcal als unvollständig aus | unfertige oder vergessene Tage verfälschen sonst Bilanz und Verbrauch (gleiche Regel wie Wochen-Check) | dieser Thread |
| D-10 | 2026-11-22 | Zusammenarbeit: Drift-Schema-Versionen werden vorher beim Thread „MyDiet AI Phase 2 entwickeln“ reserviert (v6 = W5 Mikronährstoffe); Feature-Threads mergen nicht selbst, das macht der Thread „Threads überwachen und Updates veröffentlichen“; CHANGELOG-Einträge nur unter „Nächste Version (in Arbeit)“ | keine doppelten Migrationen, keine Release-Konflikte | Patrick / Integrations-Thread |
| D-11 | 2026-11-22 | Eine gemeinsame Aufgabenliste: [AI_TASK_QUEUE.md](AI_TASK_QUEUE.md); ROADMAP.md bleibt die Nutzersicht | keine widersprüchlichen Roadmaps | dieser Thread + Phase-2-Thread |
| D-12 | 2026-11-22 | Keine Gamification (Punkte, Truhen, Streak-Druck) | häufigster Kritikpunkt bei YAZIO/Lifesum, widerspricht „Motivation ohne Druck“ | Wettbewerbsanalyse |
| D-13 | 2026-11-22 | Texteingabe ohne KI-Dienst und ohne neue Abhängigkeit: Regel-Parser im Rechenkern + Suche in der eigenen Datenbank; Ergebnis wird nur nach Bestätigung gespeichert. Spätere Sprach- und KI-Eingabe liefern nur Text bzw. Zeilen an dieselbe Bestätigungsseite | offline, kostenlos, nachvollziehbar; KI bleibt austauschbar und optional (D-07) | dieser Thread |
| D-14 | 2026-11-22 | Rezept-Import liest nur schema.org-Rezeptdaten (JSON-LD) der eingegebenen Adresse, ohne neue Abhängigkeit und ohne Nährwerte der Seite; Zutaten werden mit `parseLine()`/`matchMealText()` aus 3.1 der eigenen Datenbank zugeordnet, Unsicheres muss bestätigt werden | Nährwerte bleiben nachvollziehbar (eigene Lebensmittel), kein Scraping fremder Datenbanken, Seiten ohne Rezeptdaten gehen per eingefügtem Text | Phase-2-Thread |
| D-15 | 2026-11-22 | Garmin und andere Wearables zuerst über Android Health Connect (Paket `health`, nur lesen), nicht über die Garmin-API. Dafür Android-minSdk 26 und `FlutterFragmentActivity`. Direkte Garmin-API (Entwicklerprogramm, Konto) bleibt 6.2 und braucht Patrick | kein eigenes Konto/kein Server nötig, eine Schnittstelle für viele Geräte, Daten bleiben auf dem Gerät; Android 7 und älter verlieren Unterstützung (Health Connect gibt es ab Android 9) | Phase-2-Thread |
