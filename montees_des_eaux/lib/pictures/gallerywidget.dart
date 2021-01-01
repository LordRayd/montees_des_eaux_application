import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:montees_des_eaux/pictures/photowidget.dart';

class GalleryWidget extends StatefulWidget {
  @override
  _GalleryWidgetState createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {

  List<PhotoWidget> galleryItems = new List<PhotoWidget>();
  
  Widget _buildGrid() => GridView.extent(
    maxCrossAxisExtent: 150,
    padding: const EdgeInsets.all(4),
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    children: _buildGridTileList(galleryItems.length),
  );

  List<Container> _buildGridTileList(int count) => List.generate(
    count, (i) => Container(
      child: InkWell(
        child: Image.network(galleryItems[i].url),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => galleryItems[i]),
          );
        },
      )
    )
  );
    
  _noFavoriteText(){
    return Center(
      child: Text(
        "Vous n'avez définis aucune photo comme favorie",
      )
    );
  }

  _loadFavoritesPictures() async{
    var photos = await Hive.openBox('favoritePhoto');
    for(int i=0; i<photos.length; i++){
      galleryItems.add(PhotoWidget(url: photos.getAt(i)['url'], hotspotID: photos.getAt(i)['hotspotID']) );
    }
  }

  _body(){
    return FutureBuilder<dynamic>(
      future: _loadFavoritesPictures(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  // AsyncSnapshot<Your object type>
        if( snapshot.connectionState == ConnectionState.waiting){
            return  Center(child: Text('Chargement des photos préférés'));
        } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else {
              if(galleryItems.isEmpty)
                return _noFavoriteText();
              else 
                return _buildGrid();
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes Photos favoris"),
      ),
      body: _body(),
    );
  }
}