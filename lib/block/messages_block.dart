import 'dart:async';

import 'package:fly_message/models/MessagesResponse.dart';
import 'package:fly_message/repository/messages_repository.dart';

class MessageBlock {
  final _messageController = StreamController<MessagesResponse>();
  final _messagePublishController =
      StreamController<MessagesResponseResponseState>();

  Stream<MessagesResponse> get messageStream => _messageController.stream;

  Stream<MessagesResponseResponseState> get messagePublishStream =>
      _messagePublishController.stream;
  MessageRepository _messageRepository = MessageRepository();

  void getMessages() async {
    _messageController.sink.add(MessagesResponse(
        MessagesResponseResponseState.loading, "loading messages", null));

    await _messageRepository
        .getMessages()
        .then((value) => {_messageController.sink.add(value)});
  }

  void onLikeClick(String documentId, int number) async {
    await _messageRepository
        .onLikeClick(documentId, number)
        .then((value) => {_messageController.sink.add(value)});
  }

  void flyMessageToOtherUsers(String msg) async {
    _messagePublishController.sink.add(MessagesResponseResponseState.loading);
    await _messageRepository
        .flyMessageToOtherUsers(msg)
        .then((value) => _messagePublishController.sink.add(value));
  }

  void dispose() {
    _messageController.close();
    _messagePublishController.close();
  }
}
