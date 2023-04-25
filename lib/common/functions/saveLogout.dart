import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

saveLogout() async {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.setString('LastUser', "");
  await preferences.setString('LastToken', "");
  await preferences.setString('LastEmail', "");
  await preferences.setString('CurrentUsername', "");
  await preferences.setString('CurrentCompanyId', "");
  await preferences.setString('CurrentDepotId', "");
  await preferences.setInt('LastUserId', 0);
  await preferences.setInt('UserId', 0);
  await preferences.setString('Username', "");
  await preferences.setString('Forename', "");
  await preferences.setString('Surname', "");
  await preferences.setString('FullName', "");
  await preferences.setString('PermissionsIncidents', "");
  await preferences.setString('PermissionsDriverChecks', "");
  await preferences.setString('PermissionsVehicleRepairs', "");
  await preferences.clear();
  String token = await FirebaseMessaging.instance.getToken();
  preferences.setString("push_token", token);
  print("=============TOKEN ======$token");
  await preferences.commit();
}
