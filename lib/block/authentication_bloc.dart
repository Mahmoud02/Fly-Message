import 'dart:async';
import 'package:fly_message/models/AuthenticationResponse.dart';
import 'package:fly_message/repository/authentication_repository.dart';
import 'package:rxdart/rxdart.dart';

enum AuthenticationActions { signIn, register }

class AuthenticationBlock {
  final _authenticationLoginController = BehaviorSubject<AuthenticationResponse>();

  final _authenticationRegisterController = BehaviorSubject<AuthenticationResponse>();

  final _authenticationCheckController = StreamController<int>();

  BehaviorSubject<AuthenticationResponse> get authenticationLoginStream =>
      _authenticationLoginController.stream;

  BehaviorSubject<AuthenticationResponse> get authenticationRegisterStream =>
      _authenticationRegisterController.stream;

  Stream<int> get authenticationCheckStream =>
      _authenticationCheckController.stream;

  AuthenticationRepository _authenticationRepository =
  AuthenticationRepository();

  AuthenticationBlock();

  void userLogIn(String emailValue, String passwordValue) async {
    _authenticationLoginController.sink.add(
        AuthenticationResponse(AuthenticationResponseState.loading, "wait"));

    AuthenticationResponse authenticationResponse;

    var result = await _authenticationRepository.userLogIn(emailValue.trim(), passwordValue);
    authenticationResponse = AuthenticationResponse(result.authenticationResponseState, result.msg);

    _authenticationLoginController.sink.add(authenticationResponse);
  }

  void userRegister(String emailValue, String passwordValue) async {
    _authenticationRegisterController.sink.add(
        AuthenticationResponse(AuthenticationResponseState.loading, "wait"));
    AuthenticationResponse authenticationResponse;

    var result = await _authenticationRepository.userRegister(emailValue.trim(), passwordValue);

    authenticationResponse = AuthenticationResponse(result.authenticationResponseState, result.msg);
    _authenticationRegisterController.sink.add(authenticationResponse);
  }

  void isUserLogged() async {
    int result =  await _authenticationRepository.isUserLogged();
    _authenticationCheckController.sink.add(result);
  }

  void dispose() {
    _authenticationCheckController.close();
    _authenticationLoginController.close();
    _authenticationRegisterController.close();
  }
}
