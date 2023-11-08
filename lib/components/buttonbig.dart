import 'package:flutter/material.dart';

class ButtonBig extends StatelessWidget {
  final String text;
  final String imgUrl;
  final Widget goTo;

  ButtonBig({required this.text, required this.imgUrl, required this.goTo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => goTo),
        );
      },
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(imgUrl, width: 80, height: 80),
            const SizedBox(height: 20),
            Text(
              text,
              style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFF95223),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
