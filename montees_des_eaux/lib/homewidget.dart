import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:flutter/rendering.dart';
//import 'package:latlong/latlong.dart';

import 'package:montees_des_eaux/hotspot/hotspotwidget.dart';
import 'hotspot/tag.dart';
import 'mapwidget.dart';
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

  double timevalue = 14;


  HotSpotWidget hotspot = HotSpotWidget(
    id: 3,
    name : "Nom de l'HotSpot 3",
    location : "Vannes",
    coord : {
      "lat" : 37.222,
      "long" : 37.222,
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

  _buildOnMap(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            Expanded(
              flex: 8,
              child: Slider(
                value: timevalue, 
                onChanged: (newVal) {
                  setState(() {
                    timevalue = newVal;
                  });
                },
                min: 14,
                max: 18,
                divisions: 4,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(),
            )
          ],
        ),
        
      ],
    );
  }

  _addPolygon(){
    List<LatLng> polygonPoints = new List<LatLng>();
    polygonPoints.add(LatLng(47.639552, -2.946299));
    polygonPoints.add(LatLng(47.639089, -2.946972));
    polygonPoints.add(LatLng(47.638778, -2.946371));
    polygonPoints.add(LatLng(47.639201, -2.945668));
    setState(() {
      _polygons.add(
        Polygon(
          polygonId: PolygonId('1'),
          points: polygonPoints,
          strokeColor: Colors.blue,
          fillColor: Colors.blue,
      ));
    });
  }
  _cameraPosition() async{
    LatLngBounds val = await _controller.getVisibleRegion();
    log(val.toString());
  }
  
  void _onMapCreated(GoogleMapController controller){
    _controller = controller;
  }

  _buildMap(){
    _markers.add(
      Marker(
        markerId: MarkerId('0'),
        position: LatLng(47.640062, -2.948185),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => hotspot),
          );
        },
      )
    );
    return GoogleMap(
      mapType: _mapType,
      myLocationEnabled: true,
      mapToolbarEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(47.640666, -2.951548),
        zoom: 14,
      ),
      onMapCreated: _onMapCreated,
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
            child: _buildOnMap(),
          ),
        ],
      ),
      floatingActionButton: _buildPopUpMenu(),
    );
  }
}