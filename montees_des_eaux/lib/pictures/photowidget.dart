/// Samuel LE BERRE - JANVIER 2021
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share/share.dart';

class PhotoWidget extends StatefulWidget {

  /// L'url de la photo
  String url;
  /// L'identifiant du hotspot
  var hotspotID;

  PhotoWidget({
    Key key, 
    @required this.url, 
    @required this.hotspotID,
  }) : super(key: key);
  @override
  
  _PhotoWidgetState createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends State<PhotoWidget> {

  /// Vrai si la photo est favorite, fausse sinon
  bool _isfavorite = false;

  /// Charge les photos Favorite
  loadFavorite() async {
    var photos = await Hive.openBox('favoritePhoto');
    for(int i=0; i<photos.length; i++){
      if(photos.get(i)['url'] == widget.url){
        _isfavorite = true;
      }
    }
  }

  /// Définit les actions a faire quand on appuie sur le boutons favorie
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

  /// Ajoute l'image au favories local
  addLocal() async {
    var photos = await Hive.openBox('favoritePhoto');
    var save = {
      'url' : widget.url,
      'hotspotID' : widget.hotspotID
    };
    photos.add(save);
  }
  /// Retire l'image des favories
  removeFromLocal() async{
    var photos = await Hive.openBox('favoritePhoto');
    List list = new List();
    for(int i=0; i<photos.length; i++){
      if(photos.get(i)['url'] != widget.url){
        list.add(photos.getAt(i));
      }
    }
    await photos.clear();
    for(var nb in list){
      photos.add(nb);
    }
  }

  /// Définit l'action de partage de la photo
  _shareAction() async{
    final RenderBox box = context.findRenderObject();
    
    Share.share("Regarde cette image ${widget.url}",
      subject: "Cette image est incroyable",
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
    );
  }

  /// Constuit le bouton de favorie après l'éxécution de [loadFavorite]
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
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(widget.url),
        )
      ),
    );
  }
}