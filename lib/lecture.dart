import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';

class CarouselDemo extends StatefulWidget {
  CarouselDemo() : super();

  @override
  CarouselDemoState createState() => CarouselDemoState();
}

class CarouselDemoState extends State<CarouselDemo>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  Widget _body;
  void _animateSlider(length) {
    Future.delayed(Duration(seconds: 5)).then((_) {
      int nextPage = _controller.page.round() + 1;
     
      if (nextPage == length) {
        nextPage = 0;
      }

      _controller
          .animateToPage(nextPage,
              duration: Duration(seconds: 1), curve: Curves.linear)
          .then((_) => _animateSlider(length));
    });
  }

  _buildBody() {
    return FutureBuilder(
      future: _getDataFromServer(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var talks = snapshot.data;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _animateSlider(talks.length));
          PageIndicatorContainer container = new PageIndicatorContainer(
            child: new PageView(
                controller: _controller,
                children: List.generate(talks.length, (index) {
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
                        Container(
                            child: Column(
                          children: <Widget>[
                            Text(
                              talks[index]['name'],
                              style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal),
                            ),
                             Text(
                              talks[index]['venue'],
                              style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal),
                            ),
                            Text(
                              talks[index]['start_date_time'],
                              style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal),
                            )
                          ],
                        ))
                      ],
                    ),
                  );
                })),
            length: talks.length,
            indicatorSpace: 10,
            indicatorColor: Colors.grey[350],
            indicatorSelectorColor: Colors.grey,
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
  void dispose() {
    _controller.dispose();
    super.dispose();
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
