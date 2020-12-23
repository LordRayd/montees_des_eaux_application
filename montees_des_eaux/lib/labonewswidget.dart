import 'package:flutter/material.dart';
import 'newsitem.dart';
class LaboNewsWidget extends StatefulWidget {
  @override
  _LaboNewsWidgetState createState() => _LaboNewsWidgetState();
}

class _LaboNewsWidgetState extends State<LaboNewsWidget> {

  
  List<NewsItem> newsList = List<NewsItem>();


  @override
  void initState() {
    newsList.add(NewsItem(title: "Item 1", description: "Description 1"));
    newsList.add(NewsItem(title: "Item 2", description: "Description 2"));
    newsList.add(NewsItem(title: "Item 3", description: "Description 3"));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: newsList.length,
        itemBuilder: (BuildContext context, int index) {
          return newsList[index];
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      )
    );
  }
}