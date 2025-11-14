@echo off
title Squid PCIe Proxy (13129) - With Connection Check
color 0A
setlocal enabledelayedexpansion

REM ================================
REM        CONFIGURATION
REM ================================
set "SQUID_PATH=D:\Documents\Tools\Squid"
set "INTERFACE=Wi-Fi 4"
set "SSID=myBox-5GHz"
set "IP_EXPECTED=192.168.1.XX"
set "PORT=13129"
set "CONF_FILE=%SQUID_PATH%\etc\squid\squid_pcie.conf"
set "EXECUTABLE=%SQUID_PATH%\bin\squid.exe"
Rem LOG variable not used 
set "LOG=%SQUID_PATH%\logs\cache_pcie.log"

echo ========================================
echo      Starting Squid PCIe Proxy
echo ========================================
echo.

REM ================================
REM Check if Wi-Fi is connected to the correct SSID
REM ================================
set "CONNECTED=0"
set "ATTEMPT=0"

:CHECK_WIFI
set /a ATTEMPT+=1
echo [*] Checking Wi-Fi connection to "%SSID%" (Attempt %ATTEMPT%/5)...
netsh wlan show interfaces | findstr /C:"SSID" | findstr "%SSID%" >nul 2>nul
if not errorlevel 1 (
    set "CONNECTED=1"
    goto WIFI_CONNECTED
)
echo [!] Not connected, attempting auto-connect...
netsh wlan connect name="%SSID%" interface="%INTERFACE%"
timeout /t 5 /nobreak >nul
if %ATTEMPT% lss 5 goto CHECK_WIFI

if %CONNECTED%==0 (
    echo [!] ERROR: Could not connect to SSID "%SSID%". Aborting.
    pause
    color
    exit /b 1
)

:WIFI_CONNECTED
echo [+] Connected to SSID "%SSID%"


REM ================================
REM Wait until the IP is available
REM ================================
echo [*] Waiting for IP %IP_EXPECTED% on interface "%INTERFACE%"...
set "IP_OK=0"

for /l %%i in (1,1,10) do (
    netsh interface ip show addresses "%INTERFACE%" | findstr "%IP_EXPECTED%" >nul 2>nul
    if not errorlevel 1 (
        set "IP_OK=1"
        goto IP_OK
    )
    timeout /t 2 >nul
)

:IP_OK
if %IP_OK%==0 (
    echo [!] ERROR: IP %IP_EXPECTED% not assigned. Aborting.
    pause
    color
    exit /b 1
)

echo [+] IP %IP_EXPECTED% is now assigned to "%INTERFACE%"

REM ================================
REM Check if the port is already in use
REM ================================
netstat -ano | findstr ":%PORT%" >nul 2>&1
if not errorlevel 1 (
    echo [!] Port %PORT% already in use! Aborting.
    pause
    color
    exit /b 1
)

REM ================================
REM Clean up temporary files
REM ================================
echo [*] Cleaning temporary files...
del /Q "%SQUID_PATH%\dev\shm\squid-cf__*pcie*.shm" >nul 2>&1
del /Q "%SQUID_PATH%\var\run\squid_pcie.pid" >nul 2>&1

REM ================================
REM Launch Squid
REM ================================
echo [*] Starting PCIe proxy...
echo [+] Proxy started running on 127.0.0.1:%PORT%
echo [+] Interface: "%INTERFACE%" (IP: %IP_EXPECTED%)
echo.

"%EXECUTABLE%" -f "%CONF_FILE%" -N

echo.
echo ========================================
echo   Press Ctrl + C to stop the proxy
echo ========================================
echo.
pause

color
