
## Guide de désinstallation de Squidsrv ou Squid for Windows

#### Identifier et fermer le service
Si vous avez installé squidsrv et que vous voulez le désinstaller parce que vous ne savez pas l'utiliser ou vous l'avez installé par erreur, suivi ce petit guide.
Dans un premier temps, faites `sc query | findstr -i squid` dans le terminal windows. Vous devriez avoir :
```
D:\Documents\Outils\Squid>sc query | findstr -i squid
SERVICE_NAME: squidsrv
DISPLAY_NAME: Squid for Windows
```
Une fois que vous avez confirmé avoir `squidsrv`, faite `sc stop squidsrv` dans un terminal en administrateur.
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

#### Désinstallation de Web Filtering Proxy
Vous devez désinstaller `Web Filtering Proxy` de `Diladele B.V.` ( personnellement je l'ai fait en premier avant de voir que le service squidsrv tourner toujours le lendemain).
Regarder dans votre panneau de configuration en triant par installation récente si vous l'avez installé récement (par erreur) ou recherchez dans la barre de recherche en haut à droite.
⚠️ Ne désinstaller pas Squid de Squid project.

![uninstall squid filtering proxy](https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/uninstall_web_filetring_proxy.jpg)

Redémarrer pour être sûr que tout soit correctement libéré, refaites `sc query | findstr -i squid` dans le terminal.
🟢 Si rien ne s’affiche, le service a bien été supprimé, mais vous pouvez quand même vérifier si les clés de registre et fichiers résiduels ont été supprimés.
🔴 Si “squidsrv” apparaît encore, on va devoir aller plus loin

#### Suppression de Squisrv
Si vous êtes là, c'est que la désinstallation de `Web Filtering proxy` ne s'est pas bien passé.
Commencer par stopper de nouveau le service avec `sc stop squidsrv`.
Ensuite faite `sc delete squidsrv` dans le terminal et `Get-Service | Where-Object { $_.Name -like "*squid*" }` dans powershell en administrateur. vous devriez avoir :
```
PS C:\WINDOWS\system32> sc delete squidsrv 
PS C:\WINDOWS\system32> Get-Service | Where-Object { $_.Name -like "*squid*" } 
Status Name DisplayName 
------ ---- ----------- 
Stopped squidsrv Squid for Windows
```
Normalement, on devrait avoir quelque chose comme `[SC] DeleteService SUCCESS` pour confirmer la suppression.
Cela dit, il faut redémarrer votre ordinateur pour que Squidsrv disparaisse complétement sur votre liste de service. Tenter de redémarrer
Une fois le pc redémarrer faite de nouveau `Get-Service | Where-Object { $_.Name -like "*squid*" }`
🟢 Si rien ne s’affiche, le service a bien été supprimé
🔴 Si “squidsrv” apparaît encore, on va devoir aller plus loin, si vous avez peur d'éditer le registre, aller voir la dernière section pour juste désactiver Squidsrv au démarrage.

#### Éditer le registre
Ouvrer l'éditeur de registre et tapez `regedit` dans la barre de recherche du menu démarrer de Windows.
Allez dans `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\`
Cherchez le dossier `squidsrv`
Clique droit => supprimer
⚠️ Pour plus de prudence, exporter la clé avant suppression (clic droit > Exporter).

![Nettoyer Regedit](https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/squidsrv_regedit.jpg).

#### Nettoyez les fichiers résiduels (facultatif)
Si tout n'a pas été réglé avec une désinstallation (normal) de `Web Filtering Poxy`, il vous reste forcément des fichiers résiduelle à nettoyer, vous devriez les retrouver dans `C:\Program Files\Diladele\` ou `C:\Program Files (x86)\Diladele\`.
Exemples d'emplacement par défaut :
```
C:\Program Files\Squid\
C:\Program Files\Diladele\
C:\Squid\
```

#### Informations complémentaires
ℹ️ Si vous avez un logiciel nettoyeur de registre ou fichier résiduel, vous pouvez essayer de l'utiliser pour voir s'il vous propose de les supprimer que ce soit avant l'étape d'édit du registre ou après.

ℹ️ Si vous avez peur de forcer la désinstallation, vous pouvez toujours juste faire en sorte que le service ne démarre jamais en désactivant le démarrage automatique, pour cela utilisez le `planificateur de tâche`.
Dans celui-ci, chercher `Squidsrv`, faite clique droite sur celui-ci > propriété, allez dans l'onglet déclencheur > supprimer le(s) déclencheur(s) au démarrage.

[Retourner au projet](https://github.com/tempetflamer/squid_windows_multi_network_interface/tree/main/README.fr.md)



