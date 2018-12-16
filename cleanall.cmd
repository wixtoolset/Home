@echo off
PUSHD %~dp0..

IF EXIST WixBuildTools (CALL :DoAction WixBuildTools %*)
IF EXIST Data (CALL :DoAction Data %*)
IF EXIST Extensibility (CALL :DoAction Extensibility %*)
IF EXIST dutil (CALL :DoAction dutil %*)
IF EXIST wcautil (CALL :DoAction wcautil %*)
IF EXIST Dtf (CALL :DoAction Dtf %*)
IF EXIST Core.Native (CALL :DoAction Core.Native %*)
IF EXIST Core (CALL :DoAction Core %*)
IF EXIST Tools (CALL :DoAction Tools %*)
IF EXIST LegacyTools (CALL :DoAction LegacyTools %*)
IF EXIST Util.wixext (CALL :DoAction Util.wixext %*)
IF EXIST Firewall.wixext (CALL :DoAction Firewall.wixext %*)
IF EXIST NetFx.wixext (CALL :DoAction NetFx.wixext %*)
IF EXIST Sql.wixext (CALL :DoAction Sql.wixext %*)
IF EXIST VisualStudio.wixext (CALL :DoAction VisualStudio.wixext %*)
@rem IF EXIST Setup (CALL :DoAction Setup %*)
@rem IF EXIST VisualStudioExtension (CALL :DoAction VisualStudioExtension %*)

POPD
GOTO :EOF

:DoAction

SET _D=%1
SHIFT

PUSHD %_D%

ECHO Cleaning %_D%
IF EXIST build (RD /S /Q build)
IF EXIST packages (RD /S /Q packages)

POPD
GOTO :EOF