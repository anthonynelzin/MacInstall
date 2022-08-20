#!/bin/bash

##########################################################################################
##########################################################################################
##                                                                                      ##
## Script d'installation de mes machines                                                ##
## v20220820                                                                            ##
##                                                                                      ##
## Anthony Nelzin-Santos                                                                ##
## https://anthony.nelzin.fr                                                            ##
##                                                                                      ##
## Licence CeCILL                                                                       ##
## http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt                           ##
##                                                                                      ##
##########################################################################################
##########################################################################################

echo "La configuration de cette machine va commencer."

##################################
## Ouverture d’une session sudo ##
##################################
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############
## Démarrage ##
###############

## Désactiver le son de démarrage
nvram SystemAudioVolume="%00"

## Activer le « powerchime » façon iOS
defaults write com.apple.PowerChime ChimeOnAllHardware -bool true && open /System/Library/CoreServices/PowerChime.app

## Paramétrer le nom de la machine
read -p "Quel est le nom de cette machine ?" COMPUTERNAME
scutil --set ComputerName ${COMPUTERNAME:-Pippin}
scutil --set HostName ${COMPUTERNAME:-Pippin}
scutil --set LocalHostName ${COMPUTERNAME:-Pippin}
echo "Cette machine s’appellera ${COMPUTERNAME:-Pippin}."

##############
## Sécurité ##
##############

## Exiger le mot de passe immédiatement après la suspension d’activité
defaults write com.apple.screensaver askForPassword -int 1 && defaults write com.apple.screensaver askForPasswordDelay -int 0

## Configurer le pare-feu
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on &&/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on && /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on && /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off && /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off && pkill -HUP socketfilterfw

## Désactiver la connexion aux portails captifs
defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false

############
## Souris ##
############

## Toucher pour cliquer
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 && defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true && defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

##########
## Dock ##
##########

## Masquer/afficher le Dock automatiquement
defaults write com.apple.dock autohide -boolean yes

## Réduire les fenêtres dans l’icône de l’application
defaults write com.apple.dock minimize-to-application -bool true

## Relancer le Dock
killall Dock

#####################
## Mission Control ##
#####################

## Ne pas réarranger automatiquement les Spaces en fonction de votre utilisation la plus récente
defaults write com.apple.dock mru-spaces -bool false

## Grouper les fenêtres par application
defaults write com.apple.dock expose-group-by-app -bool true

## Coin actif > en bas à gauche : Mission Control
defaults write com.apple.dock wvous-bl-corner -int 2 && defaults write com.apple.dock wvous-bl-modifier -int 0

## Coin actif > en haut à droite : mettre le moniteur en veille
defaults write com.apple.dock wvous-tr-corner -int 10 && defaults write com.apple.dock wvous-tr-modifier -int 0

############
## Finder ##
############

## Afficher les barres de défilement : toujours
defaults write -g AppleShowScrollBars -string "Always"

## Désactiver l’affichage du Bureau
defaults write com.apple.finder CreateDesktop -bool false

## Les nouvelles fenêtres de Finder affichent : Bureau
defaults write com.apple.finder NewWindowTarget -string "PfDe" && defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/Desktop/"

## Présentation > Par liste
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

## Présentation > Afficher la barre du chemin d’accès
defaults write com.apple.finder ShowPathbar -bool true

## Présentation > Afficher la barre d’état
defaults write com.apple.finder ShowStatusBar -bool true

## Afficher toutes les extension des fichiers
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

## Ne pas avertir avant de modifier une extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

## Afficher le panneau de sauvegarde étendu par défaut
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true && defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

## Couper le dialogue Time Machine à l’insertion d’un nouveau disque
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

## Relancer le Finder
killall Finder

############
## Safari ##
############

## Au démarrage, Safari ouvre : toutes les fenêtres de la dernier session
defaults write com.apple.safari AlwaysRestoreSessionAtLaunch -bool true

## Page d’accueil : vide
defaults write com.apple.safari HomePage ""

## Ne pas ouvrir automatiquement les fichiers dits « fiables »
defaults write com.apple.safari AutoOpenSafeDownloads -boolean NO

