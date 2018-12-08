!define APPNAME "Herunterfahren"
!define COMPANYNAME "SharkByte"
!define DESCRIPTION "Herunterfahren Desktop-Icon"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\German.nlf"
RequestExecutionLevel admin
InstallDir "$PROGRAMFILES\Shutdown"
LicenseData "License.txt"
Name "${COMPANYNAME} - ${APPNAME}"
Icon "icon.ico"
outFile "shutdown desktop-icon installer.exe"
!include LogicLib.nsh
Page license
Page directory
Page instfiles
!macro VerifyUserIsAdmin
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" 
        messageBox mb_iconstop "Administrator rights required!"
        setErrorLevel 740 
        quit
${EndIf}
!macroend
function .onInit
	setShellVarContext all
	!insertmacro VerifyUserIsAdmin
functionEnd
 
section "install"
	
	SetOutPath $INSTDIR
	
	File "stop.exe"
	CreateShortCut "$DESKTOP\Herunterfahren.lnk" "$INSTDIR\stop.exe" "" "$INSTDIR\icon.ico"
	File "icon.ico"
	File "License.txt"
	File "Quelle.cpp"

	writeUninstaller "$INSTDIR\uninstall.exe"
 

	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayName" "${COMPANYNAME} - ${APPNAME} - ${DESCRIPTION}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "Publisher" "$\"${COMPANYNAME}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayIcon" "$\"$INSTDIR\icon.ico$\""
	# There is no option for modifying or repairing the install
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoRepair" 1
	# Set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "EstimatedSize" ${INSTALLSIZE}
sectionEnd
 
# Uninstaller
 
function un.onInit
	SetShellVarContext all
 
	#Verify the uninstaller - last chance to back out
	MessageBox MB_OKCANCEL "Wollen sie wirklich ${APPNAME} entfernen?" IDOK next
		Abort
	next:
	!insertmacro VerifyUserIsAdmin
functionEnd
 
section "uninstall"
 
	# Remove Start Menu launcher
	delete "$DESKTOP\Herunterfahren.lnk"
	# Try to remove the Start Menu folder - this will only happen if it is empty

	# Remove files
	Delete $INSTDIR\stop.exe
	Delete $INSTDIR\icon.ico
	Delete $INSTDIR\Quelle.cpp
	Delete $INSTDIR\License.txt
	Delete $INSTDIR\icon.ico
	
	
	Delete $INSTDIR\uninstall.exe
 
	# Try to remove the install directory - this will only happen if it is empty
	rmDir $INSTDIR
 
	# Remove uninstaller information from the registry
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}"
sectionEnd