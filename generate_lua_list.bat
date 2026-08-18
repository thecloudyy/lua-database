@echo off
setlocal enabledelayedexpansion

color 0B

echo ========================================
echo   Lua List Generator
echo   Scanning uploaded folder for Lua files
echo ========================================
echo.

set "LUA_DIR=D:\ryu\lua-database\uploaded"
set "OUTPUT_FILE=D:\ryu\lua-database\lua_list.json"
set "TEMP_FILE=%TEMP%\lua_list_temp.json"

:: Check if directory exists
if not exist "%LUA_DIR%" (
    echo [ERROR] Directory not found: %LUA_DIR%
    echo.
    echo Please check your LUA_DIR path.
    pause
    exit /b 1
)

echo [1/3] Scanning for Lua files...
echo.

:: Count files first
set "counter=0"
for %%f in ("%LUA_DIR%\*.lua") do set /a counter+=1

if !counter!==0 (
    echo No .lua files found in: %LUA_DIR%
    echo.
    pause
    exit /b 1
)

echo Found !counter! Lua files.
echo.
echo [2/3] Generating JSON...

:: Generate JSON using PowerShell (faster and cleaner)
powershell -ExecutionPolicy Bypass -Command "
$LUA_DIR = '%LUA_DIR%'
$OUTPUT_FILE = '%OUTPUT_FILE%'
$appids = Get-ChildItem -Path $LUA_DIR -Filter '*.lua' | ForEach-Object { $_.BaseName }
$json = @{
    generated = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    count = $appids.Count
    appids = $appids
}
$json | ConvertTo-Json -Depth 3 | Set-Content -Path $OUTPUT_FILE -Encoding UTF8
"

echo.
echo [3/3] Done!
echo ========================================
echo Output saved to: %OUTPUT_FILE%
echo Total apps: !counter!
echo ========================================
echo.

:: Display file size
for %%a in ("%OUTPUT_FILE%") do (
    set "file_size=%%~za"
    set /a "file_size_mb=!file_size! / 1048576"
    set /a "file_size_kb=!file_size! / 1024"
    if !file_size_mb! gtr 0 (
        echo File size: !file_size_mb! MB
    ) else (
        echo File size: !file_size_kb! KB
    )
)

echo.
pause