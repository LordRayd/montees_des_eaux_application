import 'package:flutter/material.dart';

class QuestionStatement extends StatefulWidget {

  String statement;
  QuestionStatement({Key key, @required this.statement})
  @override
  _QuestionStatementState createState() => _QuestionStatementState();
}

class _QuestionStatementState extends State<QuestionStatement> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.statement),
    );
  }
}