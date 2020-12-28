import 'package:flutter/material.dart';

class QuizWidget extends StatefulWidget {
  String name;
  QuizWidget({Key key, @required this.name}): super(key: key);
  @override
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {

  List<Widget> pages = new List<Widget>();
  int _indexPages = 0;

  _loadQuiz() async{
    getQuiz().then((result) {
      
    });

  }
  getQuiz() async{
    return {
      'name' : 'Plage',
      'questions' : [
        {
          'question' : 'Quelle ville est la capital de la France ?',
          'answers' : [
            {
              'answer' : 'Paris',
              'isGoodAnswer' : 1
            },{
              'answer' : 'Marseille',
              'isGoodAnswer' : 0
            },{
              'answer' : 'Lorient',
              'isGoodAnswer' : 0
            },{
              'answer' : 'Vannes',
              'isGoodAnswer' : 0
            }
          ]
        },{
          'question' : 'Pourquoi ?',
          'answers' : [
            {
              'answer' : 'Pourquoi pas ?',
              'isGoodAnswer' : 0
            },{
              'answer' : '42',
              'isGoodAnswer' : 1
            },{
              'answer' : 'Parce que',
              'isGoodAnswer' : 0
            },{
              'answer' : 'lol',
              'isGoodAnswer' : 0
            }
          ]
        }
      ]
    };
  }

  _body(){
    pages.add(Center(child:Text(widget.name)));
    return IndexedStack(
      index: _indexPages,
      children: pages,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }
}