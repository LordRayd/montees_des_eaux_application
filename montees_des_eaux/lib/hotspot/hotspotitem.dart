import 'package:flutter/material.dart';
import 'package:montees_des_eaux/hotspot/tag.dart';
import 'package:montees_des_eaux/hotspot/hotspotwidget.dart';
class HotSpotItem extends StatefulWidget {

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

  HotSpotItem({
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
  _HotSpotItemState createState() => _HotSpotItemState();
}

class _HotSpotItemState extends State<HotSpotItem> {

  /// Renvoie un espace en largeur de [space] pourcent de l'ecran
  Widget _buildSpace(space){
    return  SizedBox(
      width: MediaQuery.of(context).size.width * 0.1 * space
    );
  }

  /// Retourne une image avec les bords arrondies qui occupe un espace de [space] pourcent de l'ecran
  Widget _buildPicture(space){
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          widget.media[0],
        ), 
      ),
      flex: space,
    );
  }

  /// Renvoie un wiget d'information important de [space] pourcent de l'ecran
  Widget _builtInformations(space){
    return Expanded(
      child: Column(
        children: [
          _buildName(),
          Text(widget.location)
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      flex: space,
    );
  }

  /// Widget de texte affichant le nom du hotspot
  Widget _buildName() {
    return Text(
      widget.name,
      textAlign: TextAlign.left,
      textScaleFactor: 1.05,
      style: TextStyle(
        fontWeight: FontWeight.bold
      ),
    );
  }

  /// Ouvre le HotSpotWidget lorsqu'on tape sur l'HotSpotItem
  _onTap(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HotSpotWidget(
        id: widget.id,
        name: widget.name,
        location: widget.location,
        latitude: widget.latitude,
        longitude: widget.longitude,
        info: widget.info,
        tags: widget.tags,
        media: widget.media,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          _buildPicture(3), // 30%
          _buildSpace(0.4), // 4%
          _builtInformations(6) // 60%
        ],
      ),
      onTap: _onTap,
    );
  }
}