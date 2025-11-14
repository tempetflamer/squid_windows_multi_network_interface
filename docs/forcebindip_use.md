## Using ForceBindIP

### What is ForceBindIP?
ForceBindIP is a free utility for Windows that allows forcing an application to use a specific network interface or local IP address.
It works by injecting a DLL into the target application's process to redirect its network calls to the chosen interface.

### Installation

1. Download [ForceBindIP <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-external-link-icon lucide-external-link"><path d="M15 3h6v6"/><path d="M10 14 21 3"/><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/></svg>](https://r1ch.net/projects/forcebindip).
2. Install it via the installer, or unzip the files if you took the ZIP version.
3. For 32-bit systems, the files ForceBindIP.exe and BindIP.dll are placed in C:\Windows\System32\.
   For 64-bit systems, they are placed in C:\Windows\SysWOW64\.
   Note: On 64-bit, to be able to run ForceBindIP from the command line anywhere, manually copy these two files into C:\Windows\System32\.
4. Make sure you have the Visual Studio 2015 Runtimes (x86 and x64) installed, required for operation.

### Adding Environment Variables
- Press the `Windows` key.
- Type `variables`.
- Select `Edit the system environment variables`.
- Click `Environment Variables...`.
- Find `Path` in the user variables.
- Select it and click `Edit`.
- Click `New`.
- Add the ForceBindIP folder path, for example: `C:\Program Files (x86)\ForceBindIP`.
- Click `OK`, `OK`, `Apply` (if available), then `OK`.

If ForceBindIP is already present, there is no need to add it again.

<p>
  <img src="https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/forcebindip/variables_environnement_0.jpg" alt="search variables environnement in search bar " height="460"/>
  <img src="https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/forcebindip/variables_environnement_1.jpg" alt="variables environnement first step" height="460"/>
  <img src="https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/forcebindip/variables_environnement_2.jpg" alt="variables environnement second step" height="460"/>
  <img src="https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/forcebindip/variables_environnement_3.jpg" alt="variables environnement third step" height="460"/>
</p>


### Usage

Once installed and the `Path` is set in the environment variables, open a command prompt (cmd) as administrator (`Windows` key, type `cmd`, then `Run as administrator`).

Basic command:
`ForceBindIP <local_IP_address_to_bind> "<path_to_executable>"`

Run `ipconfig` in cmd to find the IPs of your network cards. Connected network cards are those where `lan` appears after `Connection-specific DNS Suffix`.

Examples:
`ForceBindIP -i 192.168.1.37 "C:\path\app.exe"`

### Limitations

This method is now very limited. Most recent applications are no longer affected by this technique, including web browsers.

[Return to project](https://github.com/tempetflamer/squid_windows_multi_network_interface/tree/main/README.md)
