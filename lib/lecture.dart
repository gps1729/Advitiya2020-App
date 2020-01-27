import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:date_format/date_format.dart';

class CarouselDemo extends StatefulWidget {
  CarouselDemo() : super();

  @override
  CarouselDemoState createState() => CarouselDemoState();
}

class CarouselDemoState extends State<CarouselDemo>
    with SingleTickerProviderStateMixin {
  Widget _body;

  _buildBody() {
    return FutureBuilder(
      future: _getDataFromServer(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var talks = snapshot.data;
          PageIndicatorContainer container = new PageIndicatorContainer(
            child: new PageView(
                children: List.generate(talks.length, (index) {
                  DateTime startdateTime =
                      DateTime.parse(talks[index]['start_date_time']);
                  final starttime = formatDate(
                      startdateTime, [d, ' ', M, ', ', hh, ':', nn, ' ', am]);
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: Stack(
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: talks[index]['image'],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        Positioned(
                          left: 20,
                          bottom: 36,
                          child: Container(
                              width: MediaQuery.of(context).size.width - 20,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 25.0,
                                    spreadRadius: 7.0,
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    talks[index]['name'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            'Venue: ' + talks[index]['venue'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            starttime,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      FlatButton(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.info,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            Text(
                                              ' About Speaker',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  SpeakerDialog(talks[index]));
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  );
                })),
            length: talks.length,
            indicatorSpace: 10,
            indicatorColor: Colors.grey[350],
            indicatorSelectorColor: Colors.blue,
          );
          return Stack(
            children: <Widget>[
              Container(color: Colors.grey[100], height: double.infinity),
              Container(
                color: Colors.transparent,
                child: container,
              )
            ],
          );
        } else if (snapshot.hasError) {
          return FlatButton(
            child: Icon(Icons.replay),
            onPressed: () {
              setState(() {
                _body = _buildBody();
              });
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    _body = _buildBody();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.black, child: _body),
    );
  }

  _getDataFromServer() async {
    final response = await http.get("https://advitiya.in/api/talks/");

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      var jsonData = json.decode(response.body);
      return jsonData;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load data');
    }
  }
}

class SpeakerDialog extends StatelessWidget {
  final detail;
  SpeakerDialog(this.detail);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 16,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      color: Color.fromRGBO(21, 24, 83, 1),
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: 360.0,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Center(
                  child: Text(
                    detail['name'],
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Scrollbar(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            Text(
                              detail['para1'],
                              textAlign: TextAlign.justify,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 12),
                            Text(
                              detail['para2'],
                              textAlign: TextAlign.justify,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 12),
                            Text(
                              detail['para3'],
                              textAlign: TextAlign.justify,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 12),
                            Text(
                              detail['para4'],
                              textAlign: TextAlign.justify,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
