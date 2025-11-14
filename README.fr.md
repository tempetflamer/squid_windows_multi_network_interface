[![EN](https://img.shields.io/badge/lang-EN-red.svg)](https://github.com/tempetflamer/squid_windows_multi_network_interface/tree/main/README.md) [![FR](https://img.shields.io/badge/lang-FR-blue.svg)](https://github.com/tempetflamer/squid_windows_multi_network_interface/tree/main/README.fr.md)

# Acheminer différentes applications Windows via différentes interfaces réseau à l'aide du proxy Squid

## Table des matières
- [Acheminer différentes applications Windows via différentes interfaces réseau à l'aide du proxy Squid](#acheminer-différentes-applications-windows-via-différentes-interfaces-réseau-à-laide-du-proxy-squid)
  - [Table des matières](#table-des-matières)
  - [Genèse du projet](#genèse-du-projet)
  - [Pour qui ?](#pour-qui-)
  - [Cas d'usage possible](#cas-dusage-possible)
    - [Usage personnel (exemple)](#usage-personnel-exemple)
    - [Gaming + Streaming](#gaming--streaming)
    - [Développeurs / Testeurs / Administrateurs Réseaux](#développeurs--testeurs--administrateurs-réseaux)
  - [Limitations / informations](#limitations--informations)
  - [Prérequis](#prérequis)
    - [installer Squid](#installer-squid)
  - [Commandes utile](#commandes-utile)
  - [Démarrage du projet](#démarrage-du-projet)
    - [Récupération des IPs](#récupération-des-ips)
    - [Vérifications des ports utilisés et utilisables](#vérifications-des-ports-utilisés-et-utilisables)
    - [Réservations des ports utilisables](#réservations-des-ports-utilisables)
    - [Création des fichiers de configuration](#création-des-fichiers-de-configuration)
    - [Créations des scripts étape par étape](#créations-des-scripts-étape-par-étape)
  - [Connection sur Firefox par proxy](#connection-sur-firefox-par-proxy)
  - [Rangez vos exécutables](#rangez-vos-exécutables)
  - [Structure finale du projet](#structure-finale-du-projet)
  - [Lancement automatique des scripts au démarrage de Windows](#lancement-automatique-des-scripts-au-démarrage-de-windows)
  - [Erreurs](#erreurs)
  - [FAQ](#faq)

## Genèse du projet

Après être passé à la fibre, j'ai dû faire passer ma connexion par CPL, ce qui était catastrophique en termes de stabilité et débit, sachant qu'il peut y'avoir une autre personne sur la connexion, et c'est récemment en changeant pour une carte PCIe que je me suis demandé si je pouvais avoir & utiliser plusieurs connexions internet sur Windows, et donc comment procéder.

Aujourd'hui il existe deux méthodes, l'addition de ces connexions qui offre stabilité, mais beaucoup de perte et la séparation des flux par tâche
Addition des débits => Speedify, Connectify, pfSense
Séparation des tâches selon la carte réseau => ForceBindIP, Proxifier, routes manuelles

Dans notre cas, on va s'intéresser à la séparation des tâches, mais les logiciels sont soit dépassé, ForceBindIp ne marche pas sur un navigateur moderne, soit payant comme Proxifier et reste malgré tout assez limité. Bref on ne va pas faire tous les cas, au finale on va devoir faire du routage manuel (proxy).
Je partage cette méthode due au peu de ressources à ce sujet malgré ce projet bricolage.

[tuto d'installation et d'utilisation de ForceBindIp rapidement](https://github.com/tempetflamer/squid_windows_multi_network_interface/tree/main/docs/forcebindip_use.fr.md)

Dans ce petit tuto, on verra comment utiliser Squid en proxy pour Firefox, Chrome et Edge eux semble utiliser le proxy de l'ordinateur, il vous sera donc plus compliqué de séparer par instance de navigateurs.

## Pour qui ?

Ce tuto est donc destiné à ceux qui ne peuvent pas tirer pleinement parti de la connexion de leur box internet, parce qu'ils ne peuvent pas être directement connectés à leur routeur, et qu'il reste encore beaucoup de débit disponible à l'usage sur la / les bande(s) WIFI.

Il est possible que votre routeur vous laisse la possibilité de séparer le flux en plusieurs bandes 5GHz par exemple (moi, je n'ai pas cette possibilité).
Aussi, certains routeurq internet ne permettent pas d'avoir le débit maximal de celui-ci sur le Wifi.
Comme Free en France avec son débit partagé sur la freebox pop par exemple.

## Cas d'usage possible

### Usage personnel (exemple)

```

┌───────────────────┐
│     Streaming     │---> Proxy 127.0.0.1:13130 ---> Interface USB (192.168.1.XX) ---> Internet
└───────────────────┘

┌───────────────────┐
│  Téléchargements  │---> Proxy 127.0.0.1:13129 ---> Interface PCIe (192.168.1.XX) ---> Internet
└───────────────────┘

┌──────────────────┐
│   Usage léger    │---> Proxy 127.0.0.1:13128 ---> Interface CPL (192.168.1.XX)  ---> Internet
└──────────────────┘
```

### Gaming + Streaming

```

┌───────────────────┐
│     Navigation    │---> Proxy 127.0.0.1:13130 ---> Interface USB (192.168.1.XX) ---> Internet
└───────────────────┘

┌───────────────────┐
│        Jeu        │---> Proxy 127.0.0.1:13129 ---> Interface PCIe (192.168.1.XX) ---> Internet
└───────────────────┘

┌──────────────────┐
│    Stream OBS    │---> Proxy 127.0.0.1:13128 ---> Interface CPL (192.168.1.XX)  ---> Internet
└──────────────────┘
```

### Développeurs / Testeurs / Administrateurs Réseaux
Permet de testers les différentes connexions et des applications via ses différentes connexions.

Et autres...


## Limitations / informations
- Tutoriel pour Windows
- Il est impossible sur Windows d'utiliser le même SSID pour deux cartes internet différentes, même si les deux se connectent, ils utiliseront en réalité par alternance / priorité la connexion.
- Fait pour du local dans mon utilisation, si vous voulez partager, changez 127.0.0.1 par 0.0.0.0 mais ajoutez un sytème d'authentification pour sécuriser.
- Fait sous Windows 10

J'utiliserais une connexion par CPL, par Carte PCIe et par Clé Wi-Fi dans ce tuto.

Je vais essayer de parler à des débutants pour ouvrir ce projet au plus grand nombre d'intéressés, désolé si vous me trouvez verbeux pour rien.



## Prérequis
Connectez-vous aux réseaux avec vos différents moyens de connexions pour rentrer le mot de passe et enregistrer la connexion sous Windows.
Si vous avez plusieurs connexions Wifi, allez dans l'icone wifi en bas à droite, puis connecter vous au réseau pour chaques connexions.
<p>
  <img src="https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/change_wifi_connection1.jpg" alt="Connexion WIFI" width="220"/>
  <img src="https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/change_wifi_connection2.jpg" alt="Changer de connexion WIFI" width="220"/>
</p>

Télécharger le navigateur Firefox si vous voulez vérifier la connexion proxy avec le tutoriel sinon utilisez n'importe quelle application qui permet le proxy.

Être sous Windows. Réalisé sous Windows 10.



### installer Squid

On commence par installer Squid pour Windows, c'est tout ce qu'on utilisera, on prend la version Console App appelée "Squid for Windows"
[Squid <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-external-link-icon lucide-external-link"><path d="M15 3h6v6"/><path d="M10 14 21 3"/><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/></svg>](https://squid.diladele.com/)

Si vous avez installé le web proxy for windows par erreur, vous pouvez suivre ce guide de mon expérience pour le désinstaller (à part si vous savez l'utiliser bien sûr)

[tuto de désinstallation de Squid Web proxy](https://github.com/tempetflamer/squid_windows_multi_network_interface/tree/main/docs/uninstall_squidsrv.fr.md)

Une fois téléchargé un fichier nommé squid.msi, exécutez-le et suivez les étapes, choisissez l'emplacement de votre projet, attention mettez bien "Squid" dans l'emplacement de l'installation sinon l'installeur installera à la racine. Vous pouvez installer dans vos `Programme File` si vous le voulez, personnellement je l'ai mis sous `D:\Documents\Outils\Squid`.

Une fois installé vous devrez avoir
``` 
Squid/
├── bin/
├── dev/
│   └── shm/
├── etc/
│   └── squid/
├── logs/
├── usr/
└── var/
```

- À la racine du projet dans `Squid`, on mettra nos différents scripts pour la gestion des proxys
- Dans `bin/` nous retrouverons le lanceur `squid.exe`, on n'aura pas besoin de toucher ce dossier.
- Dans `dev/shm/`, on retrouvera les fichiers temporaire et partagé .shm qui peuve provoqué des bugs, normalement vous n'aurez pas besoin d'y toucher.
- Dans `etc/squid/`, nous mettrons nos fichiers de configuration `.conf` pour chacune de nos interfaces.
- Dans `logs/` nous créerons des fichiers de logs que nous pourrons désactiver ou améliorer si vous le souhaitez plus tard.
- Nous n'utiliserons pas les deux derniers dossiers `usr` et `var`

## Commandes utile
Ici vous retrouverez des commandes qui vous seront utiles pour ce projet

`tasklist | findstr squid` : Cherche toutes les tâches qui s'appelle squid
`taskkill /F /IM squid.exe` : Ferme toutes les tâches squid.exe
`netstat -ano | findstr "8130"` Cherche toutes les tâches sur le port 8130. 
Signification des arguments utilisés
- Utilisée avec l'argument -a, la commande netstat affiche l'ensemble des connexions et des ports en écoute sur la machine.
- Utilisée avec l'argument -n, la commande netstat affiche les adresses et les numéros de port en format numérique, sans résolution de noms.
- Utilisée avec l'argument -o, la commande netstat détaille le numéro du processus associé à la connexion. 
  
`netsh wlan show interfaces` vous permet d'afficher vos cartes réseaux Wi-Fi (Lan) sans toutes les cartes virtuelle ou inactive (la connexion par RJ45 n'est pas affiché non plus).

`ipconfig` : Affiche toutes les cartes réseau disponibles, pour trouver celle que vous chercher, regarder  `Suffixe DNS propre à la connexion. . . : lan`

Vous pouvez utilisé le fichier `connections.ps1` pour voir toutes les connexions TCP avec détails du programme en utilisant powershell (pour lancer le programme ouvrer powershell depuis windows, déplacer vous avec `cd` pour allez au répertoire où est le fichier, et tapez .\connections.ps1)

Tuer un seul processecus à la fois 
`netstat -ano | find ":13129"`
On aura quelque chose comme :
`TCP    127.0.0.1:13129    0.0.0.0:0    LISTENING    1234`
Ici, 1234 est le PID du processus qui utilise le port 13129.
`taskkill /PID 1234 /F`

## Démarrage du projet
### Récupération des IPs
Commençons par récupérer l'IP de vos cartes réseau, oui, c'est pour ça que vous deviez les connecter au moins une fois, faite `win` ou `win+r` et tapez cmd, cela vous ouvrira l'invite de commande, tapez `ipconfig` et chercher vos cartes parmi toutes celle afficher, indice regarder `Suffixe DNS propre à la connexion. . . : lan` pour trouver plus facilement.
Vous pouvez utiliser la commande `netsh wlan show interfaces` si vous cherchez uniquement des connexions Wi-Fi.

Ensuite vous pouvez utiliser le fichier `connections.ps1` qui se trouve dans `scripts` pour voir toutes les connexions TCP avec détails du programme.
(Pour lancer le programme ouvrer powershell depuis Windows en tapant powershell dans la barre de recherche, déplacer vous avec `cd` pour allez au répertoire où est le fichier {tapez juste la lettre du lecteur avec : pour changer de disque `D:` pour passer du disque C à D}, et tapez .\connections.ps1)

Une fois faits, tous vos ports locaux utilisés par des services seront affichés.

### Vérifications des ports utilisés et utilisables
Nous allons maintenant vérifier les ports réservés par Windows avec la commande `netsh interface ipv4 show excludedportrange protocol=tcp`
Résultat :
```
Protocole tcp Plages d'exclusion de ports
Port de début    Port de fin
-------------    -----------
        80          80
      1487        1487
      5673        5673
      5674        5674
      7058        7058
      7452        7551
      7552        7651
      7652        7751
      7852        7951
      8052        8151
      8152        8251
      8252        8351
      8352        8451
      8452        8551
      8670        8769
      8770        8869
      8870        8969
      9070        9169
      9281        9380
      9381        9480
      9481        9580
      9581        9680
      9681        9780
     10090       10189
     10190       10289
     10290       10389
     10490       10589
     10690       10789
     10790       10889
     10890       10989
     10990       11089
     11090       11189
     11238       11337
     11338       11437
     11495       11594
     11595       11694
     11695       11794
     11795       11894
     11895       11994
     11995       12094
     12095       12194
     12195       12294
     12295       12394
     12395       12494
     12495       12594
     12595       12694
     22000       22000
     42137       42236
     42237       42336
     42337       42436
     42537       42636
     42737       42836
     42837       42936
     42937       43036
     43037       43136
     43137       43236
     43256       43355
     43356       43455
     43456       43555
     43556       43655
     43656       43755
     44260       44359
     44360       44459
     44460       44559
     44560       44659
     44660       44759
     50000       50059     *
* - Exclusions de ports administrés.
```
Tous ces ports ne sont pas forcément utilisés, mais peuvent être utilisés, ils sont réservés par les mises à jour windows, hyper-v pour beaucoup est ne sont pas utilisé.
Si vous avez vraiment beaucoup de ports occupés comme là, on peut commencer par ouvrir le terminal (`cmd`) en administrateur et faire un `net stop winnat`, puis `net start winnat`.
Refaites la commande `netsh interface ipv4 show excludedportrange protocol=tcp`, vous devriez avoir nettement moins d'adresse IP réservée maintenant.
```
Port de début    Port de fin
-------------    -----------
        80          80
      1487        1487
      5673        5673
      5674        5674
     22000       22000
     50000       50059     *

* - Exclusions de ports administrés.
```
![restart NAT](https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/nat_system.jpg)

Vous avez dû le remarquer, mais un `*` apparaît à côté de certains ports, ce signe est utilisé pour signifier que les ports sont réservés de façon permanente.
`50000       50059     *` sont des ports système réservés pour Windows.

Nous utiliserons ce même système pour réserver nos ports sinon Windows risque de prendre ces ports à un moment ou un autre.
Nous utiliserons la plage de ports 1310X pour notre projet, non réservé et pas d'applications dessus.

### Réservations des ports utilisables

Commençons par réserver nos ports, pour moi de 13128 à 13130.

Faite `netsh int ipv4 add excludedportrange protocol=tcp startport=13128 numberofports=3 store=persistent` sous cmd en administrateur.
Ensuite, vérifiez avec `netsh interface ipv4 show excludedportrange protocol=tcp`, vous devriez avoir une ligne `13128       13130     *` qui apparait.
```
C:\WINDOWS\system32>netsh interface ipv4 show excludedportrange protocol=tcp

Protocole tcp Plages d'exclusion de ports

Port de début    Port de fin
-------------    -----------
        80          80
      1487        1487
      5673        5673
      5674        5674
     13128       13130     *
     22000       22000
     50000       50059     *

* - Exclusions de ports administrés.
```

### Création des fichiers de configuration
Nous pouvons maintenant commencer, on va créer le premier fichier de config

Bonus : rendre fixes les adresses IP des cartes réseau

Bonus : Ports conservés pour Squid

fichier `squid_pcie.conf` créer le dans `Squid\etc\squid`
```.conf
# 127.0.0.1 pour signaler qu'on est en local si on avait mis 0.0.0.0, d'autres personnes du réseau local auraient pu se connecter
# Choisissez un port de libre pour remplacer 13129
http_port 127.0.0.1:13129
# L'adresse IP de votre carte réseau que vous voulez utiliser comme proxy
tcp_outgoing_address 192.168.1.xx
pid_filename D:/Documents/Outils/Squid/var/run/squid_pcie.pid

# DNS Google, vous pouvez mettre celui de votre FAI ou un autre si vous voulez
dns_nameservers 8.8.8.8 8.8.4.4
dns_v4_first on

# Désactive complètement le cache
cache deny all
cache_mem 0 MB
memory_pools off

# Privacy, Évite que notre IP locale apparaisse dans les en-têtes HTTP
forwarded_for off
# Logs, vous pouvez les désactiver avec `access_log none` et `cache_log none`
access_log D:/Documents/Outils/Squid/logs/access_pcie.log
cache_log D:/Documents/Outils/Squid/logs/cache_pcie.log

# Access Control Lists, information basique de sécurité,
# `acl CONNECT method CONNECT` pour HTTPS traffic SSL/TLS chiffré
acl localnet src 127.0.0.1 192.168.1.0/24
acl SSL_ports port 443
acl Safe_ports port 80 443
acl CONNECT method CONNECT

# Access rules pour sécuriser la connexion en mode local
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localnet
http_access deny all
```

Supprimer les commentaires explicatifs (commence par #), gardez / mettez ce qui vous ai utile.

Faite de même pour chaque proxy que vous avez besoin de créer, gardez un nom logique pour vos fichiers de config afin de les reconnaître facilement, et si possible essayer de regrouper vos ports choisis, ex: 13128, 13129, 13130.

Dans `logs/`, vous pouvez pré-créer tous vos fichiers de logs, ici `cache_pcie` et `access_pcie` dans notre exemple de fichier de configuration, faite pour chaque configuration, sinon, le programme devrait les créer tout seul.

### Créations des scripts étape par étape

Et là on y vient à la création des scripts, on va le faire étape par étape.
Premier script pour lancer le pcie
```bat
@echo off
D:\Documents\Outils\Squid\bin\squid.exe -f D:\Documents\Outils\Squid\etc\squid\squid_pcie.conf -N
```
Ok, rien de compliqué pour celui-là, remplacez juste `D:\Documents\Outils\Squid` par votre emplacement et `squid_pcie.conf` par le nom de votre fichier
ℹ️ Au passage, si vous avez des erreurs vous pouvez voir dans la section erreur si elle y figure au cas où.

Vous pouvez maintenant ouvrir `cmd` en administrateur afin de pouvoir fermer l'application si besoin (ouvrez cmd et déplacer vous à la racine `Squid`)
vous pouvez maintenant vérifier que le process Squid, c'est bien lancer
avec la commande `tasklist | findstr squid` ou `netstat -ano | findstr "13129"` pour chercher si le programme est bien ouvert sur le port que vous avez mis, remplacer 13129 par votre port
`taskkill /F /IM squid.exe` : Ferme toutes les tâches squid.exe (nécessite des droits administrateur)

Tuer un seul processecus Squid à la fois 
`netstat -ano | find ":13129"`
On aura quelque chose comme :
`TCP    127.0.0.1:13129    0.0.0.0:0    LISTENING    1234`
Ici, 1234 est le PID du processus qui utilise le port 13129.
`taskkill /PID 1234 /F`

on passe sur la deuxième version du code
```bat
# Configuration de la fenêtre
@echo off
title Squid PCIe Proxy (13129)
color 0A

# Affichage de l'en-tête
echo ========================================
echo   Starting Squid PCIe Proxy
echo ========================================
echo.

# Vérifier si le port 13129 est déjà utilisé
netstat -ano | findstr ":13129" >nul 2>&1
if %errorlevel% equ 0 (
    echo [!] Port 13129 already in use!
    echo [!] PCIe proxy may already be running
    pause
    exit /b 1
)

# Supprimer les fichiers temporaires qui pourraient causer des conflits
echo [*] Cleaning temporary files...
del /Q D:\Documents\Outils\Squid\dev\shm\squid-cf__*pcie*.shm >nul 2>&1
del /Q D:\Documents\Outils\Squid\var\run\squid_pcie.pid >nul 2>&1

# Afficher les informations de démarrage
echo [*] Starting PCIe proxy...
echo.
echo [+] Proxy started running on 127.0.0.1:13129
echo [+] Interface: Wi-Fi PCIe (192.168.1.XX)
echo.
echo ========================================
echo   Press Ctrl+C to stop this proxy
echo ========================================
echo.

# Lancer Squid en mode foreground (-N = reste attaché à la fenêtre)
D:\Documents\Outils\Squid\sbin\squid.exe -f D:\Documents\Outils\Squid\etc\squid\squid_pcie.conf -N
```

Plutôt que de passer par l'invite de commande pour voir si cela c'est bien lancé, vous pouvez utiliser le script `status.bat` en remplaçant les ports utilisés par ceux que vous utiliserez, vous aurez plus qu'à double-cliquez sur le .bat, sinon faite comme tout à l'heure (`tasklist | findstr squid` ou `netstat -ano | findstr "13129"`).
 
Vous pouvez kill les programmes comme tout à l'heure ou utilisez `Stop_all.bat`.
Aussi vous pouvez déjà prendre le programme `diag_squid.bat`, si cela vous intéresse, il va vous afficher quelque chose comme
```

[1] Network Interfaces Status:
----------------------------------------
    Adresse IP :                           192.168.1.XX
    Adresse IP :                           192.168.1.XX
    Adresse IP :                           192.168.1.XX

[2] Expected IPs:
----------------------------------------
CPL:  192.168.1.XX (Ethernet)
PCIe: 192.168.1.XX (Wi-Fi 2)
USB:  192.168.1.XX (Wi-Fi 4)

[3] Squid Processes:
----------------------------------------

[4] Listening Ports:
----------------------------------------

[5] WiFi Connection Status:
----------------------------------------
    SSID                   : MAbox-XXXXXXXX-5GHz_EXT
    BSSID                  : XX:00:X0:0X:X0:00
    SSID                   : MAbox-XXXXXXXX-5GHz
    BSSID                  : 0X:XX:X0:0X:0X:X0

```

Si on se penche un peu sur le programme, il nous faut indiquer nos interfaces, moi, j'en ai 3 ici, mais, mettez ce que vous avez, vous devez indiquer le nom de vos interfaces, ici pour moi `Ethernet`, `"Wi-Fi 2"` et `"Wi-Fi 4"`, les adresses IP, ainsi que les ports de sortie que vous avez choisis (section 1, 2, 4).
```
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
```

Ceci fait, reprenons notre code `Start`, vous avez dû le remarquer, mais pour l'instant tout se lance dans un bat et reste ouvert, pas ouf pour automatiser tout ça pour tous les jours d'avoir toutes ces fenêtres tout le temps ouvertes.
vous pouvez utiliser le script `start_squid_pcie_silent.bat` qui contient
```bat
START /MIN CMD.EXE /C start_squid_pcie.bat
```
Il lancera en réduit le script, ce qui n'est pas exactement ce que l'on cherche
D'après ce que j'ai vu, ce n'est pas possible de faire un vrai silencieux en bat pur.
On va donc passer sur du `.vbs` que vous avez déjà du voir dans le dossier scripts.
Voyons la structure du fichier `vbs` `stop_all.vbs`
```vbs
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "taskkill /F /IM squid.exe", 0, False
```
On commence par créer un objet Shell Windows pour exécuter des commandes,
puis on :
`"taskkill /F /IM squid.exe"` Tue tous les processus Squid
`0` = Fenêtre cachée (pas de CMD visible)
`False` = Ne pas attendre la fin de l'exécution

C'est pareil pour le `start_all.vbs`, on démarre juste le .bat avec ces paramètres plutôt que d'exécuter directement la commande.
`WshShell.Run "D:\Documents\Outils\Squid\start_squid_pcie.bat", 0, False`

Vous pouvez tester tout ça avec tous vos programmes actuels.

Si vous voulez tester si votre proxy marche, vous pouvez aller directement à la partie sur Firefox et revenir ici après [<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-external-link-icon lucide-external-link"><path d="M15 3h6v6"/><path d="M10 14 21 3"/><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/></svg>](#connection-sur-firefox-par-proxy).

Bien, reprenons, on va créer les `vbs`, des .bat pour tester, ils ne sont pas nécessaires, ça vous fait juste une manière différente.
```
Set WshShell = CreateObject("WScript.Shell")

' Nettoyer les fichiers temporaires
WshShell.Run "cmd /c del /Q D:\Documents\Outils\Squid\dev\shm\squid-cf__*pcie*.shm", 0, True
WshShell.Run "cmd /c del /Q D:\Documents\Outils\Squid\var\run\squid_pcie.pid", 0, True

' Lancer le proxy PCIe
WshShell.Run "D:\Documents\Outils\Squid\bin\squid.exe -f D:\Documents\Outils\Squid\etc\squid\squid_pcie.conf -N", 0, False

WScript.Sleep 2000

' Notification
WshShell.Popup "PCIe Proxy Started" & vbCrLf & vbCrLf & "Listening on: 127.0.0.1:13129" & vbCrLf & "Interface: 192.168.1.XX", 3, "Squid PCIe", 64
```
Comme vous le voir, c'est plutôt simple avec ce qu'on a vu précédemment, vous devez changer le chemin, nom du fichier .conf, port, IP, et PCIe en fonction de ce que vous voulez mettre, le script vous envoie une petite notification windows quand le programme à finit de se lancer tout seul, cette notification disparait toute seule.
- 3 = Durée d'affichage en secondes (la popup se ferme automatiquement après 3 secondes)
- 64 = Type d'icône (64 = icône d'information ℹ️)
   `vbCrLf` = Saut de ligne
- `& vbCrLf &` = Concaténation avec saut de ligne
Pour info la durée d'affichage 0 correspond à rester affiché jusqu'à ce que l'utilisateur clique

Les autres types de paramètres d'icônes 

| Valeur | Icône | Description |
|--------|-------|-------------|
| `0` |  | Aucune icône |
| `16` | ❌ | Icône d'erreur (croix rouge) |
| `32` | ❓ | Icône de question |
| `48` | ⚠️ | Icône d'avertissement (triangle jaune) |
| `64` | ℹ️ | Icône d'information (i bleu)|

Je passe sur la dernière version du script pour vérifier et forcer la connexion Wi-Fi automatique de Windows quand ce n'est pas sa connexion par défaut
Fichier `start_squid_pcie_with_check.bat`
```
@echo off
title Squid USB Proxy (13130) - With Connection Check
color 0A
setlocal enabledelayedexpansion

REM ================================
REM        CONFIGURATION
REM ================================
set "SQUID_PATH=D:\Documents\Outils\Squid"
set "INTERFACE=Wi-Fi 2"
REM set "SSID=Bbox-520CD38F-5GHz"
set "SSID=Bbox-520CD38F-5GHz_EXT"
set "IP_EXPECTED=192.168.1.70"
set "PORT=8130"
set "CONF_FILE=%SQUID_PATH%\etc\squid\squid_usb.conf"
set "EXECUTABLE=%SQUID_PATH%\bin\squid.exe"
Rem LOG variable not used 
set "LOG=%SQUID_PATH%\logs\cache_usb.log"

echo ========================================
echo      Starting Squid USB Proxy
echo ========================================
echo.

REM ================================
REM Vérifier si le Wi-Fi est connecté au bon SSID
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
    exit /b 1
)

:WIFI_CONNECTED
echo [+] Connected to SSID "%SSID%"


REM ================================
REM Attendre que l'IP soit disponible
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
    exit /b 1
)

echo [+] IP %IP_EXPECTED% is now assigned to "%INTERFACE%"

REM ================================
REM Vérifier si le port est déjà utilisé
REM ================================
netstat -ano | findstr ":%PORT%" >nul 2>&1
if not errorlevel 1 (
    echo [!] Port %PORT% already in use! Aborting.
    pause
    exit /b 1
)

REM ================================
REM Nettoyer les fichiers temporaires
REM ================================
echo [*] Cleaning temporary files...
del /Q "%SQUID_PATH%\dev\shm\squid-cf__*usb*.shm" >nul 2>&1
del /Q "%SQUID_PATH%\var\run\squid_usb.pid" >nul 2>&1

REM ================================
REM Lancer Squid
REM ================================
echo [*] Starting USB proxy...
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
```
C'est le dernier script à voir encore un effort, vous retrouverez en haut des variables pour éviter de tout reconfigurer à chaque fois, bon sauf le cleaning temporary files qui est toujours à changer en bas... avec `echo [*] Starting PCIe proxy...``que vous changer en fonction de votre interface.
Les logs en haut ne sont pas utilisés, si vous voulez rajouter des logs personnalisés, faites comme il vous plaira :).

ce fichier est valable pour les connexions Wi-Fi donc PCIe et USB dans mon cas, la version CPL est par défaut sur mon ordinateur et ne nécessite pas de choisir la connexion, on peut donc rester sur le bon vieux script 
```bat
@echo off
title Squid CPL Proxy (13128)
color 0A

echo ========================================
echo   Starting Squid CPL Proxy
echo ========================================
echo.

REM Verifier si deja lance
netstat -ano | findstr ":13128" >nul 2>&1
if %errorlevel% equ 0 (
    echo [!] Port 13128 already in use!
    echo [!] CPL proxy may already be running
    pause
    exit /b 1
)

echo [*] Cleaning temporary files...
del /Q D:\Documents\Outils\Squid\dev\shm\squid-cf__*cpl*.shm >nul 2>&1
del /Q D:\Documents\Outils\Squid\var\run\squid_cpl.pid >nul 2>&1

echo [*] Starting CPL proxy...
echo.

D:\Documents\Outils\Squid\bin\squid.exe -f D:\Documents\Outils\Squid\etc\squid\squid_cpl.conf -N 2>&1 | findstr /C:"Accepting HTTP" >nul
if %errorlevel% equ 0 (
    echo [+] Proxy started running on 127.0.0.1:13128
    echo [+] Interface: Ethernet CPL (192.168.1.XX)
    echo.
    echo ========================================
    echo   Press Ctrl+C to stop this proxy
    echo ========================================
)

D:\Documents\Outils\Squid\bin\squid.exe -f D:\Documents\Outils\Squid\etc\squid\squid_cpl.conf -N
```
Ça devrait être suffisant (vu que je ne touche pas vraiment à cette connexion, je verrais si des vérifications sont nécessaires)

Bien sûr si vous débranchez une de vos cartes internet, vous devrez changer les scripts (ou juste ne pas lancer le script en question).

Si mon expérience a pu aider quelqu'un, j'en suis ravie :) 
Hônnêtement, je vais probablement prendre plus de temps à écrire le markdown et reddit que le projet en lui-même.

## Connection sur Firefox par proxy
- Lancer firefox
- Cliquez sur `☰` en haut à droite
- Puis `Paramètres`
- Rester dans l'onglet `Général` et descendez tout en bas, jusqu'à `Paramètres réseau`
- Cliquez sur `Paramètres` à cîté de "Configurer la façon dont Firefox se connecte à Internet".
- Choisissez `Configuration manuelle du proxy`
- Entrez dans Proxy HTTP : `127.0.0.1`, puis le port que vous avez mis dans votre script pour votre proxy 
- Cochez `Utiliser également ce proxy pour HTTPS` puis valider avec `OK`
- Et voilà tout devrait fonctionner normalement, testez en chargant une page web.
- Vous pouvez vérifier vos connexions entrantes sur un proxy, en lançant  le `status.bat` ou directement `netstat -ano   | findstr "votreport"`
Vous aurez :
```
D:\Documents\Outils\Squid>netstat -ano   | findstr "8129"
  TCP    127.0.0.1:8129         0.0.0.0:0              LISTENING       13524
  TCP    127.0.0.1:8129         127.0.0.1:36656        ESTABLISHED     13524
  TCP    127.0.0.1:36656        127.0.0.1:8129         ESTABLISHED     32440
```
Si vous avez une erreur en chargeant la page web comme `connexion refusée` ou `erreur 503` 
![Erreur Proxy Firefox](https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/firefox_network_error.jpg).
C'est que vous avez soit mal configuré que ce soit dans Firefox ou les fichiers .conf, soit  un problème de connexion de votre interface réseau.
- Vérifiez que votre carte est bien connectée au réseau.
- Vérifiez que l'interface est bien connectée à l'adresse choisie avec `ipconfig | findstr "192.168.1.XX"`
- Tester votre connectivité avec `ping -S 192.168.1.XX 8.8.8.8`.
  
- Si votre carte n'est pas connectée au réseau, connectez-là et testez, si elle a changer d'IP, vous devez configurer de nouveau vos fichiers, ou forcer une IP statique. 
- Vérifiez que le ping se fait bien au DNS choisie, vérifier votre DNS dans le fichier `.conf` de l'interface si cela ne ping pas. 
- Vérifiez que les informations du proxy sont bien rentrées dans Firefox, 
- Si ces vérifications ne suffisent pas vérifiez avec `ipconfig` les informations de votre carte ou si elle est débranché, sinon je vous renvoie  [suivre le tuto pas à pas <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-external-link-icon lucide-external-link"><path d="M15 3h6v6"/><path d="M10 14 21 3"/><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/></svg>](#démarrage-du-projet)

## Rangez vos exécutables
Actuellement, on a vu pas mal de de scripts différents, mais tous les scripts `.bat` et `.vbs` sont à la racine de `Squid\` pour facilité. Aie 😅, pas très propre, on va faire un peu de trie, créons un dossier `Scripts` à la racine et plaçons tous nos scripts `.vba` et `.bat` dedans.
Vous avez dû le remarquer, mais le dernier script qu'on a vu utilise un chemin absolu. Du coup vous n'aurez besoin de modifier que le script `start_all.vbs` (si vous utilisez les derniers fichiers de mon projets, pas ceux vu en chemin)
```
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "D:\Documents\Outils\Squid\start_squid_usb_with_check.bat", 0, False
WshShell.Run "D:\Documents\Outils\Squid\start_squid_pcie_with_check.bat", 0, False
WshShell.Run "D:\Documents\Outils\Squid\start_squid_cpl.bat", 0, False
```
devient
```
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "D:\Documents\Outils\Squid\Scripts\start_squid_usb_with_check.bat", 0, False
WshShell.Run "D:\Documents\Outils\Squid\Scripts\start_squid_pcie_with_check.bat", 0, False
WshShell.Run "D:\Documents\Outils\Squid\Scripts\start_squid_cpl.bat", 0, False
```
Si vous le souhaitez, vous pouvez créer davantage de sous-dossiers dans scripts pour catégoriser.
Vous pouvez bien sûr garder et corriger les autres scripts vus pour plus de versatilité.

## Structure finale du projet

```
Squid/
├── 📁bin/
│     └── squid.exe
├── 📁dev/
│     └── shm/
├── 📁etc/
│     └── 📁squid/
│           ├── ⚙️squid_cpl.conf
│           ├── ⚙️squid_pcie.conf
│           └── ⚙️squid_usb.conf
├── 📁logs/
│     └── 📄access_cpl.log
│     └── 📄access_pcie.log
│     └── 📄access_usb.log
│     └── 📄cache_cpl.log
│     └── 📄cache_pcie.log
│     └── 📄cache_usb.log
├── 📁Scripts/
│     └── ℹ️diag_squid.bat
│     └── ▶️start_all.vbs
│     └── ▶️start_squid_cpl.bat
│     └── ▶️start_squid_pcie_with_check.bat
│     └── ▶️start_squid_usb_with_check.bat
│     └── ℹ️status.bat
│     └── ⏹️stop_all.vbs
├── 📁usr/
└── 📁var/
```

## Lancement automatique des scripts au démarrage de Windows
Vous pouvez créer un fichier ou un raccourci de votre script de lancement directement dans le fichier de Démarrage à l'emplacement suivant `C:\Users\yourusername\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`

Ici, nous passerons directement par le planificateur de tâches de Windows
- Ouvrez le planificateur de tâches
- Cliquer sur `Créer une tâche` à droite (il est important que ce soit tâche et pas tâche de base).
- Mettez le nom de votre tâche, la description et changer configurer pour Windows 10
- Puis allez dans l'onglet `Déclencheur`, cliquer sur `Nouveau...`,
   - Lancer la tâche `Au démarrage`
   - Reporter la tâche pendant `30 secondes` (ajusté pour que vos cartes réseau puisse démarrer sans soucis)
   - Case `Activée`
   - Le reste peut rester désactivé
- Allez dans l'onglet `Actions`, cliquer sur `Nouveau...`,
   - Pour action, mettez `Démarrer un programme`
   - Dans `Programme/script`, indiquer l'emplacement de votre script .vbs / .bat, pour moi : `D:\Documents\Outils\Squid\start_all.vbs`
   - Commencer dans (facultatif), mettez `D:\Documents\Outils\Squid\`, il lancera votre script depuis ce dossier
-  Allez dans l'onglet suivant `Conditions`, décochez tout.
-  Allez dans l'onglet suivant `Paramètres`,
   -  Cochez, autoriser l'exécution de la tâche à la demande.
   -  Laisser décocher le reste
   -  Garder la liste déroulante sur `Ne pas démarrer dans une nouvelle instance` 
- Vous pouvez quitter en appuyant sur `OK`, regarder dans vos tâches, elle a dû apparaître.
- Quand vous étiez dans la création de votre tâche, vous avez pu voir un onglet `Historique (désactivé)` avec la mention "désactivé", cet historique vous permet de suivre les logs de déclenchement de votre script, si vous voulez le réactiver
  - Cliquez sur `Planificateur de tâches (Local)` au-dessus de `Bibliothèque du Planificateur`
  - Cliquez sur `Action` tout en haut puis `Activer l'historique de toutes les tâches`, sur Windows vous ne pouvez pas activer l'historique que pour une seule tâche, mais pour l'ensemble de vos tâches


## Erreurs

- Comme je l'ai mentionné au début, Windows n'accepte pas deux cartes réseaux sur le même SSID, donc vous ne pouvez pas vous connecter sur deux Wi-Fi `mabox_5Gxv74Rfgt2_5Ghz` avec vos deux interfaces, vous pouvez utiliser la bande 2.4Ghz ou un répéteur, il faut juste qu'il n'ai pas le même SSID, sinon Windows déconnectera silencieusement, il utilisera un système de priorité d'utilisation de la carte réseau.
- Vous voyez le programme Squid se relancer en boucle après l'avoir fermé à plusieurs reprises avec `"taskkill /F /IM squid.exe"`, essayez `sc query | findstr -i squid`, si vous avez un résultat, c'est que vous avez installé le Squidsrv de Windows, je vous renvoie sur ce markdown [Désinstaller Squidsrv <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-external-link-icon lucide-external-link"><path d="M15 3h6v6"/><path d="M10 14 21 3"/><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/></svg>](https://github.com/tempetflamer/squid_windows_multi_network_interface/tree/main/docs/uninstall_squidsrv.fr.md).
- Peut être avez-vous utiliser des ports qui à votre prochain démarrage seront utilisés par d'autres applications / services d'après `connections.ps1`. C'est pour cette raison que l'on à réservé les ports en faisant attention de ne pas prendre un port utilisé par une autre application. Suivez cette étape [Retourner à la Réservations des ports utilisables](#réservations-des-ports-utilisables), si vos ports sont toujours utilisés après alors vous n'aurez pas beaucoup de choix, soit fermé ces services, soit changé de port.
- Si vous essayé d'accéder à speedtest Ookla depuis un de vos proxy Ookla vous donnera une erreur, cela n'arrive pas avec d'autre speedtest que  j'ai testé.
![speedtest ookla error](https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/speedtest_ookla_error.jpg)
- Actuellement si vous n'avez pas désactivé les caches et que votre disque dur est plein, alors le programme crashera parcequ'il ne pourra pas écrire dans les fichiers `.log`, vous retrouverez plusieurs lignes comme `2025/11/04 01:01:41| local=127.0.0.1:13130 remote=127.0.0.1:50560 FD 80 flags=1: read/write failure: (113) Software caused connection abort` dans votre log. pour cela, mettez juste `access_log none` et `cache_log none` dans vos fichiez logs ([Retourner à la Création des fichiers de configuration](#création-des-fichiers-de-configuration))


## FAQ
Ici est un petit fourre-tout de fin contenant quelques informations que certains pourraient trouvé intéressante, j'en ajouterais peut-être s'il y'a des questions et réponses et que je comprends comment utiliser.

- Je n'ai pas pu tester d'utiliser deux fois la même carte (Wi-Fi) mais à priori cela devrait marcher parce que leur adresse MAC sont différente.
- Testé uniquement sur Windows 10, je ne connais pas les particularités sur Windows 11.


En constructions...
Certaines phases doivent encore être écrites comme les readme anglais, readme spécifique (forcebindip), erreurs rencontrées, bonus utiles, etc.

[Retourner à la table des matière](#table-des-matières).
