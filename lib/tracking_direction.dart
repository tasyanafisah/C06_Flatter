import 'dart:math';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:capstone_safeguard_flutter/controller/track_screen_controller.dart';

class TrackingDirectionScreen extends StatefulWidget {
  final TrackScreenController trackScreenController;

  const TrackingDirectionScreen({
    super.key,
    required this.trackScreenController,
  });

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

    List<WiFiAccessPoint> accessPoints =
        widget.trackScreenController.accessPoints;
    if (accessPoints.isNotEmpty) {
      print(accessPoints);
    }

    print(
      "Curr AP: ${widget.trackScreenController.currAp}",
    );
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

  String _teksPerintah() {
    switch (currentStep) {
      case 0:
        return 'Klik untuk pilih titik ini sebagai titik awal pencarian';
      case 1:
        return 'Jalan 3.5 meter ke Barat Daya, lalu klik';
      case 2:
        return 'Jalan 3.5 meter ke Timur, lalu klik';
      case 3:
        return 'Jalan 3.5 meter ke Selatan, lalu klik';
      case 4:
        return 'Jalan 3.5 meter ke Barat, lalu klik';
      case 5:
        return 'Kembali ke titik awal pencarian, lalu klik';
      default:
        return 'Klik untuk pilih titik ini sebagai titik awal pencarian';
    }
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            const Text(
                              'SSID:',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              widget.trackScreenController.currAp.value?.ssid ??
                                  'No Access Point',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            const Text(
                              'Kekuatan Sinyal:',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              widget.trackScreenController.currAp.value?.level
                                      .toString() ??
                                  'No Signal Strength',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  _teksPerintah(),
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                if (currentStep == 0)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF95223),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      setState(() {
                        rssiA =
                            widget.trackScreenController.currAp.value?.level ??
                                0;
                        currentStep = 1;
                      });
                      print(rssiA);
                    },
                    child: const Text('Set lokasi awal'),
                  ),
                if (currentStep == 1)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF95223),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      setState(() {
                        rssiB =
                            widget.trackScreenController.currAp.value?.level ??
                                0;
                        currentStep = 2;
                      });
                      print(rssiB);
                    },
                    child: const Text('Set lokasi kedua'),
                  ),
                if (currentStep == 2)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF95223),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      // TODO: Ask the user to walk 3.5 meters to east
                      // and save the RSSI value to rssiC
                      setState(() {
                        rssiC =
                            widget.trackScreenController.currAp.value?.level ??
                                0;
                        currentStep = 3;
                      });

                      print(rssiC);
                    },
                    child: const Text('Set lokasi ketiga'),
                  ),
                if (currentStep == 3)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF95223),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      // TODO: Ask the user to walk 3.5 meters to south
                      // and save the RSSI value to rssiD
                      setState(() {
                        rssiD =
                            widget.trackScreenController.currAp.value?.level ??
                                0;
                        currentStep = 4;
                      });

                      print(rssiD);
                    },
                    child: const Text('Set lokasi keempat'),
                  ),
                if (currentStep == 4)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF95223),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      // TODO: Ask the user to walk 3.5 meters to west
                      // and save the RSSI value to rssiE
                      setState(() {
                        rssiE =
                            widget.trackScreenController.currAp.value?.level ??
                                0;
                        currentStep = 5;
                      });

                      print(rssiE);
                    },
                    child: const Text('Set lokasi kelima'),
                  ),
                if (currentStep == 5)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF95223),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      print("End reached");
                      print("End reached");

                      // Create a list of Map entries with direction and corresponding RSSI values
                      List<Map<String, dynamic>> rssiList = [
                        {'direction': 'Titik tengah', 'rssi': rssiA},
                        {'direction': 'Barat Laut', 'rssi': rssiB},
                        {'direction': 'Timur Laut', 'rssi': rssiC},
                        {'direction': 'Tenggara', 'rssi': rssiD},
                        {'direction': 'Barat Daya', 'rssi': rssiE},
                      ];

                      // Sort the list based on RSSI values in descending order
                      rssiList.sort((a, b) => b['rssi'].compareTo(a['rssi']));

                      // Get the direction with the maximum RSSI
                      String maxRssiDirection = rssiList.isNotEmpty
                          ? rssiList.first['direction']
                          : '';

                      // Print or use the direction with the maximum RSSI
                      print('Maximum RSSI Direction: $maxRssiDirection');
                    },
                    child: const Text('Hitung estimasi arah'),
                  ),
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
              padding: const EdgeInsets.all(25),
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
