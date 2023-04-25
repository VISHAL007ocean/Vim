import 'package:shared_preferences/shared_preferences.dart';
import 'package:vim_mobile/models/login/login_model.dart';

saveCurrentLogin(Map responseJson,String role) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();


  var user;
  if ((responseJson != null && responseJson.isNotEmpty)) {
    user = LoginModel.fromJson(responseJson);
  } else {
    user = "";
  }
  var token = (responseJson != null && responseJson.isNotEmpty) ? LoginModel.fromJson(responseJson).auth_token : "";
  var id = (responseJson != null && responseJson.isNotEmpty) ? LoginModel.fromJson(responseJson).id : "";
  // var expiresIn = (responseJson != null && !responseJson.isEmpty) ? LoginModel.fromJson(responseJson).expires_in : 0;

  await preferences.setString('LastToken', token.toString());
  print("LASTTOKEN"+token);
  await preferences.setString('LastUserId', id.toString());
  await preferences.setString('LastUserRole', role.toString());

  // await preferences.setInt('LastExpiresIn', (expiresIn != null && expiresIn > 0) ? expiresIn : 0);

}