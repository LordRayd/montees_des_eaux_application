import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import 'dart:convert';
import 'previewReward.dart';
class RewardsWidget extends StatefulWidget {
  @override
  _RewardsWidgetState createState() => _RewardsWidgetState();
}

class _RewardsWidgetState extends State<RewardsWidget> {

  // A supprimer remplace la reponse du serveur pour l'instant
  var resultHttpRequestTest = [
    {
      "id":"identifiant0", 
      "previewText": "Text Preview Test  0", 
      "description":"Une description plus complete de l'element 0", 
      "media" : "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Colombus_Isle.JPG/1280px-Colombus_Isle.JPG", 
      "level" : 0
    },{
      "id":"identifiant1", 
      "previewText": "Text Preview Test 1", 
      "description":"Une description plus complete de l'element 1", 
      "media" : "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Colombus_Isle.JPG/1280px-Colombus_Isle.JPG", 
      "level" : 1
    },{
      "id":"identifiant2", 
      "previewText": "Text Preview Test 2", 
      "description":"Une description plus complete de l'element 2", 
      "media" : "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Colombus_Isle.JPG/1280px-Colombus_Isle.JPG", 
      "level" : 2
    },{
      "id":"identifiant3", 
      "previewText": "Text Preview Test 3", 
      "description":"Une description plus complete de l'element 3", 
      "media" : "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Colombus_Isle.JPG/1280px-Colombus_Isle.JPG", 
      "level" : 3
    },{
      "id":"identifiant4", 
      "previewText": "Text Preview Test 4", 
      "description":"Une description plus complete de l'element 4", 
      "media" : "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Colombus_Isle.JPG/1280px-Colombus_Isle.JPG", 
      "level" : 4
    },{
      "id":"identifiant5", 
      "previewText": "Text Preview Test 5", 
      "description":"Une description plus complete de l'element 5 pas obtenu", 
      "media" : "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Colombus_Isle.JPG/1280px-Colombus_Isle.JPG", 
      "level" : 2
    }
  ];

  /// Adresse url du serveur distant
  String server_URL = 'https://localhost/';
  /// Route sur le serveur menant aux rewards
  String route_URL = 'rewards';
  /// Liste des rewards existant
  List<PreviewReward> listRewards;

  /// Execute en plus le chargement des récompenses
  @override
  void initState() {
    super.initState();
    loadRewards();
  }

  /// Update la liste des rewards en fonction des resultats renvoyer par le serveur
  /// Met le niveau de la recompense a 5 si la recompense n'est pas deja obtenu
  void updateListRewards(resultServer, resultLocal){
    setState(() {
      listRewards = List.generate(
        resultServer.length, // taille de la liste
        (i) => PreviewReward(
          id : resultServer[i]['id'],
          description: resultServer[i]['description'],
          previewText : resultServer[i]['previewText'],
          url : resultServer[i]['media'],
          level : (resultLocal.contains(resultServer[i]['id']) ? resultServer[i]['level'] : 5),
        )
      );
    });
  }

  /// Recupere les rewards depuis le serveur et met a jour la variable listRewards
  loadRewards() async {
    //getRewardsFromServer().then((result) {
      //if (null == result || result.toString().isEmpty) {
        // Notify user of error.
      //  return;
      //}
      getRewardsFromLocal().then((listId) { // TODO changer null par result
        updateListRewards(resultHttpRequestTest,listId); // TODO changer resultHttpRequestTest par result
      });
    //});
  }

  /// Recupere les identifiants des rewards qui sont posédés par l'utilisateur
  getRewardsFromLocal() async{
    final rewards = await Hive.openBox('rewards');
    List<String> list = new List<String>();
    for(int i=0; i< rewards.length; i++){
      list.add(rewards.get(i));
    }
    return list;
  }

  /// Recupere les rewards depuis le serveur donné
  getRewardsFromServer() async {
    try {
      final client = http.Client();
      final response = await client.get(server_URL+route_URL);
      // Important d'utilisé les bytes pour ne pas avoir de problème avec utf8
      final decodeData = utf8.decode(response.bodyBytes);
      return decodeData;
    } catch (e) {
      // handle any exceptions here
    }
    return null;
  }

  /// Construit la grille des rewards depuis la listRewards
  Widget _buildGrid() => GridView.extent(
    maxCrossAxisExtent: 150,
    padding: const EdgeInsets.all(4),
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    children: listRewards
  );

  /// Verifie si la listRewards est null ou vide
  _isListRewardsEmpty(){
    return listRewards == null || listRewards.length == 0; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Récompenses"),
      ),
      body : _isListRewardsEmpty()
        ? Center(
            child: CircularProgressIndicator(
              valueColor:AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          )
        : _buildGrid(),
    );
  }
}