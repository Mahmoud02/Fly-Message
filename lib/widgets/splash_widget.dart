import 'package:flutter/material.dart';

class SplashWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = 70;
    double width = 70;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Spacer(),
              Image.asset(
                "assets/images/logo.png",
                height: height,
                width: width,
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  text: "Hi",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  children: [
                    TextSpan(text: "Ready"),
                    TextSpan(
                        text: " to make your Messages",
                       ),
                    TextSpan(
                        text: " Fly",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}