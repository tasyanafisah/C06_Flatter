import 'package:flutter/material.dart';

class TrackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFF95223),
        title: const Text(
          'Safeguard',
          style: TextStyle(
              fontFamily: 'Moonhouse', fontSize: 22, color: Colors.white),
        ),
        actions: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Text(
                  "SEEKER",
                  style: TextStyle(
                    fontFamily: 'Moonhouse',
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.wifi,
              size: 100.0,
              color: Colors.green,
            ),
            SizedBox(height: 20.0),
            Text(
              'Tracking Wi-Fi Networks',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
