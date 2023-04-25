import 'package:shared_preferences/shared_preferences.dart';

getFeaturePermission(String featureName) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String getFeaturePermission = preferences.getString(featureName);
  return getFeaturePermission;
}
