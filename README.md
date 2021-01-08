# Montées des Eaux
## Développeur
Samuel LE BERRE
## Modification a apporter
### Clé Api GOOGLE
Il faut genérer une clé API google de la forme
* AIzaSyDnNaRdTt-iQQjw-JscspGQxzt_o_E3AZ4

et la copier dans android/app/src/main/AndroidManifest.xml
ainsi que dans /ios/Runner/AppDelegate.swift
### Adresse serveur
Il faut modifier la variable **server_URL** par la nouvelle adresse du serveur en faisant attention de bien mettre un "/" après et ce dans les fichiers suivants de lib :
* favoritehostspotwidget.dart
* quiz.dart
* quizend.dart
* quizselection.dart
* rewardswidget.dart
* homewidget.dart

### Verifier que l'adresse du feed rss est correct
Il vaut mieux vérifier que l'adresse url contenu dans la variable **FEED_URL** de labonewswidget.dart est bien **https://www.laboratoire-geosciences-ocean-ubs.fr/feed/**

## Installation
### Creation APK
* ANDROID : flutter build apk
* IOS (nécéssite MACOS) : flutter build ios

### Installation APK
* Accepter l'installation d'application depuis les sources inconnus
* Lancer l'apk sur le téléphone
## Fonctionnement
### Main
Le fichier main va lancer l'application et créer le menu du bas ainsi que le changement des pages principales :
* LaboNewsWidget
* HomeWidget
* MiscellaneousWidget

### LaboNewsWidget
Liste d'éléments recupérés depuis un flux RSS qui lorsqu'on clique dessus redirige
### HomeWidget 
Carte affichant les lieux d'interêts chargés à chaque déplacement de la carte
### MiscellaneousWidget
Permet les actions tels que :
* Le commencement du quiz
* L'affichage des récompenses
* L'affichage des lieux favoris
* L'Affichage des photos favorites
