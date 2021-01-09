import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_message/block/authentication_bloc.dart';
import 'package:fly_message/models/AuthenticationResponse.dart';
import 'package:fly_message/screens/main_screen.dart';
import 'package:fly_message/screens/signUp_screen.dart';

class LoginScreen extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  var emailValue;
  var passwordValue;
  var displayedMsg = " ";
  AuthenticationBlock authenticationBlock = AuthenticationBlock();

  @override
  void initState() {
    super.initState();
    authenticationBlock.authenticationLoginStream.listen((state) {
      if (state.authenticationResponseState ==
          AuthenticationResponseState.Success) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    authenticationBlock.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/images/logo.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      textInputAction: TextInputAction.next,
      validator: (value) {
        return emailValidate(value);
      },
      onSaved: (value) {
        emailValue = value;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'type your email',
        hintStyle: TextStyle(
          color: Colors.black,
          fontStyle: FontStyle.italic,
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      validator: (value) {
        return passwordValidate(value);
      },
      onSaved: (value) {
        passwordValue = value;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'type your password',
        hintStyle: TextStyle(
          color: Colors.black,
          fontStyle: FontStyle.italic,
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _logIn();
        },
        padding: EdgeInsets.all(12),
        color: Colors.teal,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final registerLabel = FlatButton(
      child: Text(
        'Register?',
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpScreen()),
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<AuthenticationResponse>(
          stream: authenticationBlock.authenticationLoginStream,
          initialData:
              AuthenticationResponse(AuthenticationResponseState.Intial, ""),
          builder: (context, AsyncSnapshot<AuthenticationResponse> snapshot) {
            return Center(
              child: Stack(alignment: Alignment.center, children: <Widget>[
                Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    children: <Widget>[
                      logo,
                      SizedBox(height: 48.0),
                      email,
                      SizedBox(height: 8.0),
                      password,
                      SizedBox(height: 24.0),
                      loginButton,
                      registerLabel,
                      if (snapshot.data.authenticationResponseState ==
                          AuthenticationResponseState.Failed)
                        Text(
                          "Error............",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      if (snapshot.data.authenticationResponseState ==
                          AuthenticationResponseState.Failed)
                        Text(
                          snapshot.data.msg,
                          style: TextStyle(
                              color: Colors.red, fontStyle: FontStyle.italic),
                        )
                    ],
                  ),
                ),
                if (snapshot.data.authenticationResponseState ==
                    AuthenticationResponseState.loading)
                  Container(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator()),
              ]),
            );
          }),
    );
  }

  void _logIn() {
    bool isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    authenticationBlock.userLogIn(emailValue, passwordValue);
  }

  String emailValidate(String value) {
    if (value.isEmpty) return "type your email ";
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (emailValid) return null;
    return "email is not correct";
  }

  String passwordValidate(String value) {
    if (value.isEmpty) return "type your password";
    if (value.length < 6) return "Enter a correct password";
    return null;
  }
}
