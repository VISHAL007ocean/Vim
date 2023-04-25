import 'package:shared_preferences/shared_preferences.dart';

getUsername() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String getUsername = await preferences.getString("CurrentUsername");
  return getUsername;
}