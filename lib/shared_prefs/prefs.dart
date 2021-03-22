import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static saveChecked(bool flag) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("check", flag);
  }

  static Future<bool> isChecked() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("check") ?? false;
  }

  static saveUsername(String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("username", username);
  }

  static Future getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String username = preferences.getString("username") ?? "";
    return username;
  }

  static savePassword(String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("password", password);
  }

  static Future getPassword() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String password = preferences.getString("password") ?? "";
    return password;
  }

  static clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
