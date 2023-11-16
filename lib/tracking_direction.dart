import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:capstone_safeguard_flutter/controller/track_screen_controller.dart';

class TrackingDirectionScreen extends StatefulWidget {
  final TrackScreenController trackScreenController;
  final int index;

  const TrackingDirectionScreen(
      {super.key, required this.trackScreenController, required this.index});

  @override
  State<TrackingDirectionScreen> createState() =>
      _TrackingDirectionScreenState();
}

class _TrackingDirectionScreenState extends State<TrackingDirectionScreen> {
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool _hasPermissions = false;
  int rssiA = 0, rssiB = 0, rssiC = 0, rssiD = 0, rssiE = 0, currentStep = 0;

  String _resultDirection = "";
  final Map<String, String> compassImages = {
    'Titik tengah': 'assets/images/kompas_center.png',
    'Barat Laut': 'assets/images/kompas_nw.png',
    'Timur Laut': 'assets/images/kompas_ne.png',
    'Tenggara': 'assets/images/kompas_se.png',
    'Barat Daya': 'assets/images/kompas_sw.png',
  };

  final Map<String, String> teksGerakJalan = {
    'Titik tengah': 'Anda sudah berada dekat dengan korban',
    'Barat Laut': 'Bergeraklah menuju Barat Laut (NW)',
    'Timur Laut': 'Bergeraklah menuju Timur Laur (NE)',
    'Tenggara': 'Bergeraklah menuju Tenggara (SE)',
    'Barat Daya': 'Bergeraklah menuju Barat Daya (SW)',
  };

  @override
  void initState() {
    super.initState();
    _fetchPermissionStatus();

    _startListeningToScanResults(context);

    print(
      "Curr AP: ${widget.trackScreenController.accessPoints[widget.index].ssid}",
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

  bool shouldCheckCan = true;

  Future<bool> _canGetScannedResults(BuildContext context) async {
    if (shouldCheckCan) {
      final can = await WiFiScan.instance.canGetScannedResults();
      if (can != CanGetScannedResults.yes) {
        if (mounted) kShowSnackBar(context, "Cannot get scanned results: $can");
        return false;
      }
    }
    return true;
  }

  Future<void> _startListeningToScanResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      subscription = WiFiScan.instance.onScannedResultsAvailable.listen(
        (result) {
          setState(() {
            widget.trackScreenController.updateAccessPoints(result);
            print(widget.trackScreenController.accessPoints);
          });
        },
        onDone: () {},
        onError: (error) {
          if (mounted) kShowSnackBar(context, "Scan stream error: $error");
        },
      );
    }
  }

  Future<void> connectToWifi(String ssid, String password) async {
    try {
      await WiFiForIoTPlugin.connect(ssid,
          password: password, security: NetworkSecurity.WPA);
      await Future.delayed(Duration(seconds: 10));

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.wifi) {
        print('Connected to Wi-Fi: $ssid');
      } else {
        print('Failed to connect to Wi-Fi: $ssid');
      }
    } catch (e) {
      print('Error connecting to Wi-Fi: $e');
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  String _teksPerintah() {
    switch (currentStep) {
      case 0:
        return 'Klik untuk pilih titik ini sebagai titik awal pencarian';
      case 1:
        return 'Jalan 3.5 meter ke Barat Daya (NW), lalu klik';
      case 2:
        return 'Jalan 3.5 meter ke Timur (E), lalu klik';
      case 3:
        return 'Jalan 3.5 meter ke Selatan (S), lalu klik';
      case 4:
        return 'Jalan 3.5 meter ke Barat (W), lalu klik';
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
                const SizedBox(height: 42),
                const Text(
                  'Lacak',
                  style: TextStyle(
                      fontSize: 32.0,
                      color: Color(0xFFF95223),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white70,
                    foregroundColor: const Color(0xFFF95223),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Sambungkan dengan Wi-Fi"),
                        content: Text(
                            "Sambungkan dengan Wi-Fi SSID ${widget.trackScreenController.accessPoints[widget.index].ssid} dan password 12345678"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              AppSettings.openAppSettings(
                                  type: AppSettingsType.wifi);
                            },
                            child: const Text('Oke!'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Dengarkan suara'),
                ),
                Builder(builder: (context) {
                  if (_hasPermissions) {
                    return _buildCompass();
                  } else {
                    return _buildPermissionSheet();
                  }
                }),
                Text(
                  teksGerakJalan[_resultDirection] ?? '',
                  style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
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
                              widget
                                      .trackScreenController
                                      .accessPoints[widget.index]
                                      .ssid
                                      .isNotEmpty
                                  ? widget.trackScreenController
                                      .accessPoints[widget.index].ssid
                                  : "Tidak ada SSID",
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
                              widget.trackScreenController
                                  .accessPoints[widget.index].level
                                  .toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  _teksPerintah(),
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                if (currentStep == 0)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF95223),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      setState(() {
                        rssiA = widget.trackScreenController
                                .accessPoints[widget.index].level ??
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
                      backgroundColor: const Color(0xFFF95223),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      setState(() {
                        rssiB = widget.trackScreenController
                                .accessPoints[widget.index].level ??
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
                      backgroundColor: const Color(0xFFF95223),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      // TODO: Ask the user to walk 3.5 meters to east
                      // and save the RSSI value to rssiC
                      setState(() {
                        rssiC = widget.trackScreenController
                                .accessPoints[widget.index].level ??
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
                      backgroundColor: const Color(0xFFF95223),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      // TODO: Ask the user to walk 3.5 meters to south
                      // and save the RSSI value to rssiD
                      setState(() {
                        rssiD = widget.trackScreenController
                                .accessPoints[widget.index].level ??
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
                      backgroundColor: const Color(0xFFF95223),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      // TODO: Ask the user to walk 3.5 meters to west
                      // and save the RSSI value to rssiE
                      setState(() {
                        rssiE = widget.trackScreenController
                                .accessPoints[widget.index].level ??
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
                      backgroundColor: const Color(0xFFF95223),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      print("End reached");

                      List<Map<String, dynamic>> rssiList = [
                        {'direction': 'Titik tengah', 'rssi': rssiA},
                        {'direction': 'Barat Laut', 'rssi': rssiB},
                        {'direction': 'Timur Laut', 'rssi': rssiC},
                        {'direction': 'Tenggara', 'rssi': rssiD},
                        {'direction': 'Barat Daya', 'rssi': rssiE},
                      ];

                      rssiList.sort((a, b) => b['rssi'].compareTo(a['rssi']));

                      String maxRssiDirection = rssiList.isNotEmpty
                          ? rssiList.first['direction']
                          : '';

                      setState(() {
                        _resultDirection = maxRssiDirection;
                        print(_resultDirection);
                        rssiA = 0;
                        rssiB = 0;
                        rssiC = 0;
                        rssiD = 0;
                        rssiE = 0;
                        currentStep = 0;
                      });

                      print(
                          'Maximum RSSI is in the direction: $maxRssiDirection');
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

          String compassImagePath =
              compassImages[_resultDirection] ?? 'assets/images/compass.png';

          return Center(
            child: Container(
              padding: const EdgeInsets.all(25),
              child: Transform.rotate(
                angle: direction * (pi / 180) * -1,
                child: Image.asset(compassImagePath, width: 300, height: 300),
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

void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
