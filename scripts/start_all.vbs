Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "D:\Documents\Tools\Squid\start_squid_usb_with_check.bat", 0, False
WshShell.Run "D:\Documents\Tools\Squid\start_squid_pcie_with_check.bat", 0, False
WshShell.Run "D:\Documents\Tools\Squid\start_squid_cpl.bat", 0, False