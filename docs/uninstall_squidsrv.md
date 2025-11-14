## Squidsrv or Squid for Windows Uninstallation Guide

#### Identify and Stop the Service
If you installed squidsrv and want to uninstall it because you don’t know how to use it or installed it by mistake, follow this small guide.  
First, run `sc query | findstr -i squid` in Windows terminal. You should see:  
```
D:\Documents\Outils\Squid>sc query | findstr -i squid
SERVICE_NAME: squidsrv
DISPLAY_NAME: Squid for Windows
```
Once you have confirmed `squidsrv`, run `sc stop squidsrv` in an administrator terminal.  
```
C:\WINDOWS\system32>sc stop squidsrv

SERVICE_NAME: squidsrv
        TYPE               : 10  WIN32_OWN_PROCESS
        STATE              : 3  STOP_PENDING
                                (STOPPABLE, NOT_PAUSABLE, ACCEPTS_SHUTDOWN)
        WIN32_EXIT_CODE    : 0  (0x0)
        SERVICE_EXIT_CODE  : 0  (0x0)
        CHECKPOINT         : 0x0
        WAIT_HINT          : 0x0

```

#### Uninstall Web Filtering Proxy
You need to uninstall `Web Filtering Proxy` from `Diladele B.V.` (personally I did this first before seeing that the squidsrv service was still running the next day).  
Look in your Control Panel sorted by recent installs if you installed it recently (by mistake) or search in the top right search bar.  
⚠️ Do not uninstall Squid from the Squid project.  

![uninstall squid filtering proxy](https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/uninstall_web_filetring_proxy.jpg)

Restart to make sure everything is properly released, then run `sc query | findstr -i squid` again in the terminal.  
🟢 If nothing appears, the service has been removed, but you can still check if registry keys and residual files were deleted.  
🔴 If “squidsrv” still appears, we need to go further.

#### Remove Squidsrv
If you are here, it means uninstalling `Web Filtering Proxy` didn’t go well.  
Start by stopping the service again with `sc stop squidsrv`.
Then run `sc delete squidsrv` in the terminal and `Get-Service | Where-Object { $_.Name -like "*squid*" }` in PowerShell as administrator. You should see: 
``` 
PS C:\WINDOWS\system32> sc delete squidsrv 
PS C:\WINDOWS\system32> Get-Service | Where-Object { $_.Name -like "*squid*" } 
Status Name DisplayName 
------ ---- ----------- 
Stopped squidsrv Squid for Windows
```
You should see something like `[SC] DeleteService SUCCESS` confirming the deletion.  
However, you need to restart your computer for Squidsrv to completely disappear from your service list. Try restarting.  
After restarting, run `Get-Service | Where-Object { $_.Name -like "*squid*" }` again.  
🟢 If nothing appears, the service was removed.  
🔴 If “squidsrv” still appears, we need to go deeper; if you are afraid to edit the registry, see the last section to just disable Squidsrv at startup.

#### Edit the Registry
Open the registry editor by typing `regedit` in the Windows Start menu search bar.  
Go to `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\`  
Look for the `squidsrv` folder  
Right-click => Delete  
⚠️ For safety, export the key before deleting (right click > Export).

![Clean Regedit](https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/squidsrv_regedit.jpg)

#### Clean Residual Files (Optional)
If uninstalling `Web Filtering Proxy` did not fully resolve the issue (which is normal), you likely have residual files to clean. You should find them in `C:\Program Files\Diladele\` or `C:\Program Files (x86)\Diladele\`.  
Default locations example: 
``` 
C:\Program Files\Squid\
C:\Program Files\Diladele\
C:\Squid\
```

#### Additional Information
ℹ️ If you have a registry or residual file cleaner software, you can try to use it to see if it offers to remove these files either before or after the registry editing step.  

ℹ️ If you are afraid to force uninstalling, you can simply prevent the service from starting by disabling automatic startup. To do this, use the `Task Scheduler`.  
In it, look for `Squidsrv`, right-click on it > Properties, go to the Trigger tab > delete the startup trigger(s).

[Return to project](https://github.com/tempetflamer/squid_windows_multi_network_interface/tree/main/README.md)