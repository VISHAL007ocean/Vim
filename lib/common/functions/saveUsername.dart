import 'package:shared_preferences/shared_preferences.dart';
import 'package:vim_mobile/models/login/username_model.dart';

saveCurrentUsername(Map responseJson) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var user;
  if ((responseJson != null && responseJson.isNotEmpty)) {
    user = UsernameModel.fromJson(responseJson);
  } else {
    user = "";
  }
  var username = (responseJson != null && responseJson.isNotEmpty) ? UsernameModel.fromJson(responseJson).username : "";

  await preferences.setString('CurrentUsername', username.toString());

}