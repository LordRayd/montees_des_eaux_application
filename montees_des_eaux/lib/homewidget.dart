import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:montees_des_eaux/hotspot/hotspotwidget.dart';
import 'hotspot/tag.dart';
import 'dart:developer';
class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  /// Le controlleur de la carte
  GoogleMapController _controller;
  /// La liste des markers afficher sur la crate
  Set<Marker> _markers = new Set<Marker>();
  /// La liste des polygons afficher sur la carte
  Set<Polygon> _polygons = new Set<Polygon>();
  /// Le type de carte
  MapType _mapType = MapType.normal;
  /// L'icone des marker
  BitmapDescriptor icon;
  /// Adresse url du serveur distant
  String server_URL = 'https://montess-des-eaux-server.herokuapp.com/';
  /// Route sur le serveur menant aux hotspots
  String route_URL_Markers = 'hotspots';
  /// Route sur le serveur menant aux hotspots
  String route_URL_Polygons = 'polygons';
  /// La valeur du slider de temps
  double timevalue = 1;

  @override
  void initState() {
    _createIcon();
    super.initState();
  }

  /// Recupère les données bathymétrique du serveur depuis des coordonnées précise
  /// Et les ajoute a [_polygons]
  _loadBathymetrie(LatLngBounds coords) async{
    _getBathymetrie(coords).then((result){
      if(result != null && result.length > 0){
        _polygons.clear();
        int id =0;
        for(var polygons_ in result){
          List<LatLng> polygonsPoints = new List<LatLng>();
          for(int i=0; i<polygons_['polygons'].length; i++){
            polygonsPoints.add(LatLng(polygons_['polygons'][i][0], polygons_['polygons'][i][1]));
          }
          Color color = (polygons_['color'] == 'blue') ? Colors.blue : Colors.green;
          _addPolygon(id, polygonsPoints, color);
          id++;
        }
      }
    });
  }

  /// Recupere les données bathymétrique
  _getBathymetrie(LatLngBounds coords) async{
    try {
      final response = await http.post(
        server_URL + route_URL_Polygons,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'time' : timevalue, //0 passé, 1 présent, 2 futur
          'sw' : {
            'lat' : coords.southwest.latitude,
            'lon' : coords.southwest.longitude
          },
          'ne' : {
            'lat' : coords.northeast.latitude,
            'lon' : coords.northeast.longitude
          },
          'se' : {
            'lat' : coords.southwest.latitude,
            'lon' : coords.northeast.longitude
          },
          'nw' : {
            'lat' : coords.northeast.latitude,
            'lon' : coords.southwest.longitude
          }
        }),
      );
      // Important d'utilisé les bytes pour ne pas avoir de problème avec utf8
      final decodeData = utf8.decode(response.bodyBytes);
      return jsonDecode(decodeData);
    } catch (e) {
      // handle any exceptions here
    }
    return null; 
  }

  /// Charge les hotspots et les ajoute à [_markers]
  _loadHotSpots(LatLngBounds coords) async{
    await _getHotSpots(coords).then((result){
      setState(() {
        _markers.clear();  
      });
      if(result != null && result.length > 0){
        for(var hotspotInfo in result){
          HotSpotWidget hotspot_ = HotSpotWidget(
            id: hotspotInfo['_id'],
            name : hotspotInfo['name'],
            location : hotspotInfo['location'],
            latitude : hotspotInfo['coords']['coordinates'][1],
            longitude : hotspotInfo['coords']['coordinates'][0],
            info: hotspotInfo['info'],
            tags : _createTag(hotspotInfo),
            media : _createMedia(hotspotInfo)
          );
          _addMarker(hotspot_);
        }
      }
    });
  }
  /// Recupère les hotspots afficher antre les coordonnées afficher par l'écran
  _getHotSpots(LatLngBounds coords) async {
    try {
      final response = await http.post(
        server_URL + route_URL_Markers,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'sw' : {
            'lat' : coords.southwest.latitude,
            'lon' : coords.southwest.longitude
          },
          'ne' : {
            'lat' : coords.northeast.latitude,
            'lon' : coords.northeast.longitude
          },
          'se' : {
            'lat' : coords.southwest.latitude,
            'lon' : coords.northeast.longitude
          },
          'nw' : {
            'lat' : coords.northeast.latitude,
            'lon' : coords.southwest.longitude
          }
        }),
      );
      // Important d'utilisé les bytes pour ne pas avoir de problème avec utf8
      final decodeData = utf8.decode(response.bodyBytes);
      return jsonDecode(decodeData);
    } catch (e) {
      // handle any exceptions here
    }
    return null;
  }

  /// Crée une liste de tag
  List<Tag> _createTag(hotspotInfo){
    List<Tag> tags = new List<Tag>();
    for(int i=0; i<hotspotInfo['tags'].length; i++){
      tags.add(new Tag(
        name: hotspotInfo['tags'][i]['name'], 
        iconUrl: hotspotInfo['tags'][i]['icon']
      ));
    }
    return tags;
  }

  /// Crée une liste de média 
  List<String> _createMedia(hotspotInfo){
    List<String> medias = new List<String>();
    for(int i=0; i<hotspotInfo['media'].length; i++){
      medias.add(hotspotInfo['media'][i]['url']);
    }
    return medias;
  }

  /// Affiche le menu de changement de fond de carte
  _buildPopUpMenu(){
    Color colorChild = Colors.deepOrange;
    Color logoColor = Colors.white;
    return SpeedDial(
      marginBottom: 100,
      marginRight: 8,
      backgroundColor: Colors.red,
      child: Icon(Icons.map),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      children: [
        SpeedDialChild(
          child: Icon(Icons.satellite, color: logoColor),
          backgroundColor: colorChild,
          onTap: () => {
            setState(() {
              _mapType = MapType.satellite;
            })
          },
          label: 'Satellite',
          labelStyle: TextStyle(fontWeight: FontWeight.w500, color: logoColor),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.layers, color: logoColor),
          backgroundColor: colorChild,
          onTap: () => {
            setState(() {
              _mapType = MapType.normal;
            })
          },
          label: 'Plan',
          labelStyle: TextStyle(fontWeight: FontWeight.w500, color: logoColor),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.terrain, color: logoColor),
          backgroundColor: colorChild,
          onTap: () => {
            setState(() {
              _mapType = MapType.hybrid;
            })
          },
          label: 'Hybride',
          labelStyle: TextStyle(fontWeight: FontWeight.w500, color: logoColor),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
      ],
    );
  }

  /// execute a chaque changement du slider le refresh des données bathymétriques
  _sliderOnChanged(newVal) async{
    setState(() {
      timevalue = newVal;
    });
    print(timevalue);
    LatLngBounds coords = await _controller.getVisibleRegion();
    _loadBathymetrie(coords);
  }

  /// Construit le slider
  _buildSlider(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            Expanded(
              flex: 8, // 80%
              child: Slider(
                activeColor: Colors.red,
                inactiveColor: Colors.redAccent,
                value: timevalue, 
                onChanged: _sliderOnChanged,
                min: 0,
                max: 2,
                divisions: 2,
              ),
            ),
            Expanded(
              flex: 2, // 20%
              child: Container(),
            )
          ],
        ),
        
      ],
    );
  }

  /// Permet l'ajout d'un poluygons à [_polygons] à partir des données fournies
  _addPolygon(int id, List<LatLng> polygonPoints, Color color){
    setState(() {
      _polygons.add(
        Polygon(
          polygonId: PolygonId('$id'),
          points: polygonPoints,
          fillColor: color,
          strokeWidth: 0,
      ));
    });
  }
  
  /// Ajoute un hotspot a la liste de [_markers] avec les données du [_hotspot]
  _addMarker(HotSpotWidget _hotspot){
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_hotspot.id),
          position: LatLng(_hotspot.latitude, _hotspot.longitude),
          icon: icon,
          infoWindow: InfoWindow(
            title: _hotspot.name,
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => _hotspot),
              );
            },
          ),
        )
      );
    });
  }
  /// Ajoute une liste de HotSpotWidget à la carte
  _addMarkers(List<HotSpotWidget> list){
    log(list.length.toString());
    for(int i=0; i<list.length; i++){
      _addMarker(list[i]);
    }
  }

  /// Crée l'icon des markers
  _createIcon() async{
    final iconData = Icons.place;
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final iconStr = String.fromCharCode(iconData.codePoint);
    textPainter.text = TextSpan(
      text: iconStr,
      style: TextStyle(
        letterSpacing: 0.0,
        fontSize: 100.0,
        fontFamily: iconData.fontFamily,
        color: Colors.red,
      )
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(0.0, 0.0));
    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(100, 100);
    final bytes = await image.toByteData(format: ImageByteFormat.png);
    setState(() {
      icon = BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());;
    });
  }

  /// Recupère le controleur de la map dans la variable [_controller]
  void _onMapCreated(GoogleMapController controller){
    _controller = controller;
  }

  /// Action a faire a chaque fin de mouvement de carte
  /// Charge les nouveaux hotspots et la bathymétrie
  _onCameraMovement() async{
    LatLngBounds coords = await _controller.getVisibleRegion();
    //_loadBathymetrie(coords);
    _loadHotSpots(coords);
  }

  /// Construit la carte
  _buildMap(){
    return GoogleMap(
      mapType: _mapType,
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(47.660548, -2.759460),
        zoom: 12,
      ),
      onMapCreated: _onMapCreated,
      markers: _markers,
      polygons: _polygons,
      onCameraIdle: _onCameraMovement,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: _buildMap(),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: _buildSlider(),
          ),
        ],
      ),
      floatingActionButton: _buildPopUpMenu(),
    );
  }
}