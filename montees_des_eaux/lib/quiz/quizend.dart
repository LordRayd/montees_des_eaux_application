import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:montees_des_eaux/quiz/question.dart';
import 'package:montees_des_eaux/rewards/rewardobtention.dart';
import 'package:montees_des_eaux/rewards/rewardwidget.dart';

class QuizEnd extends StatefulWidget {

  /// L'identifiant du quiz
  var quizId;
  /// La liste des réponse donné
  List<int> result;
  /// La liste des questions posés
  List<Question> questions;

  QuizEnd({
    Key key,
    @required this.quizId,
    @required this.result, 
    @required this.questions
  }) : super(key: key);

  @override
  _QuizEndState createState() => _QuizEndState();
}

class _QuizEndState extends State<QuizEnd> {

  /// Le pourcentage de bonne réponse
  double percent = 0.0;
  /// Adresse url du serveur distant
  String server_URL = 'https://montess-des-eaux-server.herokuapp.com/';
  /// Route sur le serveur menant aux hotspots
  String route_URL = 'rewards';

  @override
  void initState() {
    
    // calcul le pourcentage de bonne réponse
    for(int i=0; i<widget.result.length; i++){
      if(widget.questions[i].answers[widget.result[i]].isGood==true) percent++;
    }
    percent = (percent / widget.result.length)*100;
    _loadRewards();
    super.initState();
  }

  /// Charge tous les rewards en lien avec le quiz
  _loadRewards() async{
    await _getRewards().then((result) async {
      if(result != null && result.length > 0){
        await getRewardsFromLocal().then((listId){
          List<RewardWidget> list_reward = new List<RewardWidget>();
          for(var reward in result){
            if(percent>= reward['percentageObtention']){
              bool isOwned = false;
              for(int i=0; i<listId.length; i++){
                if(listId[i] == reward['_id']){
                  isOwned = true;
                }
              }
              if(isOwned==false){
                log(reward['_id']);
                addRewardLocal(reward['_id']);
                list_reward.add(
                  RewardWidget(
                    id: reward['_id'],
                    previewText: reward['previewText'],
                    description: reward['description'],
                    url: reward['media'],
                    level: reward['level'],
                    percentObtention: reward['percentageObtention'].toDouble(),
                    quizId: reward['quizId'],
                  )
                );
              }
            }            
          }
          _printRewards(list_reward);
        });     
      }
    });
  }
  /// Ajoute le rewards au recompenses obtenues par son id
  addRewardLocal(id) async{
    var rewards = await Hive.openBox('rewards');
    rewards.add(id);
  }

  /// Retourne les rewards deja obtenues
  getRewardsFromLocal() async{
    final rewards = await Hive.openBox('rewards');
    List<String> list = new List<String>();
    for(int i=0; i< rewards.length; i++){
      list.add(rewards.get(i));
    }
    return list;
  }

  /// Affiche les rewards qui viennent juste d'être obtenues
  _printRewards(List<RewardWidget> list_reward){
    if(list_reward.length > 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text( 
                (list_reward.length >1) 
                  ? 'Vous avez obtenues les trophées suivants' 
                  : 'Vous avez obtenue le trophée suivant'
              ),
            ),
            content: RewardObtentionWidget(rewards: list_reward,),
          );
        },
      );
    }
  }

  /// Recupère les rewards avec le [quiId] depuis le serveur
  _getRewards() async{
    try {
      final client = http.Client();
      final response = await client.get(server_URL+route_URL +'/'+ widget.quizId);
      // Important d'utilisé les bytes pour ne pas avoir de problème avec utf8
      final decodeData = utf8.decode(response.bodyBytes);
      return jsonDecode(decodeData);
    } catch (e) {
      // handle any exceptions here
    }
    return null;
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
            "Vous avez obtenus ${percent.toInt()}% de bonnes réponses",
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
        (widget.questions[index].answers[widget.result[index]].isGood==true) 
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