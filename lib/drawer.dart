import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import './About.dart' as about;

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                ListTile(
                  title: Text("Phone: +91 8001481473"),
                  leading: Icon(Icons.phone),
                  onTap: () {
                    launch('tel:+91 8001481473');
                  },
                ),
                ListTile(
                  title: Text("advitiya@iitrpr.ac.in"),
                  leading: Icon(Icons.email),
                  onTap: () {
                    launch('mailto:advitiya@iitrpr.ac.in');
                  },
                ),
              ],
            )));
  }
}
