import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text('ConnectApp'),
  );
}

InputDecoration textFieldInputDecoration(String placeholder) {
  return InputDecoration(
    hintText: placeholder,
  );
}
