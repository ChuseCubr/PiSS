@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if not %errorlevel% equ 0 goto :notAdmin
goto :main

:notAdmin
    echo Insufficient permissions. Please run in administrator mode.
    pause
    exit 0

:isUninstalled
    echo Gitch has not been added to system PATH.
    pause
    exit 0

:main
    set here=%~dp0
    set here=%here:\command line\=%

    set key="HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    for /f "usebackq tokens=2*" %%a in (`reg query %key% /v PATH`) do set currentPath=%%b

    set uninstalled=!currentPath:;%here%=!
    if "%uninstalled%"=="%currentPath%" goto :isUninstalled
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path /t REG_EXPAND_SZ /d "%uninstalled%" /f >nul

    echo A reboot is required to complete installation.
    set /p res="Would you like to restart now? (y/n): "
    if /i "%res%"=="y" shutdown /r /t 5
    exit 0