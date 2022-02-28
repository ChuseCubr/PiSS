@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if not %errorlevel% equ 0 goto :notAdmin

set key="HKCR\*\shell\Pinner"
reg query %key% >nul 2>nul
if %errorlevel% equ 0 goto :isInstalled

set here=%~dp0
set here=%here:\context menu\=%
set script=%here%\pin.cmd
echo @py.exe "%here%\pin.py" %%* >%here%\pin.cmd
set regpathfile=HKCR\*\shell\Pinner
set regpathdir=HKCR\Directory\shell\Pinner
set selectMenu[0]="Pin to top"
set selectMenu[1]="Remove pin"
set selectMenu[2]="Move pin up"
set selectMenu[3]="Move pin down"
set selectMenuCommand[0]="-t"
set selectMenuCommand[1]="-r"
set selectMenuCommand[2]="-u"
set selectMenuCommand[3]="-d"

set /a index=1

goto :main

:notAdmin
    echo Insufficient permissions. Please run in administrator mode.
    pause
    exit 0

:isInstalled
    echo Pinner has already been added to the context menu.
    pause
    exit 0

:files
    reg add !regpathfile!\shell\flyout!index! /v "MUIVerb" /d "%~1" /f >nul
    reg add !regpathfile!\shell\flyout!index!\command /d "\"%script%\" %~2 \"%%V\"" /f >nul
    goto :eof

:directoryShell
    reg add !regpathdir!\shell\flyout!index! /v "MUIVerb" /d "%~1" /f >nul
    reg add !regpathdir!\shell\flyout!index!\command /d "@py.exe \"%script%\" %~2 \"%%V\"" /f >nul
    goto :eof

:main
    reg add !regpathfile! /v "MUIVerb" /d "Pin" /f >nul
    reg add !regpathfile! /v "SubCommands" /f >nul

    for /l %%a in (0, 1, 3) do (
        call :files !selectMenu[%%a]! !selectMenuCommand[%%a]!
        set /a index+=1
    )

    set /a index=1

    reg add !regpathdir! /v "MUIVerb" /d "Pin" /f >nul
    reg add !regpathdir! /v "SubCommands" /f >nul

    for /l %%a in (0, 1, 3) do (
        call :directoryShell !selectMenu[%%a]! !selectMenuCommand[%%a]!
        set /a index+=1
    )

    echo Pinner has been added to the context menu.
    pause
    exit 0