## Ne pas remplir automatiquement les formulaires web
defaults write com.apple.safari AutoFillFromAddressBook -bool false && defaults write com.apple.safari AutoFillPasswords -bool false && defaults write com.apple.safari AutoFillCreditCardData -bool false && defaults write com.apple.safari AutoFillMiscellaneousForms -bool false

## Avertir lors de l’accès à un site web frauduleux
defaults write com.apple.safari WarnAboutFraudulentWebsites -bool true

## Bloquer les fenêtres surgissantes
defaults write com.apple.safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false && defaults write com.apple.safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

## Ne pas autoriser les modules
defaults write com.apple.safari WebKitPluginsEnabled -bool false && defaults write com.apple.safari com.apple.safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

## Cookies et données de sites web : n'autoriser que pour ce site web
defaults write com.apple.safari BlockStoragePolicy -int 3 && defaults write com.apple.safari WebKitStorageBlockingPolicy -int 1 && defaults write com.apple.Safari com.apple.safari.ContentPageGroupIdentifier.WebKit2StorageBlockingPolicy -int 1

## Utilisation du service de géolocalisation par le site web : refuser sans confirmation
defaults write com.apple.safari SafariGeolocationPermissionPolicy -int 0

## Demander aux sites web de ne pas me suivre
defaults write com.apple.safari SendDoNotTrackHTTPHeader -int 1

## Afficher l’adresse complète du site web
defaults write com.apple.safari ShowFullURLInSmartSearchField -int 1

## La touche Tab permet de mettre en surbrillance les objets des pages web
defaults write com.apple.safari WebKitTabToLinksPreferenceKey -bool true

## Ne jamais utiliser de tailles de caractères inférieures à 10
defaults write com.apple.safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2MinimumFontSize -int 10

## Afficher le menu Développement dans la barre des menus
defaults write com.apple.safari IncludeDevelopMenu -int 1

## Présentation > Afficher la barre d’état
defaults write com.apple.safari ShowOverlayStatusBar -int 1

##############
## Terminal ##
##############

defaults write com.apple.Terminal "Default Window Settings" -string "Homebrew" && defaults write com.apple.Terminal "Startup Window Settings" -string "Homebrew"

##############
## Homebrew ##
##############

echo "La configuration de cette machine est terminée. L’installation des applications et des utilitaires va commencer."

## Installer outils en ligne de commande
xcode-select --install

## Installer Rosetta
softwareupdate --install-rosetta

## Installer Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/anthonynelzin/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

## Installer applications avec Cask
brew cask install 1password appcleaner audacity bbedit firefox forecast kdrive pocket-casts tower

## Installer applications avec MAS
brew install mas
read -p "Quel est votre identifiant Apple ?" ID
mas signin --dialog $ID

mas install 1569813296 # 1P for Safari
mas install 1091189122 # Bear
mas install 1423210932 # Flow
mas install 1479461686 # Foodnoms
mas install 775737590 # iA Writer
mas install 409183694 # Keynote
# mas install 634148309 # Logic Pro
mas install 409203825 # Numbers
mas install 409201541 # Pages
mas install 1529448980 # Reeder
mas install 904280696 # Things

## Ne reste plus que le connecteur Antidote (soupir)
open "https://antidote.app"

## Installer utilitaires
brew install ffmpeg hugo imagemagick multimarkdown pandoc python3 wget youtube-dl
pip3 install biplist pillow sklearn

## Vider le Dock
defaults write com.apple.dock persistent-apps -array

## Ajouter apps au Dock
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/1Password.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/BBEdit.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Bear.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iA\ Writer.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Mail.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Messages.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Pocket\ Casts.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Reeder.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Safari.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Things.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

## Relancer le Dock
killall Dock

## Lancement des applications pour se connecter aux services et entrer les licences
open -a 1Password
open -a BBEdit
open -a kDrive
open -a Pocket\ Casts
open -a Reeder
open -a Things

echo "L’installation des applications et des utilitaires est terminée. Au travail !"
