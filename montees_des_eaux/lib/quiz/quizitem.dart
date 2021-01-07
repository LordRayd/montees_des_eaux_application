/// Samuel LE BERRE - JANVIER 2021
import 'package:flutter/material.dart';
import 'package:montees_des_eaux/quiz/quiz.dart';

class QuizItem extends StatefulWidget {

  /// L'identifiant du quiz
  var id;
  /// Nom du possible quiz utilisable
  String name;

  QuizItem({
    Key key, 
    @required this.id,
    @required this.name
  }) : super(key: key);

  @override
  _QuizItemState createState() => _QuizItemState();
}

class _QuizItemState extends State<QuizItem> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5, // 50%
        child: TextButton(
          onPressed: (){
            Navigator.of(context).pop(false); // ferme l'alerte dialog de MiscellaneousWidget
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizWidget(id: widget.id, name: widget.name,)),
            );
          }, 
          child: Text(
            widget.name,
          ),
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}