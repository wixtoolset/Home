@echo off
PUSHD %~dp0..

IF EXIST WixBuildTools (CALL :DoAction WixBuildTools %*)
IF EXIST Data (CALL :DoAction Data %*)
IF EXIST Extensibility (CALL :DoAction Extensibility %*)
IF EXIST dutil (CALL :DoAction dutil %*)
IF EXIST wcautil (CALL :DoAction wcautil %*)
IF EXIST Dtf (CALL :DoAction Dtf %*)
IF EXIST BootstrapperCore (CALL :DoAction BootstrapperCore %*)
IF EXIST balutil (CALL :DoAction balutil %*)
IF EXIST burn (CALL :DoAction burn %*)
IF EXIST Core.Native (CALL :DoAction Core.Native %*)
IF EXIST Core (CALL :DoAction Core %*)
IF EXIST Tools (CALL :DoAction Tools %*)
IF EXIST LegacyTools (CALL :DoAction LegacyTools %*)
IF EXIST Util.wixext (CALL :DoAction Util.wixext %*)
IF EXIST Bal.wixext (CALL :DoAction Bal.wixext %*)
IF EXIST Firewall.wixext (CALL :DoAction Firewall.wixext %*)
IF EXIST Iis.wixext (CALL :DoAction Iis.wixext %*)
IF EXIST Msmq.wixext (CALL :DoAction Msmq.wixext %*)
IF EXIST NetFx.wixext (CALL :DoAction NetFx.wixext %*)
IF EXIST PowerShell.wixext (CALL :DoAction PowerShell.wixext %*)
IF EXIST Sql.wixext (CALL :DoAction Sql.wixext %*)
IF EXIST Tag.wixext (CALL :DoAction Tag.wixext %*)
IF EXIST UI.wixext (CALL :DoAction UI.wixext %*)
IF EXIST VisualStudio.wixext (CALL :DoAction VisualStudio.wixext %*)
@rem IF EXIST Setup (CALL :DoAction Setup %*)
@rem IF EXIST VisualStudioExtension (CALL :DoAction VisualStudioExtension %*)

POPD
GOTO :EOF

:DoAction

SET _D=%1
SHIFT

PUSHD %_D%
ECHO %_D% executing: %1 %2 %3 %4 %5 %6 %7 %8 %9

CMD /C %1 %2 %3 %4 %5 %6 %7 %8 %9
rem START /D %1 /WAIT %2 %3 %4 %5 %6 %7 %8 %9

POPD
GOTO :EOF