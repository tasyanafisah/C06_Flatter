import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:flutter/foundation.dart';
import 'package:wifi_connector/wifi_connector.dart';

import 'package:capstone_safeguard_flutter/tracking_direction.dart';
import 'package:capstone_safeguard_flutter/controller/track_screen_controller.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  TrackScreenController trackScreenController = TrackScreenController();
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  var _isSuccessConnect = false;

  @override
  void initState() {
    super.initState();
    _startListeningToScanResults(context);
  }

  @override
  void dispose() {
    _stopListeningToScanResults();
    super.dispose();
  }

  bool shouldCheckCan = true;
  bool get isStreaming => subscription != null;

  final String _currSsid = '';
  final String _currPassword = '2JER4B4J9MN';

  Future<bool> _canGetScannedResults(BuildContext context) async {
    if (shouldCheckCan) {
      final can = await WiFiScan.instance.canGetScannedResults();
      if (can != CanGetScannedResults.yes) {
        if (mounted) kShowSnackBar(context, "Cannot get scanned results: $can");
        accessPoints = <WiFiAccessPoint>[];
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
            accessPoints = result;
            trackScreenController.updateAccessPoints(result);
            print(trackScreenController.accessPoints);
          });
        },
        onDone: () {},
        onError: (error) {
          if (mounted) kShowSnackBar(context, "Scan stream error: $error");
        },
      );
    }
  }

  Future<void> _onConnectPressed() async {
    final ssid = _currSsid;
    final password = _currPassword;
    print("Starting Connection $ssid with $password");
    setState(() => _isSuccessConnect = false);
    final isSucceed =
        await WifiConnector.connectToWifi(ssid: ssid, password: password);
    setState(() => _isSuccessConnect = isSucceed);
    print(_isSuccessConnect);
  }

  void _stopListeningToScanResults() {
    subscription?.cancel();
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
                  'Alat yang',
                  style: TextStyle(
                      fontSize: 32.0,
                      color: Color(0xFFF95223),
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Terdeteksi',
                  style: TextStyle(
                      fontSize: 32.0,
                      color: Color(0xFFF95223),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24.0),
                Expanded(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF95223),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 18.0),
                      padding: const EdgeInsets.all(18.0),
                      child: accessPoints.isEmpty
                          ? const Text(
                              "Tidak ada hasil scan Wi-Fi",
                              style: TextStyle(color: Colors.white),
                            )
                          : ListView.builder(
                              itemCount: accessPoints.length,
                              itemBuilder: (context, i) => _AccessPointTile(
                                accessPoint: accessPoints[i],
                                // onLacakPressed: () {
                                //   setState(() => _currSsid =
                                //       accessPoints[i].ssid.toString());
                                //   _onConnectPressed();
                                //
                                onLacakPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TrackingDirectionScreen(
                                        trackScreenController:
                                            trackScreenController,
                                        index: i,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
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
}

void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

String getDistance(int rssi) {
  double distance;
  distance = pow(10, ((-44 - rssi) / (10 * 2.99))).toDouble();
  return distance.toStringAsFixed(1);
}

class _AccessPointTile extends StatelessWidget {
  final WiFiAccessPoint accessPoint;
  final Function onLacakPressed;

  const _AccessPointTile(
      {Key? key, required this.accessPoint, required this.onLacakPressed})
      : super(key: key);

  Widget _buildInfo(String label, dynamic value) => Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: Text(value.toString()))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final title = accessPoint.ssid.isNotEmpty ? accessPoint.ssid : "**EMPTY**";

    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1C4C74),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6.0),
                      bottomLeft: Radius.circular(6.0),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 20.0),
                  child: Column(
                    children: [
                      Text(
                        getDistance(accessPoint.level),
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2.0),
                      const Text("Meter",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          "SSID:",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.0), // Text color
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600), // Text color
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          "Kekuatan Sinyal:",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.0), // Text color
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          "${accessPoint.level.toString()}db",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600), // Text color
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
                right: 8.0,
                bottom: 22,
                child: GestureDetector(
                  onTap: () {
                    onLacakPressed();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Material(
                        elevation: 2.0, // Set the elevation value
                        shadowColor: Colors.white, // Set the shadow color
                        borderRadius: BorderRadius.circular(6.0),
                        child: Container(
                          width: 56.0,
                          height: 56.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF95223),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: const Center(
                            child: Text(
                              "Lacak",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ));
  }
}
