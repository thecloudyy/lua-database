@echo off
setlocal enabledelayedexpansion

color 0E

echo ========================================
echo   Lua Comment Remover
echo   Scanning and removing all comments from .lua files
echo ========================================
echo.

set "LUA_DIR=D:\ryu\lua-database\uploaded"
set "BACKUP_DIR=D:\ryu\lua-database\backup_comments"
set "LOG_FILE=D:\ryu\lua-database\comment_removal_log.txt"

if not exist "%LUA_DIR%" (
    echo [ERROR] Directory not found: %LUA_DIR%
    echo.
    echo Please check your LUA_DIR path.
    pause
    exit /b 1
)

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

echo [1/4] Scanning for .lua files...
echo.

set "total_files=0"
set "modified_files=0"
set "skipped_files=0"

for %%f in ("%LUA_DIR%\*.lua") do (
    set /a total_files+=1
)

echo Total .lua files found: !total_files!
echo.
echo [2/4] Processing files...
echo.

for %%f in ("%LUA_DIR%\*.lua") do (
    set "filename=%%~nf"
    set "filepath=%%f"
    set "has_comments=0"
    
    findstr /b /c:"--" "%%f" >nul 2>nul
    if !errorlevel!==0 (
        set "has_comments=1"
    )
    
    findstr /c:" -- " "%%f" >nul 2>nul
    if !errorlevel!==0 (
        set "has_comments=1"
    )
    
    if !has_comments!==1 (
        set /a modified_files+=1
        echo   Processing: !filename!.lua
        
        copy "%%f" "%BACKUP_DIR%\!filename!.lua.bak" >nul 2>nul
        
        findstr /v /b /c:"--" "%%f" > "%TEMP%\temp_lua.txt"
        findstr /v /c:" -- " "%TEMP%\temp_lua.txt" > "%%f"
        
        echo !filename!.lua >> "%LOG_FILE%"
    ) else (
        set /a skipped_files+=1
    )
)

echo.
echo [3/4] Generating report...

(
    echo ========================================
    echo   Comment Removal Report
    echo ========================================
    echo.
    echo Scan Date: %date% %time%
    echo.
    echo Directory: %LUA_DIR%
    echo.
    echo Total Files Scanned: !total_files!
    echo Files Modified: !modified_files!
    echo Files Skipped: !skipped_files!
    echo.
    echo Modified Files:
    echo.
) > "%LOG_FILE%"

if !modified_files!==0 (
    echo No files needed modification. >> "%LOG_FILE%"
) else (
    for %%f in ("%LUA_DIR%\*.lua") do (
        set "filename=%%~nf"
        set "has_comments=0"
        
        findstr /b /c:"--" "%%f" >nul 2>nul
        if !errorlevel!==0 set "has_comments=1"
        
        findstr /c:" -- " "%%f" >nul 2>nul
        if !errorlevel!==0 set "has_comments=1"
        
        if !has_comments!==0 (
            echo !filename!.lua >> "%LOG_FILE%"
        )
    )
)

echo.
echo [4/4] Done!
echo ========================================
echo   Scan Complete
echo ========================================
echo Total Files Scanned: !total_files!
echo Files Modified: !modified_files!
echo Files Skipped: !skipped_files!
echo.
echo Report saved to: %LOG_FILE%
echo Backups saved to: %BACKUP_DIR%
echo.

if !modified_files!==0 (
    echo [INFO] No comments found. All files are clean!
) else (
    echo [SUCCESS] Removed comments from !modified_files! files.
    echo.
    echo To restore backups, copy from:
    echo   %BACKUP_DIR%
)

echo.
pause