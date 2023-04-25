import 'package:shared_preferences/shared_preferences.dart';

getCompanyId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String getCompanyId = await preferences.getString("CurrentCompanyId");
  return getCompanyId;
}