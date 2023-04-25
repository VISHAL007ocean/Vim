import 'package:shared_preferences/shared_preferences.dart';

Future<String> getUserId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String userId = await preferences.getString("UserId");
  return userId;
}

Future<String> getUsername() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String username = await preferences.getString("Username");
  return username;
}

Future<String> getForename() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String forename = await preferences.getString("Forename");
  return forename;
}

Future<String> getSurname() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String surname = await preferences.getString("Surname");
  return surname;
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

Future<String> getRole() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String forename = await preferences.getString("LastUserRole");

  return forename;
}