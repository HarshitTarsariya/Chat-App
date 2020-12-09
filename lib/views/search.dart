import 'package:ChatApp/services/data.dart';
import 'package:ChatApp/services/helper.dart';
import 'package:ChatApp/views/conversation.dart';
import 'package:ChatApp/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String username;
  Data database = new Data();
  TextEditingController search = new TextEditingController();
  QuerySnapshot users;
  searchInitializer() {
    database.getUserByUsername(search.text).then((val) {
      setState(() {
        users = val;
      });
    });
  }

  createConversation({String username}) {
    if (this.username != username) {
      String id = getUniqueId(username, this.username);
      List<String> users = [username, this.username];
      Map<String, dynamic> mp = {"users": users, "chatid": id};
      database.createChat(id, mp);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Conversation(id = id)));
    } else {
      print("Can't Send Message to yourself");
    }
  }

  Widget searchList() {
    return users != null
        ? ListView.builder(
            itemCount: users.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchCard(
                  username: users.documents[index].get("name"),
                  email: users.documents[index].get("email"));
            },
          )
        : Container();
  }

  Widget SearchCard({String username, String email}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username),
              Text(email),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              //create Conversation
              createConversation(username: username);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text('Message'),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUsername();
  }

  setUsername() async {
    username = await Helper.sessionGetusername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: search,
                      decoration: textFieldInputDecoration('Username'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      searchInitializer();
                    },
                    child: Icon(Icons.search),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getUniqueId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
