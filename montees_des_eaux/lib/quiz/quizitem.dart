import 'package:flutter/material.dart';
import 'package:montees_des_eaux/quiz/quiz.dart';

class QuizItem extends StatefulWidget {
  String name;
  QuizItem({Key key, @required this.name}) : super(key: key);
  @override
  _QuizItemState createState() => _QuizItemState();
}

class _QuizItemState extends State<QuizItem> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuizWidget(name: widget.name,)),
          );
        }, 
        child: Text(widget.name),
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Colors.blue,
        ),
      ) 
    );
  }
}