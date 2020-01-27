import 'package:advitiya/model.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class Schdule extends StatefulWidget {
  final List<EventModel> data;
  Schdule(this.data);
  @override
  _SchduleState createState() => _SchduleState();
}

class _SchduleState extends State<Schdule>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  bool showFab = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Colors.pink[900],
            elevation: 0,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(text: "Day 1"),
                Tab(
                  text: "Day 2",
                ),
                Tab(
                  text: "Day 3",
                ),
              ],
            ),
          )),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          DayOne(1, widget.data),
          DayOne(2, widget.data),
          DayOne(3, widget.data),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

////////////////// creating list

class DayOne extends StatefulWidget {
  final data;
  final int page;
  DayOne(this.page, this.data);
  @override
  DayOneState createState() {
    return new DayOneState(page, data);
  }
}

class DayOneState extends State<DayOne> {
  var data;
  int page;
  var _pageOptions;

  DayOneState(int p, dt) {
    data = dt;
    page = p;
    if (page == 1) {
      _pageOptions = getListViewDay('2020-02-07');
    } else if (page == 2) {
      _pageOptions = getListViewDay('2020-02-08');
    } else if (page == 3) {
      _pageOptions = getListViewDay('2020-02-09');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //debugShowCheckedModeBanner: false,
      //theme: ThemeData(primarySwatch: Colors.blue),
      backgroundColor: Colors.white,
      body: _pageOptions,
    );
  }

  _getEventday(day) {
    List<EventModel> sampleEvents = [];
    for (EventModel currentEvent in data) {
      if (currentEvent.dateTime.startsWith(day)) {
        sampleEvents.add(currentEvent);
      }
    }

    return sampleEvents;
  }

  Widget getListViewDay(day) {
    List<EventModel> eventList = _getEventday(day);
    return Container(
      color: Color.fromRGBO(21, 24, 83, 1),
      child: ListView.builder(
        itemCount: eventList.length,
        itemBuilder: (context, i) => new Column(
          children: <Widget>[getListTile(eventList[i])],
        ),
      ),
    );
  }

  Widget getListTile(EventModel sampleEvent) {
    DateTime startdateTime = DateTime.parse(sampleEvent.dateTime);
    final starttime = formatDate(startdateTime, [hh, ':', nn, ' ', am]);
    var listTile = Card(
        color: Colors.white30,
        child: InkWell(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: sampleEvent.avatarUrl,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    foregroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.grey,
                    backgroundImage: imageProvider,
                    radius: 25.0,
                  ),
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          sampleEvent.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                sampleEvent.venue,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Text(
                              starttime,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(sampleEvent));
          },
        ));

    return listTile;
  }
}

////////////////////////////////data to test

class CustomDialog extends StatelessWidget {
  final EventModel detail;
  CustomDialog(this.detail);
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
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 15, left: 10, right: 10),
           
            child: Wrap(
                          children: <Widget> [Column(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: detail.avatarUrl,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      foregroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Colors.grey,
                      backgroundImage: imageProvider,
                      radius: 30.0,
                    ),
                    placeholder: (context, url) => Container(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Text(
                    detail.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Venue : ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text(
                          detail.venue,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Team Lower Limit : ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        detail.teamLowerLimit.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Team Upper Limit : ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        detail.teamUpperLimit.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Fee(in INR) : ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        detail.fee.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Prize(in INR) : ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        (double.parse(detail.prize)).toString() + "K",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Coordinator : ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text(
                          detail.manager['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Contact Details : ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        child: Text(
                          detail.manager['mobile'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          launch('tel:+91 ' + detail.manager['mobile']);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Text("Rulebook"),
                        color: Colors.orangeAccent,
                        onPressed: () {
                          launch(detail.rulebook);
                        },
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        child: Text("Register"),
                        color: Colors.orangeAccent,
                        onPressed: () {
                          launch("https://www.advitiya.in/events/" +
                              detail.id.toString() +
                              "/");
                        },
                      )
                    ],
                  ),
                ],
              ),
                           ] ),
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
        ]
        ,
      ),
    );
  }
}
