import 'package:shared_preferences/shared_preferences.dart';

getDepotId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String getDepotId = preferences.getString("CurrentDepotId");
  return getDepotId;
}
