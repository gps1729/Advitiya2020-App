import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var _home;

  _buildBody() {
    return FutureBuilder(
      future: getNotificationFromServer(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ));
        if (snapshot.hasData) {
          if (snapshot.data.length == 0)
            return Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.notifications_none),
                    Text('No Notifications Yet!')
                  ],
                ),
              ),
            );
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final yesterday = DateTime(now.year, now.month, now.day - 1);
          return Container(
              color: Colors.black87,
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  DateTime startdateTime =
                      DateTime.parse(snapshot.data[index]['created_on'])
                          .toLocal();
                  // parse time string
                  final time =
                      formatDate(startdateTime, [h, ':', nn, ' ', am]);
                  // parse date string
                  final aDate = DateTime(startdateTime.year,
                      startdateTime.month, startdateTime.day);
                  String date;
                  if (aDate == today)
                    date = 'Today';
                  else if (aDate == yesterday)
                    date = 'Yesterday';
                  else
                    date = formatDate(startdateTime, [d, ' ', M]);
                  return Card(
                      color: Colors.black,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8.0),
                        title: Wrap(children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(7.0),
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.all(
                                    Radius.circular(20.0))),
                            child: Text(
                              snapshot.data[index]['title'],
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                          )
                        ]),
                        subtitle: Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(
                              snapshot.data[index]['content'],
                              style: TextStyle(color: Colors.white),
                            )),
                        trailing: Container(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                              Text(
                                time,
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                date,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10.0),
                              )
                            ])),
                      ));
                },
              ));
        } else if (snapshot.hasError) {
          return Center(
              child: RaisedButton(
            child: Icon(Icons.replay),
            onPressed: () {
              setState(() {
                _home = _buildBody();
              });
            },
          ));
        } else
          return Container(
              color: Colors.black,
              child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  @override
  void initState() {
    _home = _buildBody();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.black, title: Text('Notifications')),
      body: _home,
    );
  }

  getNotificationFromServer() async {
    final response = await http.get("https://advitiya.in/api/notifications/");

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      var jsonData = json.decode(response.body);
      jsonData.sort((a, b) {
        return b['created_on'].toString().compareTo(a['created_on'].toString());
      });
      return jsonData;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
