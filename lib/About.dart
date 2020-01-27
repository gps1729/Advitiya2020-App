import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16,16,16,0),
            child: Center(
              child: Text(
                'About Us',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Card(
              color: Colors.black87,
              child: Container(
                color: Colors.black12,
                padding: EdgeInsets.all(16),
                child: Text(
                  "IIT Ropar is organizing the fourth edition of it's annual "
                  "Science & Technology Festival Advitiya in the first week of February, "
                  "consisting of 72 hours of exhilarating competitions and technical events."
                  "Advitiya has already evolved into a brand within four years of its inception. "
                  "In the previous edition, we managed to record a footfall of 15k+ and hosted over "
                  "30 events. Advitiya, in its past few editions, not only has created a buzz in the "
                  "minds of Techno-enthusiasts but has also provided its partners and sponsors a "
                  "platform for their publicity. With an array of activities that consolidate the "
                  "vision for times to come, Advitiya 2020 is ready to set the scientific spirits "
                  "soaring and technological temper ablaze. This year’s edition will carry forward "
                  "the tradition set by the previous ones and will encompass a wide range of "
                  "scientific and technical activities from fields like Coding, Aeromodelling, "
                  "Robotics, Finance, Design and Entrepreneurship with exciting prizes worth over 9 "
                  "lakh Rupees.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontStyle: FontStyle.italic),
                ),
              )),
        ],
      ),
    );
  }
}
