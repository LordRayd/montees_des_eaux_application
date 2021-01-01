import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'labonewswidget.dart';
import 'homewidget.dart';
import 'miscellaneouswidget.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(new MyApp());
    });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Montées des Eaux',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Montées des Eaux'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  int _selectedPage = 1;
  List<Widget> pageList = List<Widget>();

  @override
  void initState() {
    Hive.initFlutter();
    pageList.add(LaboNewsWidget());
    pageList.add(HomeWidget());
    pageList.add(MiscellaneousWidget());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedPage,
        children: pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text("Information"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Accueil"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            title: Text("Quiz")
          )
        ],
        currentIndex: _selectedPage,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }
}
