import 'package:flutter/material.dart';
import 'package:fly_message/block/authentication_bloc.dart';
import 'package:fly_message/models/AuthenticationResponse.dart';
import 'package:fly_message/screens/main_screen.dart';

class SignUpScreen extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _SignUpScreenState createState() => new _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  final _rePasswordFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  var emailValue;
  var passwordValue;
  var rePasswordValue;
  AuthenticationBlock authenticationBlock = AuthenticationBlock();
  @override
  void dispose() {
    super.dispose();
    _passwordFocusNode.dispose();
  }
  @override
  void initState() {
    super.initState();
    authenticationBlock.authenticationRegisterStream.listen((state) {
      if (state.authenticationResponseState ==
          AuthenticationResponseState.Success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MainScreen(),
          ),
              (route) => false,
        );
      }
    });
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
      textInputAction: TextInputAction.next,
      controller: _passwordController,
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
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_rePasswordFocusNode);
      },
    );
    final rePassword = TextFormField(
      autofocus: false,
      obscureText: true,
      focusNode: _rePasswordFocusNode,
      textInputAction: TextInputAction.done,
      validator: (value) {
        return rePasswordValidate(value);
      },
      onSaved: (value) {
        rePasswordValue = value;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'type your password again',
        hintStyle: TextStyle(
          color: Colors.black,
          fontStyle: FontStyle.italic,
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          __register();
        },
        padding: EdgeInsets.all(12),
        color: Colors.teal,
        child: Text('Register', style: TextStyle(color: Colors.white)),
      ),
    );

    final loginLabel = FlatButton(
        child: Text(
          'logIn?',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.pop(context);
        });

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<AuthenticationResponse>(
          stream: authenticationBlock.authenticationRegisterStream,
          initialData:
              AuthenticationResponse(AuthenticationResponseState.Intial, ""),
          builder: (context, snapshot) {
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
                      SizedBox(height: 8.0),
                      rePassword,
                      SizedBox(height: 24.0),
                      registerButton,
                      loginLabel,
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
                        ),
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

  void __register() {
    bool isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    authenticationBlock.userRegister(emailValue, passwordValue);
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

  String rePasswordValidate(String value) {
    print("value is" + _passwordController.text);
    if (value.isEmpty) return "type your password";
    if (value != _passwordController.text) return "password doesn't matches";
    return null;
  }

}
