import 'package:flutter/material.dart';
import 'package:fly_message/block/authentication_bloc.dart';
import 'package:fly_message/widgets/splash_widget.dart';
import 'logIn_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthenticationBlock authenticationBlock = AuthenticationBlock();

  @override
  void initState() {
    super.initState();
    authenticationBlock.isUserLogged();
    authenticationBlock.authenticationCheckStream.listen((state) {
      if (state == 1) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
      } else if (state == 0) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen()));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    authenticationBlock.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SplashWidget();
  }
}
