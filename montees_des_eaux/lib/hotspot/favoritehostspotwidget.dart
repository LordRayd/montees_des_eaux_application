import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'hotspotitem.dart';
import 'tag.dart';
class FavoriteHotSpotWidget extends StatefulWidget {
  @override
  _FavoriteHotSpotWidgetState createState() => _FavoriteHotSpotWidgetState();
}

class _FavoriteHotSpotWidgetState extends State<FavoriteHotSpotWidget> {

  /// Adresse url du serveur distant
  String server_URL = 'https://montess-des-eaux-server.herokuapp.com/';
  /// Route sur le serveur menant aux rewards
  String route_URL = 'hotspot';
  /// La liste de tous les resultats de hotspots
  List globresult = new List();

  /// Charge tous les lieux favories
  loadFavortesHotspots() async{
    final hotspots = await Hive.openBox('hotspots');
    for(int i=0; i< hotspots.length; i++){
      await getHostSpotInfo(hotspots.get(i)).then( (result) => {
        if(result != null){
          globresult.add(result)
        }
      });
    }
  }

  /// Retourne les infos d'un hotspot particulier
  getHostSpotInfo(id) async {
    try {
      final client = http.Client();
      final response = await client.get(server_URL + route_URL +'/$id');
      // Important d'utilisé les bytes pour ne pas avoir de problème avec utf8
      final decodeData = utf8.decode(response.bodyBytes);
      return jsonDecode(decodeData);
    } catch (e) {
      // handle any exceptions here
    }
    return null;
  }

  /// Widget a renvoyer si pas de lieu favoris
  _noFavoriteText() {
    return Center(
      child: Text(
        "Vous n'avez définis aucun lieu comme favori"
      )
    );
  }

  /// Crée une liste de tag pour le hotspot a l [index] dans [globresult]
  List<Tag> createTag(index){
    List<Tag> tags = new List<Tag>();
    for(int i=0; i<globresult[index]['tags'].length; i++){
      tags.add(new Tag(
        name: globresult[index]['tags'][i]['name'], 
        iconUrl: globresult[index]['tags'][i]['icon']
      ));
    }
    return tags;
  }

  /// Crée une liste de media pour le hotspot a l [index] dans [globresult]
  List<String> createMedia(index){
    List<String> medias = new List<String>();
    for(int i=0; i<globresult[index]['media'].length; i++){
      medias.add(globresult[index]['media'][i]['url']);
    }
    return medias;
  }

  /// Crée la widget listview des hotspots favories
  /// Utilise des HotSpotItem
  _listViewHostSpots() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: globresult.length,
      itemBuilder: (BuildContext context, int index) {
        return HotSpotItem(
          id: globresult[index]['_id'],
          name : globresult[index]['name'],
          location : globresult[index]['location'],
          latitude: globresult[index]['coords']['coordinates'][1],
          longitude : globresult[index]['coords']['coordinates'][0],
          altitude: globresult[index]['altitude'],
          info: globresult[index]['info'],
          tags : createTag(index),
          media : createMedia(index)
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  /// Le corps de l'affichage des lieux favories
  /// Retourne une valeur après le retour de la methode [loadFavortesHotspots]
  _body() {
    return FutureBuilder<dynamic>(
      future: loadFavortesHotspots(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  // AsyncSnapshot<Your object type>
        if( snapshot.connectionState == ConnectionState.waiting){
            return  Center(child: Text('Chargement des lieux préférés'));
        } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else {
              if(globresult.isEmpty)
                return _noFavoriteText();
              else 
                return _listViewHostSpots();
            }
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes lieux favoris"),
      ),
      body: _body(),
    );
  }
}