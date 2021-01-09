import 'package:fly_message/models/message_model.dart';

enum MessagesResponseResponseState { Success, Failed, loading, Initial }

class MessagesResponse {
  MessagesResponseResponseState messagesResponseState;
  String msg;

  List<Message> listOfMessages;

  MessagesResponse(this.messagesResponseState, this.msg, this.listOfMessages);
}
