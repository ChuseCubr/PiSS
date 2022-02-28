@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if not %errorlevel% equ 0 goto :notAdmin
goto :main

:notAdmin
    echo Insufficient permissions. Please run in administrator mode.
    pause
    exit 0

:preInstalled
    echo Gitch has already been added to system PATH.
    pause
    exit 0

:main
    set here=%~dp0
    set here=%here:\command line\=%

    set key="HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    for /f "usebackq tokens=2*" %%a in (`reg query %key% /v PATH`) do set currentPath=%%b

    set notInstalled=!currentPath:;%here%=!
    if not "%notInstalled%"=="%currentPath%" goto :preInstalled

    set newPath=%currentPath%;!here!
    set newPath=%newPath:;;=;%
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path /t REG_EXPAND_SZ /d "%newPath%" /f >nul

    echo A reboot is required to complete installation.
    set /p res="Would you like to restart now? (y/n): "
    if /i "%res%"=="y" shutdown /r /t 5
    exit 0