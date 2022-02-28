@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if not %errorlevel% equ 0 goto :notAdmin

set key="HKCR\*\shell\Pinner"
reg query %key% >nul 2>nul
if %errorlevel% equ 1 goto :isUninstalled
goto :main

:notAdmin
    echo Insufficient permissions. Please run in administrator mode.
    pause
    exit 0

:isUninstalled
    echo Pinner has not been added to the context menu.
    pause
    exit 0

:main
    reg delete "HKCR\*\shell\Pinner" /f >nul 2>nul
    reg delete "HKCR\Directory\shell\Pinner" /f >nul 2>nul

    echo Pinner has been removed from the context menu.
    pause
    exit 0