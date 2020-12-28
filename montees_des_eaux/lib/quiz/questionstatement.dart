import 'package:flutter/material.dart';

class QuestionStatement extends StatefulWidget {

  /// Le texte de la question
  String statement;

  ///Retourne le texte centré
  QuestionStatement({
    Key key, 
    @required this.statement
  }) : super(key: key);

  @override
  _QuestionStatementState createState() => _QuestionStatementState();
}

class _QuestionStatementState extends State<QuestionStatement> {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text(
        widget.statement,
      ),
    );
  }
}