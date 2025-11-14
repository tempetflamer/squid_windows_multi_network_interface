@echo off
title Squid CPL Proxy (13128)
color 0A

echo ========================================
echo   Starting Squid CPL Proxy
echo ========================================
echo.

REM Check if the ports are already in use
netstat -ano | findstr ":13128" >nul 2>&1
if %errorlevel% equ 0 (
    echo [!] Port 13128 already in use!
    echo [!] CPL proxy may already be running
    pause
    color
    exit /b 1
)

echo [*] Cleaning temporary files...
del /Q D:\Documents\Tools\Squid\dev\shm\squid-cf__*cpl*.shm >nul 2>&1
del /Q D:\Documents\Tools\Squid\var\run\squid_cpl.pid >nul 2>&1

echo [*] Starting CPL proxy...
echo.

D:\Documents\Tools\Squid\bin\squid.exe -f D:\Documents\Tools\Squid\etc\squid\squid_cpl.conf -N 2>&1 | findstr /C:"Accepting HTTP" >nul
if %errorlevel% equ 0 (
    echo [+] Proxy started running on 127.0.0.1:13128
    echo [+] Interface: Ethernet CPL (192.168.1.37)
    echo.
    echo ========================================
    echo   Press Ctrl+C to stop this proxy
    echo ========================================
)

D:\Documents\Tools\Squid\bin\squid.exe -f D:\Documents\Tools\Squid\etc\squid\squid_cpl.conf -N

color