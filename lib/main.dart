import 'package:advitiya/Notification/firebase_notification_settings.dart';
import 'package:advitiya/Notification/notification_page.dart';
import 'package:advitiya/drawer.dart';
import 'package:advitiya/model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:advitiya/schdule.dart';
import 'package:flutter/material.dart';
import './lecture.dart';
import './schdule.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        "/notipage": (BuildContext context) => NotificationPage(),
      }));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _home, _shedule, _pronight;
  static const platform = const MethodChannel('com.softcom.advitiya/map_view');

  _buildschedule() {
    return FutureBuilder(
      future: getDataFromServer(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container(
              color: Colors.black87,
              child: Center(
                child: Image.asset(
                  'Images/loading.gif',
                  fit: BoxFit.cover,
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
    new FirebaseNotifications(context).setUpFirebase();
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
          fit: BoxFit.cover,
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
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/notipage');
                },
              )
            ],
          ),
          drawer: DrawerWidget(),
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
                        Icons.speaker_group,
                        color: Colors.lightBlueAccent[400],
                      ),
                      title: Text('Lectures'),
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
