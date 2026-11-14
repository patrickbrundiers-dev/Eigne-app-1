# Server unterwegs erreichen mit Tailscale

Tailscale verbindet deine Geräte über ein privates, verschlüsseltes Netz. Das Handy erreicht
den Paperless-Server auf deinem PC dann auch unterwegs, ohne dass im Router etwas geöffnet
wird. Für private Nutzung ist Tailscale kostenlos.

## Einmalig einrichten (etwa 10 Minuten)

1. Auf dem PC [Tailscale für Windows](https://tailscale.com/download/windows) installieren
   und mit einem Konto anmelden (zum Beispiel mit deinem Google-Konto).
2. Auf dem Handy die Tailscale-App aus dem Play Store installieren und mit **demselben** Konto
   anmelden.
3. In der [Tailscale-Verwaltung](https://login.tailscale.com/admin/dns) unter **DNS**
   „MagicDNS“ und „HTTPS Certificates“ einschalten.
4. Den Paperless-Server auf dem PC starten (er lauscht auf `127.0.0.1:8000`).
5. In der Eingabeaufforderung auf dem PC einmal ausführen:

   ```
   tailscale serve --bg 8000
   ```

   Tailscale zeigt dann eine Adresse wie `https://mein-pc.tail1234.ts.net`. Sie ist nur in
   deinem Tailscale-Netz erreichbar und hat automatisch ein gültiges HTTPS-Zertifikat.
6. In der Paperless-App auf Handy und PC diese Adresse als **Server** eintragen und anmelden.

## Gut zu wissen

- Unterwegs muss die Tailscale-App auf dem Handy eingeschaltet sein. Der PC muss laufen.
- Ist der PC aus, arbeitet die App mit dem zuletzt synchronisierten Stand weiter. Neue Scans
  werden hochgeladen, sobald der PC wieder erreichbar ist.
- Weitere Familienmitglieder lädst du in der Tailscale-Verwaltung ein oder teilst nur den PC
  mit ihnen („Share“). Ihre Rechte in Paperless bleiben davon unberührt.
- Später lässt sich der Server ohne Umbau auf einen kleinen Mietserver umziehen; in der App
  ändert sich dann nur die Adresse.
