import 'package:shared_preferences/shared_preferences.dart';

getUserId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String getUserId = preferences.getString("LastUserId");
  return getUserId;
}
Future<String> getRole() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String forename = await preferences.getString("LastUserRole");

  return forename;
}
Future<String> getFullName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String forename = await preferences.getString("Forename");
  String surname = await preferences.getString("Surname");
  String fullname = forename + ' ' + surname;
  return fullname;
}
Future<String> getName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String forename = await preferences.getString("name");

  return forename;
}
