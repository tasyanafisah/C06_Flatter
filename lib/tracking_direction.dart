import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';

class TrackingDirectionScreen extends StatefulWidget {
  final WiFiAccessPoint ap;
  const TrackingDirectionScreen({super.key, required this.ap});

  @override
  State<TrackingDirectionScreen> createState() =>
      _TrackingDirectionScreenState();
}

class _TrackingDirectionScreenState extends State<TrackingDirectionScreen> {
  bool _hasPermissions = false;
  int rssiA = 0, rssiB = 0, rssiC = 0, rssiD = 0, rssiE = 0, currentStep = 0;

  @override
  void initState() {
    super.initState();
    _fetchPermissionStatus();
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() {
          _hasPermissions = (status == PermissionStatus.granted);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF95223),
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
      body: Stack(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 64),
                const Text(
                  'Lacak',
                  style: TextStyle(
                      fontSize: 32.0,
                      color: Color(0xFFF95223),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12.0),
                Builder(builder: (context) {
                  if (_hasPermissions) {
                    return _buildCompass();
                  } else {
                    return _buildPermissionSheet();
                  }
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Text(
                              'SSID:',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              widget.ap.ssid,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Text(
                              'Kekuatan Sinyal:',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              widget.ap.level.toString(),
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
              top: 16.0,
              left: 16.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset("assets/images/backinscan.png",
                    width: 40, height: 40),
              )),
        ],
      ),
    );
  }

  //Widget Compass
  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error membaca heading kompas: ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          double? direction = snapshot.data!.heading;

          if (direction == null) {
            return const Center(
              child: Text('Perangkat tidak memiliki sensor'),
            );
          }

          return Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: Transform.rotate(
                angle: direction * (pi / 180) * -1,
                child: Image.asset(
                  'assets/images/compass.png',
                ),
              ),
            ),
          );
        });
  }

  //Widget Permissions
  Widget _buildPermissionSheet() {
    return Center(
      child: ElevatedButton(
        child: const Text('Request Permission'),
        onPressed: () {
          Permission.locationWhenInUse.request().then((value) {
            _fetchPermissionStatus();
          });
        },
      ),
    );
  }
}
