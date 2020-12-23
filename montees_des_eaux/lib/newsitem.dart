import 'package:flutter/material.dart';

class NewsItem extends StatefulWidget {

  String title;
  String description;
  
  NewsItem({Key key, @required this.title, @required this.description}) : super(key: key);

  @override
  _NewsItemState createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(widget.title),
        Text(widget.description),
      ]
    );
  }
}