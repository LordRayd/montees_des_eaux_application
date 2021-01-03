import 'package:flutter/material.dart';
import 'imagereward.dart';
class RewardWidget extends StatefulWidget {

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

  RewardWidget({
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
  _RewardWidgetState createState() => _RewardWidgetState();
}

class _RewardWidgetState extends State<RewardWidget> {

  /// Taille de l'icone du trophée
  double sizeIcon = 100;

  /// Retourne un champs texte representant la descripption du reward
  Widget _buildDescription() => Text(
    widget.description,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children : [
        ImageReward(
          urlImage: widget.url, 
          levelReward: widget.level, 
          sizeIcon: sizeIcon
        ),
        _buildDescription(),
      ]
    );
  }
}