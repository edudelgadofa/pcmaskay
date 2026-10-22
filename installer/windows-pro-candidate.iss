; Experimental per-user installer for Recoll Windows Pro.
; Deliberately separate from upstream installer/recoll.iss.
; Package candidate is not a certified or production-ready release.
#define MyAppName "Recoll Windows Pro (Experimental)"
#define MyAppVersion "0.1.0"
#define MyAppPublisher "Community development build"
#define MyAppURL "https://github.com/edudelgadofa/pcmaskay"

[Setup]
AppId={{77A7AA5C-62A8-46E0-BE70-61FC1E94BE27}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
DefaultDirName={localappdata}\Programs\RecollWindowsPro
DefaultGroupName={#MyAppName}
UninstallDisplayIcon={app}\recoll.exe
OutputDir=..\output
OutputBaseFilename=Recoll-Windows-Pro-EXPERIMENTAL-Setup
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest
UsePreviousAppDir=no
DisableProgramGroupPage=yes
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
LicenseFile=..\src\COPYING
SetupIconFile=..\src\desktop\recoll.ico
SetupLogging=yes
CloseApplications=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional shortcuts:"; Flags: unchecked

[Files]
Source: "..\candidate\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\Recoll Windows Pro (Experimental)"; Filename: "{app}\recoll.exe"; WorkingDir: "{app}"
Name: "{autodesktop}\Recoll Windows Pro (Experimental)"; Filename: "{app}\recoll.exe"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
Filename: "{app}\recoll.exe"; Description: "Launch Recoll Windows Pro (Experimental)"; Flags: nowait postinstall skipifsilent
