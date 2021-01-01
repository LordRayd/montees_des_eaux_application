import 'dart:async';
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

  GoogleMapController _controller;

  Set<Marker> _markers = new Set<Marker>();
  Set<Polygon> _polygons = new Set<Polygon>();
  MapType _mapType = MapType.normal;
  BitmapDescriptor icon;

  /// Adresse url du serveur distant
  String server_URL = 'https://montess-des-eaux-server.herokuapp.com/';
  /// Route sur le serveur menant aux hotspots
  String route_URL_Markers = 'hotspots';
  /// Route sur le serveur menant aux hotspots
  String route_URL_Polygons = 'polygons';

  double timevalue = 1;

  @override
  void initState() {
    _createIcon();
    super.initState();
  }

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

  _loadHotSpots(LatLngBounds coords) async{
    _getHotSpots(coords).then((result){
      if(result != null && result.length > 0){
        _markers.clear();
        for(var hotspotInfo in result){
          HotSpotWidget hotspot_ = HotSpotWidget(
            id: hotspotInfo['hostspotID'],
            name : hotspotInfo['name'],
            location : hotspotInfo['location'],
            coord : hotspotInfo['coord'],
            info: hotspotInfo['info'],
            tags : _createTag(hotspotInfo),
            media : _createMedia(hotspotInfo)
          );
          _addMarker(hotspot_);
        }
      }
    });
  }
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
      return decodeData;
    } catch (e) {
      // handle any exceptions here
    }
    return null;
  }
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

  List<String> _createMedia(hotspotInfo){
    List<String> medias = new List<String>();
    for(int i=0; i<hotspotInfo['media'].length; i++){
      medias.add(hotspotInfo['media'][i]['url']);
    }
    return medias;
  }

  HotSpotWidget hotspot = HotSpotWidget(
    id: 3,
    name : "Nom de l'HotSpot 3",
    location : "Vannes",
    coord : {
      "lat" : 47.640062,
      "long" : -2.948185,
      "alt" : 1
    },
    info: "Les informations concernant ce spot très précis 3",
    tags : [
      Tag(name : "Rique eau", iconUrl: "https://cdn.icon-icons.com/icons2/721/PNG/512/rain_weather_water_icon-icons.com_62506.png"),
      Tag(name: "Risque sable",iconUrl: "https://cdn.icon-icons.com/icons2/645/PNG/512/cubo_arena_playa_icon-icons.com_59608.png",)
    ],
    media : [
      "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Colombus_Isle.JPG/1280px-Colombus_Isle.JPG",
      "https://www.dreamyachtcharter.com/wp-content/uploads/2019/02/anse-aux-prunes-e1550620631305.jpg"
    ]
  );

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
        SpeedDialChild(
          child: Icon(Icons.terrain, color: logoColor),
          backgroundColor: colorChild,
          onTap: () => _addMarker(hotspot),
          label: 'Dev',
          labelStyle: TextStyle(fontWeight: FontWeight.w500, color: logoColor),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
      ],
    );
  }

  _sliderOnChanged(newVal){
    setState(() {
      timevalue = newVal;
    });
  }

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
  
  _addMarker(HotSpotWidget _hotspot){
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_hotspot.id.toString()),
          position: LatLng(_hotspot.coord['lat'], _hotspot.coord['long']),
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

  void _onMapCreated(GoogleMapController controller){
    _controller = controller;
  }

  _onCameraMovement(CameraPosition position) async{
    LatLngBounds coords = await _controller.getVisibleRegion();
    _loadBathymetrie(coords);
    _loadHotSpots(coords);
  }

  _buildMap(){
    return GoogleMap(
      mapType: _mapType,
      myLocationEnabled: true,
      mapToolbarEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(47.640666, -2.951548),
        zoom: 14,
      ),
      onMapCreated: _onMapCreated,
      onCameraMove: _onCameraMovement,
      markers: _markers,
      polygons: _polygons,
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