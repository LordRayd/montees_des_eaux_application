import 'package:flutter/material.dart';

class Answer extends StatefulWidget {

  /// Le texte de la réponse
  String answer;
  /// 1 si la question est correct, 0 sinon
  int isGood;
  /// L'indexe de la position de la réponse dans la question
  int indexInList;

  /// Crée un bouton
  Answer({
    Key key, 
    @required this.answer, 
    @required this.isGood, 
    @required this.indexInList
  }) : super(key: key);

  @override
  _AnswerState createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (){
        // Revient à la page précédente avec pour resultat l'indexInList
        Navigator.pop(context, widget.indexInList);
      }, 
      child: Text(widget.answer),
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.blue,
      ),
    );
  }
}