import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static String loggedINKey = "ISLOGGEDIN";
  static String userNameKey = "USERNAME";
  static String emailKey = "EMAIL";

  static Future sessionSaveloggedin(bool loggedin) async {
    SharedPreferences session = await SharedPreferences.getInstance();
    return await session.setBool(loggedINKey, loggedin);
  }

  static Future sessionSaveusername(String username) async {
    SharedPreferences session = await SharedPreferences.getInstance();
    return await session.setString(userNameKey, username);
  }

  static Future sessionSaveemail(String email) async {
    SharedPreferences session = await SharedPreferences.getInstance();
    return await session.setString(emailKey, email);
  }

  static Future<bool> sessionGetloggedin() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    return await session.getBool(loggedINKey);
  }

  static Future<String> sessionGetusername() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    return await session.getString(userNameKey);
  }

  static Future<String> sessionGetemail(String email) async {
    SharedPreferences session = await SharedPreferences.getInstance();
    return await session.getString(emailKey);
  }
}
