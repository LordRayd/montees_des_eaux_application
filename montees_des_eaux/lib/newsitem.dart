/// Samuel LE BERRE - JANVIER 2021
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class NewsItem extends StatefulWidget {

  /// Le titre de l'item 
  String title;

  /// La description de l'item
  String description;

  /// Le lien menant a l'article presenter par l'item
  String url;
  
  NewsItem({Key key, @required this.title, @required this.description, @required this.url}) : super(key: key);

  @override
  _NewsItemState createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {

  /// La taille maximum du texte du Titre
  var maxLengthTitle = 1000;

  /// La taille maximum du texte de la Description
  var maxLengthDescription = 150;

  /// Ouvre dans le navigateur par défaut l'url de l'item si c'est possible
  _launchURL() async {
    var url = widget.url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Retourne un String du titre coupé pour avoir au maximum la taille de maxLengthTitle
  String limitedTitle(){
    String limited = widget.title;
    if(maxLengthTitle < widget.title.length) {
      limited = widget.description.substring(0, maxLengthTitle);
      limited += ' ...';
    }
    return limited;
  }

  /// Retourne un String de la description coupé pour avoir au maximum la taille de maxLengthDescription
  String limitedDescription(){
    String limited = widget.description;
    if(maxLengthDescription < widget.description.length) {
      limited = widget.description.substring(0, maxLengthDescription);
      limited += ' ...';
    }
    return limited;
  }

  /// Element clickage contenant 2 widget Text montrant le titre et la description
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            textAlign: TextAlign.left,
            textScaleFactor: 1.05,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            limitedDescription(),
            textAlign: TextAlign.left,
          ),
        ]
      ),
      onTap: _launchURL,
    );
  }
}