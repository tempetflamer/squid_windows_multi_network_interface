Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "taskkill /F /IM squid.exe", 0, False
