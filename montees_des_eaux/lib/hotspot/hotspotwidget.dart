import 'package:flutter/material.dart';
import 'package:montees_des_eaux/pictures/photowidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'tag.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hive/hive.dart';
import 'package:share/share.dart';
class HotSpotWidget extends StatefulWidget {

  /// L'identifiant du hotspot
  var id;
  /// Le nom du hotspot
  String name;
  /// La localisation (Ville)
  String location;
  /// La latitude a laquelle se trouve le hotspot
  double latitude;
  /// La longitude du hotspot
  double longitude;
  /// L'altitude du hotspot
  double altitude;
  /// Les informations qui caractérise le hotspot
  String info;
  /// Une liste de Tags affecter au hotspot
  List<Tag> tags;
  /// La liste des photos (url) du hotspot
  List<String> media;

  HotSpotWidget({
    Key key, 
    @required this.id, 
    @required this.name, 
    @required this.location,
    @required this.latitude, 
    @required this.longitude,
    this.altitude, 
    @required this.info,
    @required this.tags,
    @required this.media,
  }) : super(key: key);
  @override

  _HotSpotWidgetState createState() => _HotSpotWidgetState();
}

class _HotSpotWidgetState extends State<HotSpotWidget> {

  bool _isfavorite = false;

  /// Charge les favories et permet de dire si le hotspot actuel fait partie des favories
  loadFavorite() async {
    var hotspots = await Hive.openBox('hotspots');
    for(int i=0; i<hotspots.length; i++){
      if(hotspots.get(i) == widget.id){
        _isfavorite = true;
        break;
      }
    }
  }

  /// Definit les actions a faire lors de la pression sur le bouton favorie
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

  /// Ajoute le hotspot au favorie
  addLocal() async {
    var hotspots = await Hive.openBox('hotspots');
    hotspots.add(widget.id);
  }
  /// Retire le hotspot des hotspots favories
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

  /// Définit l'action de partage du hotspot
  _shareAction() async{
    final RenderBox box = context.findRenderObject();
    
    Share.share(
      "J'ai trouvé des informations très interressante sur : ${widget.name} ${widget.media[0]}",
      subject: "Ce lieux est très intéressant",
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
    );
  }

  /// Utilise la librairie flutter_swiper pour créer le slider d'image
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

  /// Construit le slider des images
  _buildImageSlider(){
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height * 0.3
      ),
      child: (widget.media.length == 1) 
        ? Image.network(widget.media[0]) 
        : imageSlider(context)
    );
  }

  /// Construit l'affichage du nom du hotspot qui sera mit par dessus les photos
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

  /// Contruit la partie haute du widget c'est a dire le defilement des images
  /// et le texte par dessus
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

  /// Retourne un textButton dont le texte est [text] 
  /// et l'action lors de la pression est [onPressed] 
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

  /// Construit les boutons en dessous des photos dans widget 
  _buildButton(){
    return Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: _buildTextButton("Y aller",() async{
            final url = 'https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          }),
          
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

  /// Construit la liste des tags
  _buildTags(){
    return Row(
      children : widget.tags
    );
  }

  /// Construit la liste des Informations
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
            Expanded(
              child: RichText(
                maxLines: 200,
                text: TextSpan(
                  text : widget.info,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05,),            
          ],
        )
      ],
    );
  }

  /// Permet la creation d'espace en hauteur
  _buildSpace(size){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1 * size,
    );
  }

  /// Construit le bouton favorie après l'execution de [loadFavorite]
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImage(),
            _buildSpace(0.1),
            _buildButton(),
            _buildSpace(0.1),
            _buildInformations()
          ],
        ),
      ),
    );
  }
}