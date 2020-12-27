import 'package:flutter/material.dart';

class Tag extends StatefulWidget {

  String name;
  String iconUrl;

  Tag({Key key,
  @required this.name,
  @required this.iconUrl
  }) : super(key: key);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {

  _openTag(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.name,
                textScaleFactor: 1.5,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(widget.iconUrl),
                backgroundColor: Colors.transparent,
                radius: 100,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CircleAvatar(
        backgroundImage: NetworkImage(widget.iconUrl),
        backgroundColor: Colors.transparent,
        radius: 15,
      ),
      onTap: _openTag,
    );
  }
}