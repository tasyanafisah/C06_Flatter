import 'package:flutter/material.dart';
import 'package:capstone_safeguard_flutter/components/buttonbig.dart';
import 'package:capstone_safeguard_flutter/scan.dart';
import 'package:capstone_safeguard_flutter/track.dart';
// import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
// import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Safeguard',
      home: LandingScreen(),
    );
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF95223),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 16.0,
            child: Image.asset("assets/images/safeguard.png", width: 100),
          ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "SEEKER",
                  style: TextStyle(
                      fontFamily: 'Moonhouse',
                      fontSize: 40,
                      color: Colors.white),
                ),
                SizedBox(height: 60),
                ButtonBig(
                    text: 'Pindai Kode QR',
                    imgUrl: 'assets/images/pindaiqr.png',
                    goTo: ScanScreen()),
                SizedBox(height: 60),
                ButtonBig(
                    text: 'Lacak Korban',
                    imgUrl: 'assets/images/lacak.png',
                    goTo: TrackScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
