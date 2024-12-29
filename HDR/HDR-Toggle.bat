@echo off
REM Relies on HDRCmd.exe from https://github.com/res2k/HDRTray
REM Run the HDR status command and capture the output
for /f "tokens=*" %%i in ('HDRCmd.exe status -m s') do set "statusOutput=%%i"

REM Check if HDR is currently on or off
echo %statusOutput% | findstr /C:"HDR is on" >nul
if %errorlevel% equ 0 (
    REM If HDR is on, turn it off
    HDRCmd.exe off
    echo HDR has been turned off.
) else (
    REM If HDR is off, turn it on
    HDRCmd.exe on
    echo HDR has been turned on.
)