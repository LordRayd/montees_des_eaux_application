import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:montees_des_eaux/newsitem.dart';

import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:developer';

class LaboNewsWidget extends StatefulWidget {
  @override
  _LaboNewsWidgetState createState() => _LaboNewsWidgetState();
}

class _LaboNewsWidgetState extends State<LaboNewsWidget> {

  /// L'url a laquelle on va chercher lire le flux rss
  //String FEED_URL = 'https://www.laboratoire-geosciences-ocean-ubs.fr/feed/';
  String FEED_URL = 'https://www.lefigaro.fr/rss/figaro_musique.xml';

  /// Le feed du flux Rss
  RssFeed _feed;

  /// Execute en plus le chargement du flux Rss
  @override
  void initState() {
    super.initState();
    load();
  }

  /// Met a jour la valeur de _feed dans l'état
  void updateFeed(result){
    setState(() {
      _feed = result;
    });
  }

  /// Renvoie true si le _feed est null ou ne contient pas d'item
  isFeedEmpty() {
    return null == _feed || null == _feed.items || _feed.items.length == 0;
  }
  
  /// Charge le feed depuis l'url donnée et l'affecte a _feed
  load() async {
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) {
        // Notify user of error.
        return;
      }
      updateFeed(result);
    });
  }

  /// Lis le flux Rss depuis l'url de FEED_URL et retourne un feed
  Future<RssFeed> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(FEED_URL);
      // Important d'utilisé les bytes pour ne pas avoir de problème avec utf8
      final decodeData = utf8.decode(response.bodyBytes);
      return RssFeed.parse(decodeData);
    } catch (e) {
      // handle any exceptions here
    }
    return null;
  }

  /// Retourne une listView de newdItem a partir du _feed lu
  /// Permet egalement de relire le flux Rss en tirant vers le bas la listview
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LGO Info"),
      ),
      body: isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(
              valueColor:AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          )
        : RefreshIndicator(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: _feed.items.length,
              itemBuilder: (BuildContext context, int index) {
                // Crée des élements depuis le _feed
                return NewsItem(
                  title: _feed.items[index].title,
                  description: _feed.items[index].description,
                  url: _feed.items[index].link,
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
            onRefresh: () => load(),
          )
    );
  }
}