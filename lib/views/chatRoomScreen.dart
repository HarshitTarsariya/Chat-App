import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/data.dart';
import 'package:ChatApp/services/helper.dart';
import 'package:ChatApp/views/conversation.dart';
import 'package:ChatApp/views/search.dart';
import 'package:ChatApp/views/signin.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Auth service = new Auth();
  Data database = new Data();
  String username;

  Stream chatsStream;

  Widget chatList() {
    return StreamBuilder(
        stream: chatsStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return Chats(
                        snapshot.data.documents[index]
                            .get("chatid")
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(this.username, ""),
                        snapshot.data.documents[index]
                            .get("chatid")
                            .toString());
                  },
                )
              : Container();
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
    chatsStream = database.getAllChatsToWhomTalk(username);
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
      appBar: AppBar(
        title: Text('ConnectApp'),
        actions: [
          GestureDetector(
            onTap: () {
              service.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: chatList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class Chats extends StatelessWidget {
  final String username;
  final String chatid;
  Chats(this.username, this.chatid);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Conversation(this.chatid)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(35)),
              child: Text("${username.substring(0, 1).toUpperCase()}"),
            ),
            SizedBox(width: 10),
            Text(
              username,
              style: TextStyle(
                fontSize: 22,
              ),
            )
          ],
        ),
      ),
    );
  }
}
