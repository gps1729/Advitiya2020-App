import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Schdule extends StatefulWidget {
  final data;
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
    var jsonData = data;

    List<ChatModel> sampleEvents = [];
    for (var u in jsonData) {
      ChatModel sampleEvent =
          ChatModel(u['name'], u['venue'], u['start_date_time'], u['image']);
      String s = "";
      for (var i = 0; i < 10; i++) {
        s += sampleEvent.dateTime[i];
      }

      if (s == day) {
        sampleEvents.add(sampleEvent);
      }
    }

    return sampleEvents;
  }

  Widget getListViewDay(day) {
    var eventList = _getEventday(day);
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

  Widget getListTile(ChatModel sampleEvent) {
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
                builder: (BuildContext context) => CustomDialog());
          },
        ));

    return listTile;
  }
}

////////////////////////////////data to test
class ChatModel {
  final String name;
  final String venue;
  final String dateTime;
  final String avatarUrl;

  ChatModel(this.name, this.venue, this.dateTime, this.avatarUrl);
}

Widget _buildName({String imageAsset, String name, double score}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      children: <Widget>[
        SizedBox(height: 12),
        Container(height: 2, color: Colors.redAccent),
        SizedBox(height: 12),
        Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(imageAsset),
              radius: 30,
            ),
            SizedBox(width: 12),
            Text(name),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Text("${score}"),
              decoration: BoxDecoration(
                color: Colors.yellow[900],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
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
            height: 400.0,
            width: 360.0,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Leaderboard",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                _buildName(
                    imageAsset: 'Images/appbar.png',
                    name: "Name 1",
                    score: 1000),
                _buildName(
                    imageAsset: 'Images/appbar.png',
                    name: "Name 2",
                    score: 2000),
                _buildName(
                    imageAsset: 'Images/appbar.png',
                    name: "Name 3",
                    score: 3000),
                _buildName(
                    imageAsset: 'Images/appbar.png',
                    name: "Name 6",
                    score: 6000),
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
                  backgroundColor: Colors.black,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
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
