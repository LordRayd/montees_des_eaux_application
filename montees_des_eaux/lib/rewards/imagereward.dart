import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageReward extends StatefulWidget {
  
  /// L'url de l'image à afficher
  String urlImage;
  /// Le niveau de la récompense a afficher
  int levelReward;
  /// La taille de l'icone du trophée
  double sizeIcon;

  /// Permet la création de l'image des recompenses à partir 
  /// d'une url (image), d'un niveau et d'une taille d'icon de trophée
  ImageReward({
    Key key, 
    @required this.urlImage, 
    @required this.levelReward, 
    @required this.sizeIcon
  }) : super(key: key);

  @override
  _ImageRewardState createState() => _ImageRewardState();
}

class _ImageRewardState extends State<ImageReward> {

  /// La couleur du trophée
  Color rewardColor;

  @override
  void initState() {
    super.initState();
    rewardColor = _chooseColorFromLevel(widget.levelReward);
  }

  /// Choisis la couleur du trophéé par rapport a son niveau
  /// 0 : Bronze
  /// 1 : Argent
  /// 2 : Or
  /// 3 : Eau
  /// 4 : Platine
  Color _chooseColorFromLevel(level){
    switch(level) {
      case 0: return Colors.brown;
      break;

      case 1: return Colors.blueGrey; 
      break; 

      case 2: return Colors.amber;
      break;

      case 3: return Colors.blue;
      break;

      case 4: return Colors.deepPurple;
      break;

      default: return Colors.black;
      break; 
    } 
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(widget.urlImage), // Image recupéré par l'url
      radius: 90,
      child: new Container(
        alignment: Alignment.bottomCenter,
        child: Icon( // Trophée
          Icons.emoji_events, 
          color: rewardColor,
          size: widget.sizeIcon,
        )
      )
    );
  }
}