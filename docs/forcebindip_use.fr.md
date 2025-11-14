
## Utilisation de ForceBindIp

### Qu'est-ce que ForceBindIp
ForceBindIP est un utilitaire gratuit pour Windows permettant de forcer une application à utiliser une interface réseau spécifique ou une adresse IP locale.
Il fonctionne en injectant une DLL dans le processus de l'application cible pour rediriger ses appels réseau vers l'interface choisie.

### Installation

1. Téléchargez [ForceBindIP <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-external-link-icon lucide-external-link"><path d="M15 3h6v6"/><path d="M10 14 21 3"/><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/></svg>](https://r1ch.net/projects/forcebindip).
2. Installez-le via l’installateur, ou dézippez les fichiers si vous avez pris la version ZIP.
3. Pour les systèmes 32-bit, les fichiers ForceBindIP.exe et BindIP.dll sont placés dans C:\Windows\System32\.
   Pour les systèmes 64-bit, ils sont placés dans C:\Windows\SysWOW64\.
   Remarque : Sur 64-bit, pour pouvoir exécuter ForceBindIP depuis la ligne de commande n'importe où, copiez manuellement ces deux fichiers dans C:\Windows\System32\.
4. Assurez-vous d'avoir les Visual Studio 2015 Runtimes (x86 et x64) installés, nécessaires au fonctionnement.

### Ajout des variables d'environnements
- Tapez touche `windows`
- Tapez `variables`
- Selectionnez `Modifier les variables d'environnement système`
- Cliquez `variables d'environnement...`
- Chercher `Path` dans les variables utilisateur
- Selectionné puis faite modifié
- Cliquez `Nouveau`
- Ajouter le dossier de ForceBindIp, pour moi `C:\Program Files (x86)\ForceBindIP`
- Appuyez `OK` `OK` `Appliquer` si disponible et `OK`

Si ForceBindIP est déjà présent pas besoin de le remettre.

<p>
  <img src="https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/forcebindip/variables_environnement_0.jpg" alt="search variables environnement in search bar " height="460"/>
  <img src="https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/forcebindip/variables_environnement_1.jpg" alt="variables environnement first step" height="460"/>
  <img src="https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/forcebindip/variables_environnement_2.jpg" alt="variables environnement second step" height="460"/>
  <img src="https://raw.githubusercontent.com/tempetflamer/squid_windows_multi_network_interface/main/imgs/forcebindip/variables_environnement_3.jpg" alt="variables environnement third step" height="460"/>
</p>

### Utilisation
Une fois installé, le `Path` dans les variables d'environnement, ouvrer invite de commande (cmd) en administrateur (`win`, puis tapez `cmd`, `exécuter en tant qu'administrateur`).
Commande de base :
`ForceBindIP <Adresse_IP_locale_à_lier> "<Chemin_vers_l_executable>"`

Faite ipconfig dans cmd pour trouver les Ips de vos carte réseau, les cartes réseaux connecté sont ceux dont `lan` apparait derrière `Suffixe DNS propre à la connexion`
Exemples :
`ForceBindIP -i 192.168.1.37 "C:\chemin\app.exe"`

### limitations
Cette méthode est aujourd'hui très limité, la plupart des application récente ne sont plus affecté par cette méthode, c'est le cas des navigateurs.

[Retourner au projet](https://github.com/tempetflamer/squid_windows_multi_network_interface/tree/main/README.fr.md)