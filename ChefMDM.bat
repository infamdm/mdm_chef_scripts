@echo off
set HF_URL=https://network.informatica.com/downloadsView.jspa
set EBF_URL=ftp://tsftp:infa123@tsftpint.informatica.com/updates/MDM/hotfixes/Oracle_DB2_SQLServer/
set MDM_SERVER_HOME=c:\infamdm\hub\server
set MDM_CLEANSE_HOME=C:\infamdm\hub\cleanse
set JBOSS_HOME=C:\SREDDY\tools\EAP-6.4.0
set ZK_HOME=C:\infamdm\hub\zookeeper

title MDM CHEF - by Shankar Reddy Teluktula
:menu
cls
set /a _rand=(%RANDOM%*5/32768)+1
set color_rand=%_rand%F
color %color_rand%
                                                 

echo		 	./+ooooos+/-
echo              -syyhhyyhdhdhhdh+.
echo             :yyhhydhhyyhyyhdmmdy:`
echo            :hhdhhso++oossyyysymmho
echo            shddyo:--...`....-:+hd/
echo            shhyso/--..`````..-/oh.
echo            +dys+/:---````.``.-/+y.
echo           .:syo:::////+/..`.:/+s:
echo           ..:o+:.-:+s+///.:+os/o:
echo           ...++/-```.--..`-:://+-
echo           `.-+++:.`````-.`-:...-.
echo             .+++/-.`...-:-//``./`
echo             .oo+:::::/:--://:://
echo           `odooo+:::--:-:/+o///`
echo          .yddo+os+/:-..--::/+/
echo       ./+yhhdy/:/oso+/:://+sdy.
echo  `:/ossyhhhhhy:--:+ssssyydmmmh/-
echo ++sosoooshhhhhhh/---::/+oosyddddy+-``
echo sssooooooyhyyyhdds----://++sdddhssssso+:
echo oossssssssssssooshy-----:+ohdyssoooossss

echo.
echo.
echo    MDM CHEF MENU
echo    =============
echo.
echo    A) create cmx system
echo    B) create ors
echo    C) create mdm_sample
echo    D) upgrade master database
echo    E) upgrade ors database
echo    F) postInstallSetup
echo    G) patchInstallSetup
echo    H) repackageEAR
echo    I) download EBF
echo    J) download Hotfix
echo    K) Start JBoss
echo    L) Start Hub Console
echo    M) tail MDM server logs
echo    N) tail MDM Cleanse logs
echo    O) Check server deployment status

echo.
echo    Z) Exit
echo.
rem choice /C:ABCDEFGHIJKLZ
choice /C:ABCDEFGHIJKLMNOZ /N /M "Option : "

if errorlevel 16 goto done
if errorlevel 15 goto checkServerDeploymentStatus
if errorlevel 14 goto tailCleanseLogs
if errorlevel 13 goto tailServerLogs
if errorlevel 12 goto startHubConsole
if errorlevel 11 goto startJboss
if errorlevel 10 goto download_HF
if errorlevel 9 goto download_EBF
if errorlevel 8 goto repackageEAR
if errorlevel 7 goto patchInstallSetup
if errorlevel 6 goto postInstallSetup
if errorlevel 5 goto updateorsdatabase
if errorlevel 4 goto updatemasterdatabase
if errorlevel 3 goto mdm_sample
if errorlevel 2 goto ors
if errorlevel 1 goto system
echo CHOICE missing
goto done

:done
echo GOOD BYE !!!
exit /b

:checkServerDeploymentStatus
:start
echo # JBOSS DEPLOYMENT STATUS
echo.
cd %JBOSS_HOME%\standalone\deployments\
ls *deploy*
timeout 2 > nul
cls
goto start


:tailCleanseLogs
echo # LAUNCHING CLEANSE LOGS IN SEPARATE WINDOW
start tail -f  %MDM_CLEANSE_HOME%\logs\cmxserver.log
goto menu

:tailServerLogs
echo # LAUNCHING MDM SERVER LOGS IN SEPARATE WINDOW
start tail -f  %MDM_SERVER_HOME%\logs\cmxserver.log
goto menu

:startHubConsole
echo.
echo # LAUNCHING HUB CONSOLE...
echo cleaning java cache files... 
javaws -uninstall
echo Starting Hub Console...
start javaws http://localhost:8080/cmx/siperian-console.jnlp

goto menu

:startJboss
echo.
echo # STARTING JBOSS....
goto startJbossShell
goto menu


:download_HF
echo.
echo # DOWLOAD HOTFIX
START %HF_URL%
goto menu

:download_EBF
echo.
echo # DOWNLOAD EBF
START %EBF_URL%
goto menu

:system
echo.
echo # CREATING SYSTEM...
CALL %MDM_SERVER_HOME%\bin\sip_ant.bat create_system
echo system created. can if you see any errors.
timeout 5
echo.
echo# IMPORTING SYSTEM...
CALL %MDM_SERVER_HOME%\bin\sip_ant.bat import_system
echo importing system done. If you see any errors cancel here.
timeout 5
goto menu

:ors
echo.
echo # CREATING ORS...
CALL %MDM_SERVER_HOME%\bin\sip_ant.bat create_ors
timeout 5
echo.
echo # IMPORTING ORS...
CALL %MDM_SERVER_HOME%\bin\sip_ant.bat import_ors
echo importing ors done. If you see any errors cancel here.
timeout 5
goto menu

:mdm_sampLe
echo.
echo # CREATING ORS LIKE MDM_SAMPLE...
CALL %MDM_SERVER_HOME%\bin\sip_ant.bat create_ors
timeout 5
echo.
echo # IMPORTING SCHEMA LIKE MDM_SAMPLE ...
CALL %MDM_SERVER_HOME%\bin\sip_ant.bat import_schema
echo importing schema  done. If you see any errors cancel here.
timeout 5
goto menu

:updatemasterdatabase
echo.
echo # UPDATING MASTER DATABASE...
CALL %MDM_SERVER_HOME%\bin\sip_ant.bat updatemasterdatabase
timeout 5
goto menu

:updateorsdatabase
echo.
echo  UPDATING ORS DATABASE...
CALL %MDM_SERVER_HOME%\bin\sip_ant.bat updateorsdatabase
timeout 5
goto menu

:postInstallSetup
echo.
echo  RUNNING POST INSTALL SETUP
CALL %MDM_SERVER_HOME%\postInstallSetup.bat
timeout 5
goto menu

:patchInstallSetup
echo.
echo # RUNNING PATCH INSTALL SETUP
CALL %MDM_SERVER_HOME%\patchInstallSetup.bat
timeout 5
goto menu

:repackageEAR
echo.
echo REPACKING EAR
CALL %MDM_SERVER_HOME%\bin\sip_ant.bat repackage
timeout 5
goto menu

:startJbossShell
@echo off
echo # CLEANING ....
echo zookeeper
rm -rdf %ZK_HOME%\version-2
echo solr folder 
rm -rdf %MDM_CLEANSE_HOME%\solr
echo server temp
rm -rdf %MDM_SERVER_HOME%\temp
echo server tmp
rm -rdf %MDM_SERVER_HOME%\tmp
echo server logs
rm -rdf %MDM_SERVER_HOME%\logs
echo cleanse tmp 
rm -rdf  %MDM_CLEANSE_HOME%\tmp
echo cleanse logs
rm -rdf  %MDM_CLEANSE_HOME%\logs
echo completed cleaning.

rem wait for 3 seconds
timeout 3 > NUL

echo # RECREATING FOLDERS
echo  server logs
md %MDM_SERVER_HOME%\logs
echo  cleanse logs
md %MDM_CLEANSE_HOME%\logs
echo  cleanse tmp
md %MDM_CLEANSE_HOME%\tmp

echo  server temp
md %MDM_SERVER_HOME%\temp

echo will start Jboss server in new window....
timeout 3 > NUL

start "JBOSS MDM Server" /HIGH %JBOSS_HOME%\bin\standalone.bat --debug 9797 -c standalone-full.xml -b 0.0.0.0

REM GO TO DEPLOYMENT STATUS WINDOW
rem goto checkServerDeploymentStatus

goto menu
