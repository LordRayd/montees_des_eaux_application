/// Samuel LE BERRE - JANVIER 2021
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:montees_des_eaux/quiz/quizitem.dart';

class QuizSelection extends StatefulWidget {
  @override
  _QuizSelectionState createState() => _QuizSelectionState();
}

class _QuizSelectionState extends State<QuizSelection> {

  /// Adresse url du serveur distant
  String server_URL = 'https://montess-des-eaux-server.herokuapp.com/';
  /// Route sur le serveur menant aux rewards
  String route_URL = 'quizzes/names';
  /// la liste des quiz possible
  List quiz = new List();

  /// Charge les differents quiz possible
  _loadQuizzes() async{
    await _getQuizzes().then((result){
      for(var val in result){
        quiz.add(val);
      }
    });
  }
  
  /// Recupere les noms des quiz possible
  _getQuizzes() async{
    try {
      final client = http.Client();
      final response = await client.get(server_URL + route_URL);
      // Important d'utilisé les bytes pour ne pas avoir de problème avec utf8
      final decodeData = utf8.decode(response.bodyBytes);
      return jsonDecode(decodeData);
    } catch (e) {
      // handle any exceptions here
    }
    return null;
  }

  /// Retourne la liste des thèmes de quiz possible sous forme d'une listview de QuizItem
  _listQuiz(){
    return SingleChildScrollView( //MUST TO ADDED
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [//any widgets,
          ListView.builder(
            shrinkWrap: true, //MUST TO ADDED
            physics: NeverScrollableScrollPhysics(), //MUST TO ADDED
            itemCount: quiz.length,
            itemBuilder: (BuildContext c, int index) => QuizItem(
              id: quiz[index]['_id'], 
              name: quiz[index]['name']
            ),
          ),
        ],
      ),
    );
  }

  /// Charge les different quiz
  /// et retourne une listeview une fois chargé
  _body(){
    return FutureBuilder<dynamic>(
      future: _loadQuizzes(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  // AsyncSnapshot<Your object type>
        if( snapshot.connectionState == ConnectionState.waiting){
            return Container(height: 0,);
        } else {
          if (snapshot.hasError)
            return Container(height: 0,);
          else {
            return _listQuiz();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }
}