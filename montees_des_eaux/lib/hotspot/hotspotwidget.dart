import 'package:flutter/material.dart';
import 'package:montees_des_eaux/pictures/photowidget.dart';
import 'tag.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hive/hive.dart';
import 'package:share/share.dart';
import 'package:photo_view/photo_view.dart';

import 'dart:developer';
class HotSpotWidget extends StatefulWidget {

  int id;
  String name;
  String location;
  var coord;
  String info;
  List<Tag> tags;
  List<String> media;

  HotSpotWidget({
    Key key, 
    @required this.id, 
    @required this.name, 
    @required this.location,
    @required this.coord, 
    @required this.info,
    @required this.tags,
    @required this.media,
  }) : super(key: key);
  @override

  _HotSpotWidgetState createState() => _HotSpotWidgetState();
}

class _HotSpotWidgetState extends State<HotSpotWidget> {

  bool _isfavorite = false;

  loadFavorite() async {
    var hotspots = await Hive.openBox('hotspots');
    for(int i=0; i<hotspots.length; i++){
      if(hotspots.get(i) == widget.id){
        _isfavorite = true;
      }
    }
  }

  _favoriteButtonAction() {
    if(_isfavorite){
      removeFromLocal().then((result) => {
        setState(() {
        _isfavorite = !_isfavorite;
        })
      });
    }else {
      addLocal().then((result) => {
        setState(() {
        _isfavorite = !_isfavorite;
        })
      });
    }
  }

  addLocal() async {
    var hotspots = await Hive.openBox('hotspots');
    hotspots.add(widget.id);
  }
  removeFromLocal() async{
    var hotspots = await Hive.openBox('hotspots');
    List<int> list = new List<int>();
    for(int i=0; i<hotspots.length; i++){
      if(hotspots.get(i) != widget.id){
        list.add(hotspots.getAt(i));
      }
    }
    await hotspots.clear();
    for(int nb in list){
      hotspots.add(nb);
    }
  }

  _shareAction() async{
    final RenderBox box = context.findRenderObject();
    
    Share.share("Voici l'image principale de ${widget.name}",
          subject: "Example de partage de hotspot",
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Swiper imageSlider(context){
    return new Swiper(
      autoplay: true,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: Image.network(widget.media[index],
            fit: BoxFit.fitHeight,
          ),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PhotoWidget(url : widget.media[index], hotspotID: widget.id,)),
            );
          },
        );
      },
      itemCount: widget.media.length,
      viewportFraction: 0.8,
      scale: 0.9,
    );
  }

  _buildImageSlider(){
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height * 0.3
      ),
      child: (widget.media.length == 1) ? Image.network(widget.media[0]) : imageSlider(context)
    );
  }

  _buildName(){
    return Container(
      alignment: AlignmentDirectional.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: new Card(
          color: Colors.transparent,
          child:Center(
            child:Text(
              widget.name,
              style: TextStyle(
                fontSize: 25,
                color: Colors.white
              ),
            ),
          ),
        )
      )
    );
  }
  _buildImage(){
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          _buildImageSlider(),
          _buildName()
        ],)
    );
    
  }

  _buildTextButton(text, onPressed){
    return TextButton(
      child: Text(
        text,
        textScaleFactor: 1.20,
      ),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.blue,
        onSurface: Colors.grey,
      ),
    );
  }

  _buildButton(){
    return Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: _buildTextButton("Y aller", (){}),
          
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1,),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: _buildTextButton("Sites Similaires", (){})
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
      ],
    );
  }

  _buildTags(){
    return Row(
      children : widget.tags
    );
  }

  _buildInformations(){
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
            Text(
              "Informations",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
            _buildTags(),
          ],
        ),
        Row(
          children: [
            SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
            Text(
             widget.info, 
            )
          ],
        )
      ],
    );
  }

  _buildSpace(size){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1 * size,
    );
  }

  _buildFavButton() {
    return FutureBuilder<dynamic>(
      future: loadFavorite(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  // AsyncSnapshot<Your object type>
        if( snapshot.connectionState == ConnectionState.waiting){
            return IconButton(
              icon: Icon(Icons.favorite_border), 
              onPressed: _favoriteButtonAction
            );
        } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else {
              return IconButton(
                icon: _isfavorite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border), 
                onPressed: _favoriteButtonAction
              );
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.share,), 
            onPressed: _shareAction
          ),
          _buildFavButton()
        ],
      ),
      body: Column(
        children: [
          _buildImage(),
          _buildSpace(0.1),
          _buildButton(),
          _buildSpace(0.1),
          _buildInformations()
        ],
      ),
    );
  }
}