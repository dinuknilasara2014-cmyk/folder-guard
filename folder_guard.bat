@echo off
:: ============================================
::  FOLDER GUARD - Simple Backup & Lock Tool
:: ============================================
title Folder Guard
color 0A

:menu
cls
echo ===============================================
echo             FOLDER GUARD MENU
echo ===============================================
echo  1. Backup a folder
echo  2. Lock a folder (hide + password)
echo  3. Unlock a folder
echo  4. Exit
echo ===============================================
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto backup
if "%choice%"=="2" goto lock
if "%choice%"=="3" goto unlock
if "%choice%"=="4" exit
goto menu

:backup
cls
echo ===============================================
echo               BACKUP FOLDER
echo ===============================================
set /p src="Enter full path of folder to backup: "
if not exist "%src%" (
    echo.
    echo ERROR: That folder does not exist!
    pause
    goto menu
)

set backupname=Backup_%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set backupname=%backupname: =0%
set dest=%src%_%backupname%

echo.
echo Copying files, please wait...
xcopy "%src%" "%dest%\" /E /I /H /Y >nul

echo.
echo Backup completed successfully!
echo Backup saved at: %dest%
pause
goto menu

:lock
cls
echo ===============================================
echo               LOCK FOLDER
echo ===============================================
set /p folder="Enter full path of folder to lock: "

if not exist "%folder%" (
    echo.
    echo ERROR: Folder not found!
    pause
    goto menu
)

set /p pass="Set a password for unlocking: "
echo %pass% > "%folder%\.lockkey.txt"

attrib +h +s "%folder%"
attrib +h +s "%folder%\.lockkey.txt"

echo.
echo Folder locked and hidden successfully!
echo Remember your password: %pass%
pause
goto menu

:unlock
cls
echo ===============================================
echo              UNLOCK FOLDER
echo ===============================================
set /p folder="Enter full path of the locked folder: "

if not exist "%folder%\.lockkey.txt" (
    attrib -h -s "%folder%" 2>nul
    if not exist "%folder%\.lockkey.txt" (
        echo.
        echo ERROR: This folder is not locked or key missing!
        pause
        goto menu
    )
)

set /p userpass="Enter password: "
set /p realpass=<"%folder%\.lockkey.txt"

if "%userpass%"=="%realpass%" (
    attrib -h -s "%folder%"
    attrib -h -s "%folder%\.lockkey.txt"
    del "%folder%\.lockkey.txt"
    echo.
    echo Folder unlocked successfully!
) else (
    attrib +h +s "%folder%"
    echo.
    echo WRONG PASSWORD! Folder remains locked.
)
pause
goto menu