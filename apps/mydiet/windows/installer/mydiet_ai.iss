; Inno Setup script for the Windows installer. Built in CI (.github/workflows/build-apps.yml).
; Per-user install, no admin rights needed.
#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#ifndef SourceDir
  #define SourceDir "..\..\build\windows\x64\runner\Release"
#endif

[Setup]
AppId={{B7D4A2E1-5C3F-4E8B-9A61-2F0C7D9E4B13}
AppName=Sattly
AppVersion={#AppVersion}
AppPublisher=Sattly
; Ordner bleibt aus v0.1.0 ("MyDiet AI"), damit Updates in dieselbe Installation gehen.
DefaultDirName={localappdata}\Programs\MyDiet AI
DefaultGroupName=Sattly
PrivilegesRequired=lowest
OutputBaseFilename=MyDietAI-Setup-{#AppVersion}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\mydiet_ai.exe

[Languages]
Name: "german"; MessagesFile: "compiler:Languages\German.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Sattly"; Filename: "{app}\mydiet_ai.exe"
Name: "{autodesktop}\Sattly"; Filename: "{app}\mydiet_ai.exe"; Tasks: desktopicon

[InstallDelete]
; Verknüpfungen aus der Zeit vor der Umbenennung (v0.1.0 hieß "MyDiet AI") entfernen.
Type: files; Name: "{group}\MyDiet AI.lnk"
Type: files; Name: "{autodesktop}\MyDiet AI.lnk"

[Run]
Filename: "{app}\mydiet_ai.exe"; Description: "{cm:LaunchProgram,Sattly}"; Flags: nowait postinstall skipifsilent
