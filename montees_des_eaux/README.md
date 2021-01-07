# Montées des Eaux
## Développeur
Samuel LE BERRE
## Modification a apporter
### Clé Api GOOGLE
Il faut genérer une clé API google de la forme
* AIzaSyDnNaRdTt-iQQjw-JscspGQxzt_o_E3AZ4
et la copié dans android/app/src/main/AndroidManifest.xml
ainsi que dans /ios/Runner/AppDelegate.swift
### Adresse serveur
Il faut modifier la variable **server_URL** par la nouvelle adresse du serveur en faisant attention de bien mettre un "/"après  
Et ce dans les fichiers suivants de lib :
* favoritehostspotwidget.dart
* quiz.dart
* quizend.dart
* quizselection.dart
* rewardswidget.dart
* homewidget.dart

### Verifier que l'adresse du feed rss est correct
Il vaut mieux vérifier que l'adresse url contenu dans la variable **FEED_URL** de labonewswidget.dart est bien **https://www.laboratoire-geosciences-ocean-ubs.fr/feed/**