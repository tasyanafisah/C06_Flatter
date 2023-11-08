import 'package:flutter/material.dart';

class ScanScreen extends StatelessWidget {
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
}
