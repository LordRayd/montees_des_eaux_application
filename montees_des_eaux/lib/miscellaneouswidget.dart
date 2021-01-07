/// Samuel LE BERRE - JANVIER 2021
import 'package:flutter/material.dart';
import 'rewards/rewardswidget.dart';
import 'pictures/gallerywidget.dart';
import 'hotspot/favoritehostspotwidget.dart';
import 'quiz/quizselection.dart';

class MiscellaneousWidget extends StatefulWidget {
  @override
  _MiscellaneousWidgetState createState() => _MiscellaneousWidgetState();
}

class _MiscellaneousWidgetState extends State<MiscellaneousWidget> {


  /// La taille entre les elements de la liste haute
  double spaceBetweenMenuItem = 20;

  /// Taille de la police d'écriture
  double fontSize = 20;

  /// Ouvre le widget des recompenses
  void _openRewards(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RewardsWidget()),
    );
  }

  /// Ouvre le widget des photos favorites
  void _openFavoritesPicture(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GalleryWidget()),
    );
  }

  /// Ouvre le widget des hotpspot préféré
  void _openFavoritesHotSpot(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoriteHotSpotWidget()),
    );
  }

  /// Ouvre la selection d'un quiz
  void _openQuizSelection(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Choix Quiz'),),
          content: QuizSelection(),
        );
      },
    );
  }

  /// Sert a la creation des elements de la liste haute de la page
  menuItem(icon, title, _open){
    return InkWell(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2, // 20%
              child: Icon(
                icon,
                size: 40,
              ),
            ),
            Expanded(
              flex: 6, // 60%
              child: Text(
                title,
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Expanded(
              flex: 2, // 20%
              child: Icon(Icons.keyboard_arrow_right),
            )
          ],
        ),
        onTap: _open,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mon Coin"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5, // 50%
            child: Column(
              children: [
                SizedBox(height: spaceBetweenMenuItem), // Crée un espace
                menuItem(Icons.emoji_events, "Récompenses", _openRewards),
                SizedBox(height: spaceBetweenMenuItem), // Crée un espace
                menuItem(Icons.collections, "Photos Enregistrés", _openFavoritesPicture),
                SizedBox(height: spaceBetweenMenuItem), // Crée un espace
                menuItem(Icons.place, "Lieux Favoris", _openFavoritesHotSpot),
              ],
            )
          ),
          Expanded(
            flex:5, // 50%
            child: FractionallySizedBox(
              alignment: Alignment.center,
              widthFactor: 0.5, // 50%
              heightFactor: 0.2, // 20%
              child: TextButton(
                child: Text(
                  "QUIZ",
                  style: TextStyle(fontSize: fontSize),
                ),
                onPressed: _openQuizSelection,
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.blue,
                  onSurface: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}