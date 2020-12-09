import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/data.dart';
import 'package:ChatApp/services/helper.dart';
import 'package:ChatApp/views/signup.dart';
import 'package:ChatApp/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatRoomScreen.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  Auth service = new Auth();
  Data database = new Data();
  QuerySnapshot user;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  heySignIt() {
    if (formKey.currentState.validate()) {
      Helper.sessionSaveemail(email.text);
      database.getUserByEmail(email.text).then((val) {
        user = val;
        Helper.sessionSaveusername(user.documents[0].get("name"));
      });
      setState(() {
        isLoading = true;
      });
      service.signInWithEmailPassword(email.text, password.text).then((value) {
        if (value != null) {
          Helper.sessionSaveloggedin(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (got) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(got)
                                  ? null
                                  : "Invalid Email";
                            },
                            controller: email,
                            decoration: textFieldInputDecoration('Email'),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (got) {
                              return got.length > 6
                                  ? null
                                  : "Invalid Password(MinLength : 6)";
                            },
                            controller: password,
                            decoration: textFieldInputDecoration('Password'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        child: Text('Forget Password ?'),
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        heySignIt();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xff007EF4),
                              const Color(0xff007EF4),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text('Sign In'),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text('Sign In With Google'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account ? ",
                          style: TextStyle(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text(
                            "Register Now",
                            style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
