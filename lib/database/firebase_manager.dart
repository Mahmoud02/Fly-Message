import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fly_message/models/AuthenticationResponse.dart';
import 'package:fly_message/models/MessagesResponse.dart';
import 'package:fly_message/models/message_model.dart';

class FirebaseManager {
  final fireStoreInstance = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  FirebaseManager();

  Future<AuthenticationResponse> userLogIn(String emailValue, String passwordValue) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: emailValue, password: passwordValue);
      AuthenticationResponse authenticationResponse =
          AuthenticationResponse(AuthenticationResponseState.Success, "");
      return authenticationResponse;
    } on PlatformException catch (err) {
      AuthenticationResponse authenticationResponse = AuthenticationResponse(
          AuthenticationResponseState.Failed, err.message);
      return authenticationResponse;
    } catch (err) {
      AuthenticationResponse authenticationResponse = AuthenticationResponse(
          AuthenticationResponseState.Failed, err.message);
      return authenticationResponse;
    }
  }

  Future<AuthenticationResponse> userRegister(String emailValue, String passwordValue) async {
    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: emailValue,
          password: passwordValue);

      setUserData(userCredential);
      AuthenticationResponse authenticationResponse =
          AuthenticationResponse(AuthenticationResponseState.Success, "");
      return authenticationResponse;

    } on PlatformException catch (err) {
      AuthenticationResponse authenticationResponse = AuthenticationResponse(
          AuthenticationResponseState.Failed, err.message);
      return authenticationResponse;

    } catch (err) {
      AuthenticationResponse authenticationResponse = AuthenticationResponse(
          AuthenticationResponseState.Failed, err.message);
      return authenticationResponse;
    }
  }

  void setUserData(UserCredential userCredential) async {
    await fireStoreInstance
        .collection("Users")
        .doc(userCredential.user.uid)
        .set({
      "username": " ",
      "profilePicLink": " ",
    });
  }


  Future<MessagesResponseResponseState> flyMessageToOtherUsers(String msg) async {
    var userId = firebaseAuth.currentUser.uid;
    try {
      await fireStoreInstance.collection("messages").add({
        'documentId': " ",
        'message': msg, // Stokes and Sons
        'numOfLike': 0,
        "userId": userId,
      }).then((value) => value.update({'documentId': value.id}));
      return MessagesResponseResponseState.Success;
    } catch (err) {
      return MessagesResponseResponseState.Failed;
    }
  }

  Future<MessagesResponse> getMessages() async {
    try {
      List<Message> messages = List();
      await fireStoreInstance
          .collection("messages")
          .get()
          .then((querySnapshot) => querySnapshot.docs.forEach((doc) {
                messages.add(Message(
                    doc["message"], doc['numOfLike'], doc['documentId']));
              }));

      return MessagesResponse(
          MessagesResponseResponseState.Success, "", messages);
    } on PlatformException catch (err) {

      return MessagesResponse(
          MessagesResponseResponseState.Failed, err.toString(), null);
    } catch (err) {
      return MessagesResponse(
          MessagesResponseResponseState.Failed, err.toString(), null);
    }
  }

  Future<MessagesResponse> onLikeClick(String documentId, int number) async {
    try {
      await fireStoreInstance
          .collection("messages")
          .doc(documentId)
          .update({'numOfLike': number + 1});

      return MessagesResponse(
          MessagesResponseResponseState.Success, "Updated", null);
    } on PlatformException catch (err) {
      return MessagesResponse(
          MessagesResponseResponseState.Failed, err.toString(), null);
    } catch (err) {
      return MessagesResponse(
          MessagesResponseResponseState.Failed, err.toString(), null);
    }
  }

  Future<int> isUserLogged() async {
    var firebaseUser = await firebaseAuth.currentUser;
    if (firebaseUser != null) {
      return 1;
    } else {
      return 0;
    }
  }
  void updateUserEmail(String emailValue) async {
    await firebaseAuth.currentUser.updateEmail(emailValue);
  }

  void updateUserPassword(String passwordValue) async {
    await firebaseAuth.currentUser.updatePassword(passwordValue);
  }
}
