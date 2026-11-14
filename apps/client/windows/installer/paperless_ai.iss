; Inno Setup script for the Windows installer. Built in CI (.github/workflows/build-apps.yml).
; Per-user install, no admin rights needed.
#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#ifndef SourceDir
  #define SourceDir "..\..\build\windows\x64\runner\Release"
#endif

[Setup]
AppId={{6F1E2D3C-8B7A-4C5D-9E0F-1A2B3C4D5E6F}
AppName=Paperless AI
AppVersion={#AppVersion}
AppPublisher=Paperless AI
DefaultDirName={localappdata}\Programs\Paperless AI
DefaultGroupName=Paperless AI
PrivilegesRequired=lowest
OutputBaseFilename=PaperlessAI-Setup-{#AppVersion}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\paperless_ai.exe

[Languages]
Name: "german"; MessagesFile: "compiler:Languages\German.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Paperless AI"; Filename: "{app}\paperless_ai.exe"
Name: "{autodesktop}\Paperless AI"; Filename: "{app}\paperless_ai.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\paperless_ai.exe"; Description: "{cm:LaunchProgram,Paperless AI}"; Flags: nowait postinstall skipifsilent
