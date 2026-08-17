@echo off
setlocal enabledelayedexpansion

echo ========================================
echo   Lua List Generator
echo   Scanning uploaded folder for Lua files
echo ========================================
echo.

set "LUA_DIR=D:\ryu\uploaded\uploaded"
set "OUTPUT_FILE=D:\ryu\uploaded\lua_list.json"

echo [1/2] Scanning for Lua files...

:: Create JSON file
echo { > "%OUTPUT_FILE%"
echo   "generated": "%date% %time%", >> "%OUTPUT_FILE%"

:: Count files and build list
set "counter=0"
set "first_item=1"

for %%f in ("%LUA_DIR%\*.lua") do (
    set "filename=%%~nf"
    set /a counter+=1
    
    if !first_item!==0 (
        echo     }, >> "%OUTPUT_FILE%"
    )
    
    echo     { >> "%OUTPUT_FILE%"
    echo       "appid": "!filename!" >> "%OUTPUT_FILE%"
    
    set "first_item=0"
)

:: Close JSON
if !first_item!==0 (
    echo     } >> "%OUTPUT_FILE%"
)

echo   ] >> "%OUTPUT_FILE%"
echo } >> "%OUTPUT_FILE%"

echo.
echo [2/2] Done!
echo ========================================
echo Output saved to: %OUTPUT_FILE%
echo Total apps: !counter!
echo ========================================
pause