import 'package:flutter/material.dart';
import 'package:montees_des_eaux/quiz/answer.dart';
import 'package:montees_des_eaux/quiz/questionstatement.dart';

class Question extends StatefulWidget {

  /// Le widget de la question
  QuestionStatement statement;
  /// La liste des réponses possibles
  List<Answer> answers;
  /// Le numéro de la question (commence a 1) utilisé pour l'affichage dans l'AppBar
  int index;

  Question({
    Key key, 
    @required this.statement, 
    @required this.answers, 
    @required this.index
  }) : super(key: key);

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {

  /// Crée les lignes des réponses grace a l'attribut [widget.answers]
  List<Row> getAnswers(){
    List<Row> list = new List<Row>();
    for(var i = 0; i < widget.answers.length-1; i+=2){
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          SizedBox(
            width: MediaQuery.of(context).size.width*0.4,
            child: widget.answers[i]
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.4,
            child: widget.answers[i+1]
          ),
        ]
      ));
    }
    return list;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Question ${widget.index}"),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5, //50%
            child: widget.statement,
          ),
          Expanded(
            flex: 5, //50%
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: getAnswers(),
            ),
          ), 
        ],
      ), 
    );
  }
}