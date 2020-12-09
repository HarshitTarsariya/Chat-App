import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/data.dart';
import 'package:ChatApp/services/helper.dart';
import 'package:ChatApp/views/signin.dart';
import 'package:ChatApp/widgets/widget.dart';
import 'package:flutter/material.dart';

import 'chatRoomScreen.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  TextEditingController userName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  heySignIt() {
    if (formKey.currentState.validate()) {
      Map<String, String> mp = {"name": userName.text, "email": email.text};
      Helper.sessionSaveemail(email.text);
      Helper.sessionSaveusername(userName.text);
      setState(() {
        isLoading = true;
      });
      Auth service = new Auth();
      Data database = new Data();

      database.userUploader(mp);
      service.signUpWithEmailPassword(email.text, password.text).then((value) {
        Helper.sessionSaveloggedin(true);
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
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
                              return got.isEmpty || got.length < 5
                                  ? "Invalid Username"
                                  : null;
                            },
                            controller: userName,
                            decoration: textFieldInputDecoration('Username'),
                          ),
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
                        child: Text('Sign Up'),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Have account ? ",
                          style: TextStyle(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()));
                          },
                          child: Text(
                            "SignIn Now",
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
