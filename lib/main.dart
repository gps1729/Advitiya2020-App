import 'dart:io';
import 'package:advitiya/model.dart';
import 'package:http/http.dart' as http;
import 'package:advitiya/schdule.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './About.dart' as about;
import './lecture.dart';
import './schdule.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: <String, WidgetBuilder>{}));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _home, _shedule, _pronight;
// static const platform = const MethodChannel('com.softcom.zeitgeist/map_view');

  _buildschedule() {
    return FutureBuilder(
      future: getDataFromServer(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container(
              color: Colors.black,
              child: Center(
                child: Image.asset(
                  'Images/appbar.png',
                  fit: BoxFit.fill,
                ),
              ));
        if (snapshot.hasData) {
          return Schdule(snapshot.data);
        } else if (snapshot.hasError) {
          return Center(
              child: RaisedButton(
            child: Icon(Icons.replay),
            onPressed: () {
              setState(() {
                _home = _buildschedule();
              });
            },
          ));
        } else
          return Container(
              color: Colors.black,
              child: Center(
                child: Image.asset(
                  'Images/loading.gif',
                  fit: BoxFit.fill,
                ),
              ));
      },
    );
  }

  @override
  void initState() {
    _pronight = CarouselDemo();
    _shedule = _buildschedule();
    _home = _shedule;
    super.initState();
  }

  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      new Container(
        child: Image.asset(
          'Images/appbar.png',
          fit: BoxFit.fill,
        ),
        color: Colors.black,
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              "Advitiya 2020",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.notifications_active,
                  size: 30.0,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/notipage');
                },
              )
            ],
          ),
          drawer: Drawer(
              child: Container(
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      DrawerHeader(
                          padding: EdgeInsets.all(0),
                          child: Image.asset(
                            'Images/drawerposter.jpg',
                            fit: BoxFit.fill,
                          )),
                      Container(
                        //margin: EdgeInsets.only(top: 50),
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            'REGISTER',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: Icon(Icons.add),
                          onTap: () {
                            launch("https://www.advitiya.in/events/");
                          },
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            'TECHCONNECT',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: Icon(Icons.work),
                          onTap: () {
                            launch("https://www.advitiya.in/techconnect/");
                          },
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            'WORKSHOPS',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: Icon(Icons.computer),
                          onTap: () {
                            launch("https://www.advitiya.in/workshop/");
                          },
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            'CAMPUS AMBASSADOR',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: Icon(Icons.group_work),
                          onTap: () {
                            launch("https://www.advitiya.in/ca/");
                          },
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            'SPONSERS',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: Icon(Icons.attach_money),
                          onTap: () {
                            launch("https://www.advitiya.in/sponsors/");
                          },
                        ),
                      ),
                      Container(
                        child: ListTile(
                          title: Text(
                            'ABOUT US',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: Icon(Icons.info),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    about.About("About us")));
                          },
                        ),
                      ),
                      ListTile(
                        title: Text("Phone: +91 842 7012 721"),
                        leading: Icon(Icons.phone),
                      ),
                      ListTile(
                        title: Text("zeitgeist.pr@iitrpr.ac.in"),
                        leading: Icon(Icons.email),
                      ),
                    ],
                  ))),
          body: _home,
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(

                // sets the background color of the `BottomNavigationBar`
                canvasColor: Colors.transparent,
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: Colors.white,
                textTheme: Theme.of(context)
                    .textTheme
                    .copyWith(caption: new TextStyle(color: Colors.white))),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("Images/appbar.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedPage,
                onTap: (int index) {
                  setState(() {
                    _selectedPage = index;
                    if (index == 0)
                      _home = _shedule;
                    else if (index == 1)
                      _home = _pronight;
                    else
                      _home = _pronight;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.event,
                        color: Colors.lightBlueAccent[400],
                      ),
                      title: Text(
                        'Schedule',
                      ),
                      backgroundColor: Color.fromRGBO(166, 16, 30, 1)),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.star,
                        color: Colors.lightBlueAccent[400],
                      ),
                      title: Text('Pro-Nights'),
                      backgroundColor: Color.fromRGBO(166, 16, 30, 1)),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.map,
                        color: Colors.lightBlueAccent[400],
                      ),
                      title: Text('Map'),
                      backgroundColor: Color.fromRGBO(166, 16, 30, 1))
                ],
              ),
            ),
          )),
    ]);
  }
Future<List<EventModel>> getDataFromServer() async {
    final response = await http.get("https://advitiya.in/api/events/");

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      var jsonData = json.decode(response.body);
      jsonData.sort((a, b) {
        return a['start_date_time']
            .toString()
            .compareTo(b['start_date_time'].toString());
      });
      List<EventModel> events = [];
      for (Map event in jsonData) {
        events.add(EventModel.fromJson(event));
      }
      return events;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
