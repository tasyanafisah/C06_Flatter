import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:flutter/foundation.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;

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

  // Future<void> _startScan(BuildContext context) async {
  //   if (shouldCheckCan) {
  //     final can = await WiFiScan.instance.canStartScan();
  //     if (can != CanStartScan.yes) {
  //       if (mounted) kShowSnackBar(context, "Cannot start scan: $can");
  //       return;
  //     }
  //   }

  //   final result = await WiFiScan.instance.startScan();
  //   if (mounted) kShowSnackBar(context, "startScan: $result");
  //   setState(() => accessPoints = <WiFiAccessPoint>[]);
  // }

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

  // Future<void> _getScannedResults(BuildContext context) async {
  //   if (await _canGetScannedResults(context)) {
  //     final results = await WiFiScan.instance.getScannedResults();
  //     setState(() => accessPoints = results);
  //   }
  // }

  Future<void> _startListeningToScanResults(BuildContext context) async {
    print("Scanning");
    if (await _canGetScannedResults(context)) {
      subscription = WiFiScan.instance.onScannedResultsAvailable.listen(
        (result) {
          setState(() {
            accessPoints = result;
          });
          print("Scan Stream Result: $result");
        },
        onDone: () {
          print("Scan Stream Done");
        },
        onError: (error) {
          print("Scan Stream Error: $error");
        },
      );
    }
  }

  void _stopListeningToScanResults() {
    // if (mounted) {
    //   setState(() => subscription = null);
    // }
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
                SizedBox(height: 64),
                Text(
                  'Alat yang',
                  style: TextStyle(
                      fontSize: 32.0,
                      color: Color(0xFFF95223),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Terdeteksi',
                  style: TextStyle(
                      fontSize: 32.0,
                      color: Color(0xFFF95223),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24.0),
                Expanded(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF95223),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 24.0),
                      padding: EdgeInsets.all(24.0),
                      child: accessPoints.isEmpty
                          ? const Text(
                              "Tidak ada hasil scan Wi-Fi",
                              style: TextStyle(color: Colors.white),
                            )
                          : ListView.builder(
                              itemCount: accessPoints.length,
                              itemBuilder: (context, i) => _AccessPointTile(
                                  accessPoint: accessPoints[i])),
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
  distance = pow(10, ((-44 - rssi) / (10 * 2.7))).toDouble();
  return distance.toStringAsFixed(1);
}

class _AccessPointTile extends StatelessWidget {
  final WiFiAccessPoint accessPoint;

  const _AccessPointTile({Key? key, required this.accessPoint})
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
    final signalIcon = accessPoint.level >= -80
        ? Icons.signal_wifi_4_bar
        : Icons.signal_wifi_0_bar;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Color(0xFF1C4C74),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6.0),
                bottomLeft: Radius.circular(6.0),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 20.0),
            child: Column(
              children: [
                Text(
                  getDistance(accessPoint.level),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2.0),
                Text("Meter",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(left: 8.0),
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    "SSID:",
                    style: TextStyle(
                        color: Colors.white, fontSize: 11.0), // Text color
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600), // Text color
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    "Kekuatan Sinyal:",
                    style: TextStyle(
                        color: Colors.white, fontSize: 11.0), // Text color
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    "${accessPoint.level.toString()}db",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600), // Text color
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 6.0),
            child: Flex(
              direction: Axis.horizontal,
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
                      color: Color(0xFFF95223),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Center(
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
          ),
        ],
      ),
    );
    // return ListTile(
    //   leading: Icon(signalIcon),
    //   title: Text(title),
    //   subtitle: Text(accessPoint.capabilities),
    //   onTap: () => showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: Text(title),
    //       content: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           _buildInfo("BSSDI", accessPoint.bssid),
    //           _buildInfo("Capability", accessPoint.capabilities),
    //           _buildInfo("frequency", "${accessPoint.frequency}MHz"),
    //           _buildInfo("level", accessPoint.level),
    //           _buildInfo("standard", accessPoint.standard),
    //           _buildInfo(
    //               "centerFrequency0", "${accessPoint.centerFrequency0}MHz"),
    //           _buildInfo(
    //               "centerFrequency1", "${accessPoint.centerFrequency1}MHz"),
    //           _buildInfo("channelWidth", accessPoint.channelWidth),
    //           _buildInfo("isPasspoint", accessPoint.isPasspoint),
    //           _buildInfo(
    //               "operatorFriendlyName", accessPoint.operatorFriendlyName),
    //           _buildInfo("venueName", accessPoint.venueName),
    //           _buildInfo("is80211mcResponder", accessPoint.is80211mcResponder),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
