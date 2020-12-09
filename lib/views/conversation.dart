import 'package:ChatApp/services/data.dart';
import 'package:ChatApp/services/helper.dart';
import 'package:ChatApp/widgets/widget.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  final String id;
  Conversation(this.id);
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  String id, username;
  TextEditingController msg = new TextEditingController();
  Data database = new Data();
  Stream messageStream;
  Widget MessageList() {
    return StreamBuilder(
        stream: messageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    // print(snapshot.data.documents[index]
                    //         .get("sendBy")
                    //         .toString() +
                    //     "------------" +
                    //     this.username);
                    return Message(
                        snapshot.data.documents[index].get("message"),
                        snapshot.data.documents[index]
                                .get("sendBy")
                                .toString() ==
                            this.username);
                  },
                )
              : Container();
        });
  }

  sendMessage() {
    if (msg.text.isNotEmpty) {
      Map<String, dynamic> message = {
        "message": msg.text,
        "sendBy": username,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      database.sendMessages(widget.id, message);
      msg.text = "";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    messageStream = database.getMessages(widget.id);
    super.initState();
    getUsername();
  }

  getUsername() async {
    Helper.sessionGetusername().then((value) {
      setState(() {
        username = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            MessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msg,
                      decoration: textFieldInputDecoration('Message'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Icon(Icons.send),
                  ),
                ],
              ),
            ),
            //searchList()
          ],
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String msg;
  final bool isme;
  Message(this.msg, this.isme);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isme ? 0 : 20, right: isme ? 20 : 0),
      margin: EdgeInsets.symmetric(vertical: 6),
      width: MediaQuery.of(context).size.width,
      alignment: isme ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isme
                  ? [
                      const Color(0xff007Ef4),
                      const Color(0xff2A75BC),
                    ]
                  : [
                      const Color(0xff007Ef4),
                      const Color(0xff2A75BC),
                    ],
            ),
            borderRadius: isme
                ? BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))
                : BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
        child: Text(
          msg,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
