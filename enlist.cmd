@ECHO off
SETLOCAL
SET _P=%~dp0

:NextArg
IF /I "%1"=="data" (CALL :Enlist Data& SET _E=1)
IF /I "%1"=="dutil" (CALL :Enlist dutil& SET _E=1)
IF /I "%1"=="extensibility" (CALL :Enlist Extensibility& SET _E=1)
IF /I "%1"=="core" (CALL :Enlist Core& SET _E=1)
IF /I "%1"=="core.native" (CALL :Enlist Core.Native& SET _E=1)
IF /I "%1"=="corenative" (CALL :Enlist Core.Native& SET _E=1)
IF /I "%1"=="legacytools" (CALL :Enlist LegacyTools& SET _E=1)
IF /I "%1"=="native" (CALL :Enlist Core.Native& SET _E=1)
IF /I "%1"=="tools" (CALL :Enlist Tools& SET _E=1)
if /I "%1"=="visualstudioextension"  (CALL :Enlist VisualStudioExtension& SET _E=1)
if /I "%1"=="votive"  (CALL :Enlist VisualStudioExtension& SET _E=1)
IF /I "%1"=="wcautil" (CALL :Enlist wcautil& SET _E=1)
IF /I "%1"=="firewall" (CALL :Enlist Firewall.wixext& SET _E=1)
IF /I "%1"=="netfx" (CALL :Enlist NetFx.wixext& SET _E=1)
IF /I "%1"=="util" (CALL :Enlist Util.wixext& SET _E=1)
IF /I "%1"=="vs.wixext" (CALL :Enlist VisualStudio.wixext& SET _E=1)
IF "%1"=="" GOTO :Done

IF /I "%1"=="-?" GOTO :Syntax
IF /I "%1"=="/?" GOTO :Syntax
IF /I "%1"=="-h" GOTO :Syntax
IF /I "%1"=="/h" GOTO :Syntax

IF "%_E%"=="" ECHO Error: Unknown project name: %1
SHIFT
GOTO NextArg

:Done
IF "%_E%"=="" GOTO :NoProjects

IF NOT EXIST %_P%..\nuget.config COPY /Y %_P%nuget.config %_P%..\nuget.config

ECHO.
ENDLOCAL
GOTO :EOF


:Enlist

SET _C=%~dp0
PUSHD %_C%..

ECHO.
ECHO Enlisting %1 to: %CD%\%1 ...

IF NOT EXIST WixToolset.sln dotnet new sln -n WixToolset || GOTO :EnlistDone

git clone https://github.com/wixtoolset/%1.git || GOTO :EnlistDone
FOR /R %1 %%F IN (*.csproj) DO dotnet sln WixToolset.sln add %%~fF || GOTO :EnlistDone
FOR /R %1 %%F IN (*.vcxproj) DO echo "%%~fF" must be manually added to WixToolset.sln.
FOR /R %1 %%F IN (*.wixproj) DO echo "%%~fF" must be manually added to WixToolset.sln.

:EnlistDone
POPD
GOTO :EOF

:NoProjects
ECHO Error: You must specify at least one valid project to enlist.
ECHO.

:Syntax
ECHO Syntax: enlist project
ECHO.
ECHO   Available projects:
ECHO     Core
ECHO     Core.Native
ECHO     Data
ECHO     dutil
ECHO     Extensibility
ECHO     VisualStudioExtension
ECHO     wcautil
ECHO.
ECHO   Extension projects:
ECHO     firewall
ECHO     netfx
ECHO     util
ECHO     vs.wixext
ECHO.
