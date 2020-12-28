import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:montees_des_eaux/quiz/question.dart';

class QuizEnd extends StatefulWidget {

  /// La liste des réponse donné
  List<int> result;
  /// La liste des questions posés
  List<Question> questions;

  QuizEnd({
    Key key, 
    @required this.result, 
    @required this.questions
  }) : super(key: key);

  @override
  _QuizEndState createState() => _QuizEndState();
}

class _QuizEndState extends State<QuizEnd> {

  /// Le pourcentage de bonne réponse
  double pourcent = 0.0;

  @override
  void initState() {
    // calcul le pourcentage de bonne réponse
    for(int i=0; i<widget.result.length; i++){
      if(widget.questions[i].answers[widget.result[i]].isGood==1) pourcent++;
    }
    pourcent = (pourcent / widget.result.length)*100;
    super.initState();
  }

  /// Icone en cas de mauvaise réponse
  Container badAnswer = Container(
    color: Colors.red,
    child: Icon(
      Icons.clear, 
      color: Colors.white,
    ),
  );

  /// Icon en cas de bonne réponse
  Container goodAnswer = Container(
    color: Colors.green,
    child: Icon(
      Icons.done, 
      color: Colors.white,
    ),
  );

  /// Construit la partiie haute de l'écran
  _buildUpperPanel(){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Réponses :",
            textScaleFactor: 1.5,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "Vous avez obtenus $pourcent % de bonnes réponses",
          ),
        ],
      ),
    );
  }

  /// Construit une ligne correspondant à une réponse
  _buildAnswer(index){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width:  MediaQuery.of(context).size.width*0.4,
          child: Text(
            widget.questions[index].statement.statement,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ) ,
        ),
        SizedBox(
          width:  MediaQuery.of(context).size.width*0.4,
          child: Text(
            widget.questions[index].answers[widget.result[index]].answer,
          ),
        ),
        (widget.questions[index].answers[widget.result[index]].isGood==1) 
          ? goodAnswer
          : badAnswer 
      ],
    );
  }
  
  /// Construit la ListView des réponses lignes par lignes
  _buildAnswers(){
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: widget.result.length,
      itemBuilder: (BuildContext context, int index) => _buildAnswer(index),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  /// Construit le bouton de fin qui permet de revenir au MiscellaneousWidget
  _buildEndButton(){
    return Center(
      child:TextButton(
        onPressed: (){
          Navigator.of(context).pop();
        }, 
        child: Text("Terminer",
          textScaleFactor: 1.5,
        ),
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  /// Construit le corps de l'écran
  _body(){
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: _buildUpperPanel(),
        ),
        Expanded( 
          flex: 6,
          child:_buildAnswers(),
        ),
        Expanded(
          flex: 2,
          child: _buildEndButton(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Résultats"),
      ),
      body: _body(),
    );
  }
}