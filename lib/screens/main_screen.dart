import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fly_message/block/messages_block.dart';
import 'package:fly_message/models/MessagesResponse.dart';
import 'package:fly_message/models/message_model.dart';
import 'package:fly_message/screens/publish_message.dart';
import 'package:fly_message/widgets/message_widget.dart';
import 'package:random_color/random_color.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final MessageBlock messageBlock = MessageBlock();
  List<Message> listOfMessages = List();
  RandomColor _randomColor = RandomColor();


  String documentId;
  @override
  void initState() {
    super.initState();
    messageBlock.getMessages();
  }

  @override
  void dispose() {
    super.dispose();
    messageBlock.dispose();
  }

  void onLikeClick( String documentId , int number){
    messageBlock.onLikeClick(documentId, number);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<MessagesResponse>(
          stream: messageBlock.messageStream,
          initialData: MessagesResponse(MessagesResponseResponseState.Initial,"Loading",null),
          builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ErrorWidget(snapshot.error);
              }
              else if(snapshot.data.messagesResponseState == MessagesResponseResponseState.Failed){
                return ErrorWidget(snapshot.data.msg);
              }
              else if(snapshot.data.messagesResponseState == MessagesResponseResponseState.Success){
                if(snapshot.data.msg =="Updated") {
                  snapshot.data.listOfMessages = listOfMessages;
                }
                else{
                  listOfMessages =snapshot.data.listOfMessages;
                }
                return  PageView.builder(
                    itemCount: snapshot.data.listOfMessages.length,
                    itemBuilder: (context, index) {
                      var model = snapshot.data.listOfMessages[index];
                      if(snapshot.data.msg =="Updated") {
                        model.numOfLike += 1;
                      }
                      return MessageWidget(
                        message: model.message,
                        numOfLike: model.numOfLike.toString(),
                        bgColor: _randomColor.randomColor(
                          colorHue: ColorHue.multiple(
                            colorHues: [ColorHue.red, ColorHue.blue],
                          ),
                        ),
                        onLikeClick: (){
                          onLikeClick(model.documentId ,model.numOfLike);
                        },
                      );
                    });
              }
              else{
                return Center(
                  child: Container(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator()
                  ),
                );
              }

          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.border_color),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PublishMessage()),
          );
        },
      ),
    );
  }
}
