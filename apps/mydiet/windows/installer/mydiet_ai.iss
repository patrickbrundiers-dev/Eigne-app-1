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
AppName=MyDiet AI
AppVersion={#AppVersion}
AppPublisher=MyDiet AI
DefaultDirName={localappdata}\Programs\MyDiet AI
DefaultGroupName=MyDiet AI
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
Name: "{group}\MyDiet AI"; Filename: "{app}\mydiet_ai.exe"
Name: "{autodesktop}\MyDiet AI"; Filename: "{app}\mydiet_ai.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\mydiet_ai.exe"; Description: "{cm:LaunchProgram,MyDiet AI}"; Flags: nowait postinstall skipifsilent
