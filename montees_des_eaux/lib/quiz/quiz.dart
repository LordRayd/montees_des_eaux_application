import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:montees_des_eaux/quiz/answer.dart';
import 'package:montees_des_eaux/quiz/question.dart';
import 'package:montees_des_eaux/quiz/questionstatement.dart';
import 'package:montees_des_eaux/quiz/quizend.dart';

class QuizWidget extends StatefulWidget {

  // L identifiant du quiz
  var id;
  /// Le nom du Quiz
  String name;
  
  /// Constructeur de l'objet
  QuizWidget({
    Key key,
    @required this.id,
    @required this.name
  }): super(key: key);

  @override
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {

  /// Le serveur su lequel aller chercher l'information
  String server_URL = 'https://montess-des-eaux-server.herokuapp.com/';
  /// La route spécifique des quiz
  String route_URL = 'quiz';
  /// La valeur que prendra le corps du widget
  /// Initialiser comme une bar de progression
  Widget _bodyState = Scaffold(
    body: Center(
      child:CircularProgressIndicator(
        valueColor:AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    ), 
  );
  /// La liste des questions
  List<Question> questions = new List<Question>();
  /// La liste des réponses données
  List<int> result = new List<int>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Créera tous les éleements necessaires à l'éxécution du quiz après récupération des information
  _loadQuiz() async{
    await getQuiz().then((result) {
      int indexQuestion = 1;
      for(var _questions in result['questions']){

        QuestionStatement st = QuestionStatement(statement: _questions['question']);
        List<Answer> _answers = new List<Answer>();
        int indexAnswer = 0;

        for(var answers in _questions['answers']){
          _answers.add(
            Answer(
              answer: answers['answer'],
              isGood: answers['isGoodAnswer'],
              indexInList: indexAnswer,
            )
          );
          indexAnswer++;
        }

        questions.add(
          Question(
            statement: st,
            answers: _answers,
            index: indexQuestion,
            justification: _questions['justification'],
          )
        );
        indexQuestion++;
      }      
    });
  }

  /// Récupère les informations du quiz ayant pour nom le [widget.name]
  getQuiz() async{
    try {
      final client = http.Client();
      final response = await client.get(server_URL+route_URL +'/'+ widget.id);
      // Important d'utilisé les bytes pour ne pas avoir de problème avec utf8
      final decodeData = utf8.decode(response.bodyBytes);
      return jsonDecode(decodeData);
    } catch (e) {
      // handle any exceptions here
    }
    return null;
  }

  /// Lance chacune des question après leurs créations
  /// Récupère les résultats et les mets dans la liste [result]
  /// lance ennfin le QuizEnd
  _load() async {

    await _loadQuiz();

    int exit =0;

    for(Widget question in questions){
      final _result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => question),
      );
      if(_result is int){
        result.add(_result);
      }else{
        exit = 1;
        break;
      } 
    }

    if(exit == 1) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _bodyState = QuizEnd(quizId: widget.id, result: result, questions: questions,);
      });
    }    
  }

  @override
  Widget build(BuildContext context) {
    return _bodyState;
  }
}