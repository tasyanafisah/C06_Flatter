import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanScreen extends StatefulWidget {
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller!.resumeCamera();
  //   }
  // }

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
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .55,
                  color: Colors.amber,
                  child: QRView(key: qrKey, onQRViewCreated: onQRviewCamera),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      SizedBox(height: 4.0),
                      const Text(
                        "Instruksi",
                        style: TextStyle(
                          fontFamily: 'Moonhouse',
                          fontSize: 22,
                          color: Color(0xFFF95223),
                        ),
                      ),
                      Container(
                          child: Center(
                        child: (result != null)
                            ? Text('Data: ${result!.code}')
                            : Text('Scan a QR'),
                      )),
                      SizedBox(height: 24.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/angka1.png",
                                      width: 25, height: 25),
                                  SizedBox(height: 8.0),
                                  Image.asset("assets/images/gbr1.png",
                                      width: 65, height: 65),
                                  SizedBox(height: 8.0),
                                  const Text(
                                    'Pindai Kode QR',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0xFFF95223),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/angka2.png",
                                      width: 25, height: 25),
                                  SizedBox(height: 8.0),
                                  Image.asset("assets/images/gbr2.png",
                                      width: 65, height: 65),
                                  SizedBox(height: 8.0),
                                  const Text(
                                    'Menuju ke \nlokasi dengan \nbantuan \nGoogle Maps',
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0xFFF95223),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/angka3.png",
                                      width: 25, height: 25),
                                  SizedBox(height: 8.0),
                                  Image.asset("assets/images/gbr3.png",
                                      width: 65, height: 65),
                                  SizedBox(height: 8.0),
                                  const Text(
                                    'Lacak Korban',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0xFFF95223),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ])
                    ],
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

  void onQRviewCamera(QRViewController p1) {
    this.controller = p1;
    controller?.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}