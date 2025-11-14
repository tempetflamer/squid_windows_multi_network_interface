@echo off
title Squid Diagnostic Tool
color 0E

echo ========================================
echo   SQUID DIAGNOSTIC REPORT
echo ========================================
echo.

echo [1] Network Interfaces Status:
echo ----------------------------------------
netsh interface ip show addresses "Ethernet" 2>nul | findstr "IP Address"
netsh interface ip show addresses "Wi-Fi 2" 2>nul | findstr "IP Address"
netsh interface ip show addresses "Wi-Fi 4" 2>nul | findstr "IP Address"
echo.

echo [2] Expected IPs:
echo ----------------------------------------
echo CPL:  192.168.1.XX (Ethernet)
echo PCIe: 192.168.1.XX (Wi-Fi 2)
echo USB:  192.168.1.XX (Wi-Fi 4)
echo.

echo [3] Squid Processes:
echo ----------------------------------------
tasklist | findstr squid.exe
echo.

echo [4] Listening Ports:
echo ----------------------------------------
netstat -ano | findstr "LISTENING" | findstr "13128 13129 13130"
echo.

echo [5] WiFi Connection Status:
echo ----------------------------------------
netsh wlan show interfaces | findstr "SSID State"
echo.

pause

color