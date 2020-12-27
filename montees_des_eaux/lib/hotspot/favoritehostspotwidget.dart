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
  String server_URL = 'https://localhost/';
  /// Route sur le serveur menant aux rewards
  String route_URL = 'hotspot';
  /// 
  List globresult = new List();

  loadFavortesHotspots() async{
    final hotspots = await Hive.openBox('hotspots');
    //await hotspots.clear();
    //hotspots.add(1);
    //hotspots.add(2);
    for(int i=0; i< hotspots.length; i++){
      await getHostSpotInfo(hotspots.get(i)).then( (result) => {
        globresult.add(result)
      });
    }
  }

  getHostSpotInfo(id) async {
    return {
      "hostspotID": id, 
      "name": "Nom de l'HotSpot $id",
      "location" : "Vannes",
      "coord":{
        "lat" : 37.222,
        "long" : 37.222,
        "alt" : 1
      },
      "info" : "Les informations concernant ce spot très précis $id",
      "media" : [{
        'url' : "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Colombus_Isle.JPG/1280px-Colombus_Isle.JPG"
      },{
        'url' : "https://www.dreamyachtcharter.com/wp-content/uploads/2019/02/anse-aux-prunes-e1550620631305.jpg"
      }], 
      "tags" : [
        {
          "name" : "Rique eau",
          "icon" : "https://cdn.icon-icons.com/icons2/721/PNG/512/rain_weather_water_icon-icons.com_62506.png"
        },{
          "name" : "Risque sable",
          "icon" : "https://cdn.icon-icons.com/icons2/645/PNG/512/cubo_arena_playa_icon-icons.com_59608.png"
        }]
    };
    /*
    try {
      final client = http.Client();
      final response = await client.get(server_URL + route_URL +'/$id');
      // Important d'utilisé les bytes pour ne pas avoir de problème avec utf8
      final decodeData = utf8.decode(response.bodyBytes);
      return decodeData;
    } catch (e) {
      // handle any exceptions here
    }
    return null;*/
  }

  _noFavoriteText() {
    return Center(
      child: Text(
        "Vous n'avez définis aucun lieu comme favori"
      )
    );
  }

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

  List<String> createMedia(index){
    List<String> medias = new List<String>();
    for(int i=0; i<globresult[index]['media'].length; i++){
      medias.add(globresult[index]['media'][i]['url']);
    }
    return medias;
  }

  _listViewHostSpots() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: globresult.length,
      itemBuilder: (BuildContext context, int index) {
        return HotSpotItem(
          id: globresult[index]['hostspotID'],
          name : globresult[index]['name'],
          location : globresult[index]['location'],
          coord : globresult[index]['coord'],
          info: globresult[index]['info'],
          tags : createTag(index),
          media : createMedia(index)
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

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