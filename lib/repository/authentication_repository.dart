import 'package:fly_message/database/firebase_manager.dart';
import 'package:fly_message/models/AuthenticationResponse.dart';

class AuthenticationRepository {
  FirebaseManager firebaseManager = FirebaseManager();

  Future<AuthenticationResponse> userLogIn(String emailValue, String passwordValue) async {
    return await firebaseManager.userLogIn(emailValue, passwordValue);
  }

  Future<AuthenticationResponse> userRegister(String emailValue, String passwordValue) async {
    return await firebaseManager.userRegister(emailValue, passwordValue);
  }

  Future<int> isUserLogged() async {
    return await firebaseManager.isUserLogged();
  }
}
