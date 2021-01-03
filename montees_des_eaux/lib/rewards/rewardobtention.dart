
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:montees_des_eaux/rewards/rewardwidget.dart';

class RewardObtentionWidget extends StatefulWidget {

  /// La liste des rewards obtenues
  List<RewardWidget> rewards;

  RewardObtentionWidget({
    Key key,
    @required this.rewards,
  }) : super(key: key);

  @override
  _RewardObtentionWidgetState createState() => _RewardObtentionWidgetState();
}

class _RewardObtentionWidgetState extends State<RewardObtentionWidget> {
  
  /// Le controlleur de page
  final _controller = PageController(
    initialPage: 0,
  );

  /// L'index de la page afficher
  int _index = 0;

  /// La liste des differents affichage d'icon possible
  List<Row> rows = List<Row>();
  
  @override
  void initState() {
    super.initState();
    _buildRows();
  }

  /// Construit les icons pour un index données
  Row _buildRow(index){
    List<Icon> icons = List<Icon>();
    for(int i=0; i<widget.rewards.length; i++){
      icons.add(
        Icon(
          Icons.lens, 
          color: (index==i) 
            ? Colors.black 
            : Colors.grey
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children : icons,
    );
  }

  /// Construit tous les affichage possible des icons
  _buildRows(){
    for(int i=0; i<widget.rewards.length; i++){
      rows.add(_buildRow(i));
    }
  }

  /// Actions lors du changement d'affichage de trophée obtenues
  _onPageChange(int index){
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(  
          height: MediaQuery.of(context).size.height * 0.4,
          child: PageView.builder(
            onPageChanged: _onPageChange,
            physics: BouncingScrollPhysics(),
            controller: _controller,
            itemCount: widget.rewards.length,
            itemBuilder: (context, index) {
              return widget.rewards[index];
            },
          ),
        ), 
        (widget.rewards.length > 1) 
          ? rows[_index] 
          : Container(height:0),
      ],
    );
  }
}