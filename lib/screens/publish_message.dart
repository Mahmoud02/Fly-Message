import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_message/block/messages_block.dart';
import 'package:fly_message/models/MessagesResponse.dart';

class PublishMessage extends StatefulWidget {

  PublishMessage({Key key}) : super(key: key);
  @override
  _PublishMessageState createState() {
    return _PublishMessageState();
  }
}

class _PublishMessageState extends State<PublishMessage> {
  var  messageValue ;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MessageBlock messageBlock =  MessageBlock();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    messageBlock.dispose();
    super.dispose();
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
    final message = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      maxLength: 300,
      maxLines: 13,
      textInputAction: TextInputAction.done,
      validator: (value){return _messageValidate(value);},
      onSaved: (value){messageValue = value;},
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Type your Message',
        hintStyle: TextStyle(
          color: Colors.black,
          fontStyle: FontStyle.italic,
        ),
        contentPadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),

    );
    final publishButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _flyMessageToOtherUsers();
        },
        padding: EdgeInsets.all(12),
        color: Colors.teal,
        child: Text('Let your Message Fly', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: StreamBuilder<MessagesResponseResponseState>(
          stream: messageBlock.messagePublishStream,
          builder: (context, AsyncSnapshot<MessagesResponseResponseState> snapshot) {
            if(snapshot.data == MessagesResponseResponseState.Success)
              WidgetsBinding.instance.addPostFrameCallback((_) => _showSuccessMessage("Successfully Publish"));
            else if (snapshot.data == MessagesResponseResponseState.Failed) {
              WidgetsBinding.instance.addPostFrameCallback((_) => _showSuccessMessage("Something Wrong happen"));
            }
            return SafeArea(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children:<Widget>[
                    Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 24.0, right: 24.0),
                      children: <Widget>[
                        logo,
                        SizedBox(height: 40.0),
                        message,
                        SizedBox(height: 8.0),
                       publishButton,
                      ],
                    ),
                  ), if(snapshot.data == MessagesResponseResponseState.loading)
                    Container(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator()
                       ),
                ]),
              ),
            );
          }
      ),
    );
  }
  String _messageValidate(String value){
    if(value.isEmpty) return "type your message ";
    return null;
  }
   _flyMessageToOtherUsers(){
    bool isValid =_formKey.currentState.validate();
    if(!isValid) return ;
    _formKey.currentState.save();
    messageBlock.flyMessageToOtherUsers(messageValue);
  }

  _showSuccessMessage(String msg){
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Your Message has been published"),
    ));
  }

}