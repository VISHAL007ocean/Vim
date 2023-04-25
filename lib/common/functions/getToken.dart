import 'package:shared_preferences/shared_preferences.dart';

getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String getToken = preferences.getString("LastToken");
  return getToken;
}

getSession() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String getSession = preferences.getString("session")?? DateTime.now().toString();
  return getSession;
}

resetPrefs() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
  preferences.commit();

}
