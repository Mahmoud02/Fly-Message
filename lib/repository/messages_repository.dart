import 'package:fly_message/database/firebase_manager.dart';
import 'package:fly_message/models/MessagesResponse.dart';

class MessageRepository{
  FirebaseManager firebaseManager = FirebaseManager();

  Future<MessagesResponse>  getMessages() async{
    return await firebaseManager.getMessages();
  }
  Future<MessagesResponse> onLikeClick(String documentId ,int number ) async{
    return await firebaseManager.onLikeClick(documentId,number);
  }
  Future<MessagesResponseResponseState> flyMessageToOtherUsers(String msg) async{
    return firebaseManager.flyMessageToOtherUsers(msg);
  }
}