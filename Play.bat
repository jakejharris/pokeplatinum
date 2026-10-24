@echo off
rem One-click launcher for the Pokemon Platinum PC port.
rem Downloads the US ROM (one time), verifies it, then starts the game.
setlocal
cd /d "%~dp0"

set "ROM_URL=https://archive.org/download/4998-pokemon-platinum-version-v-01-u/4998%%20-%%20Pokemon%%20-%%20Platinum%%20Version%%20(v01)%%20(U).nds"
set "ROM_SHA1=0862EC35B24DE5C7E2DCB88C9EEA0873110D755C"

if not exist main.exe (
    echo main.exe not found. Run Play.bat from the same folder as main.exe.
    pause
    exit /b 1
)

if not exist rom.nds (
    echo Downloading the Pokemon Platinum ROM. One time only, about 128 MB...
    curl -L -o rom.nds "%ROM_URL%"
    if errorlevel 1 (
        echo.
        echo Download failed. Check your internet connection and run Play.bat again.
        del rom.nds 2>nul
        pause
        exit /b 1
    )
)

echo Verifying ROM...
for /f %%i in ('powershell -NoProfile -Command "(Get-FileHash -Algorithm SHA1 rom.nds).Hash"') do set "GOT=%%i"
if /i not "%GOT%"=="%ROM_SHA1%" (
    echo.
    echo ROM check failed - the file may be corrupt or the wrong version.
    echo Delete rom.nds and run Play.bat again.
    pause
    exit /b 1
)

echo Starting Pokemon Platinum...
start "" main.exe
endlocal
