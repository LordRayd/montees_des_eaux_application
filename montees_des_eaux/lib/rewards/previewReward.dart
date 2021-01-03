import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'rewardwidget.dart';
import 'imagereward.dart';

class PreviewReward extends StatefulWidget {

  /// L'identifiant de la recompense
  var id;
  /// La descriptin de la recompense
  String description;
  /// Une description plus courte de la recompense
  String previewText;
  /// L'url de l'image de la recompense
  String url ;
  /// Le niveau de la recompense
  int level;
  // Le pourcentatage pour l'obtention
  double percentObtention;
  // L identifiant du quiz
  var quizId;

  PreviewReward({
    Key key, 
    @required this.id, 
    @required this.description, 
    @required this.previewText, 
    @required this.url, 
    @required this.level,
    @required this.percentObtention,
    @required this.quizId,
  }) : super(key: key);

  @override
  _PreviewRewardState createState() => _PreviewRewardState();
}

class _PreviewRewardState extends State<PreviewReward> {

  /// Taille de l'icone du trophée
  double sizeIcon = 50;

  /// Ouvre la recompense en plus grand affichant un RewardWidget
  _openReward(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: RewardWidget(
            id: widget.id,
            description: widget.description,
            previewText: widget.previewText,
            url: widget.url,
            level: widget.level,
            percentObtention: widget.percentObtention,
            quizId: widget.quizId,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Expanded(
            flex: 7, // 70%
            child: ImageReward(
              urlImage: widget.url, 
              levelReward: widget.level, 
              sizeIcon: sizeIcon
            ),
          ),
          Expanded(
            flex: 3, // 30%
            child: Text(widget.previewText)
          )
        ],
      ),
      onTap: _openReward,
    );
  }
}