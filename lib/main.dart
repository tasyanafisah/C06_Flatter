import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Capstone C06'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    scanForDevices();
  }

  void scanForDevices() {
    print("Start scan");
    try {
      flutterBlue.startScan(timeout: Duration(seconds: 4));
      // flutterBlue.scanResults.listen((List<ScanResult> results) {
      //   print("Get scan: $results");
      //   for (ScanResult result in results) {
      //     if (!devices.contains(result.device)) {
      //       setState(() {
      //         devices.add(result.device);
      //       });
      //     }
      //   }
      // });
      var subscription = flutterBlue.scanResults.listen((results) {
        print("results: $results");
        for (ScanResult r in results) {
          print("result: $r");
          if (!devices.contains(r)) {
            setState(() {
              devices.add(r.device);
            });
          }
        }
      });
      flutterBlue.stopScan();
      print("stop scanning");
    } catch (e) {
      print("Error starting scan: $e");
    }
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return ListTile(
            title: Text(device.name),
            subtitle: Text(device.id.toString()),
            onTap: () {
              // Handle device selection
            },
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: FloatingActionButton(
          onPressed: () {
            devices.clear();
            scanForDevices();
          },
          tooltip: 'Scan',
          child: Icon(Icons.bluetooth),
        ),
      ),
    );
  }
}
