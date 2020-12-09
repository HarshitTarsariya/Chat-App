import 'package:ChatApp/services/helper.dart';
import 'package:ChatApp/views/chatRoomScreen.dart';
import 'package:ChatApp/views/conversation.dart';
import 'package:ChatApp/views/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loggedIn = false;
  getStatus() async {
    await Helper.sessionGetloggedin().then((value) {
      setState(() {
        loggedIn = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConnectApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: SignIn(), //loggedIn ? ChatRoom() : SignIn(),
    );
  }
}
