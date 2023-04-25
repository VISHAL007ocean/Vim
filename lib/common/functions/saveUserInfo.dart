import 'package:shared_preferences/shared_preferences.dart';
import 'package:vim_mobile/models/login/user_info.dart';

saveUserInfo(Map responseJson) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var user;
  if ((responseJson != null && responseJson.isNotEmpty)) {
    user = UserInfoModel.fromJson(responseJson);
  } else {
    user = "";
  }
  var userId = (responseJson != null && responseJson.isNotEmpty) ? UserInfoModel.fromJson(responseJson).userId : "";
  var username = (responseJson != null && responseJson.isNotEmpty) ? UserInfoModel.fromJson(responseJson).username : "";
  var forename = (responseJson != null && responseJson.isNotEmpty) ? UserInfoModel.fromJson(responseJson).forename : "";
  var surname = (responseJson != null && responseJson.isNotEmpty) ? UserInfoModel.fromJson(responseJson).surname : "";
  var mobileDriverChecks = (responseJson != null && responseJson.isNotEmpty) ? UserInfoModel.fromJson(responseJson).mobileDriverChecks : "";
  var mobileIncidents = (responseJson != null && responseJson.isNotEmpty) ? UserInfoModel.fromJson(responseJson).mobileIncidents : "";
  var mobileVehicleRepairs = (responseJson != null && responseJson.isNotEmpty) ? UserInfoModel.fromJson(responseJson).mobileVehicleRepairs : "";
  
  await preferences.setString('UserId', userId.toString());
  await preferences.setString('Username', username.toString());
  await preferences.setString('Forename', forename.toString());
  await preferences.setString('Surname', surname.toString());
  await preferences.setString('MobileDriverChecks', mobileDriverChecks.toString());
  await preferences.setString('MobileIncidents', mobileIncidents.toString());
  await preferences.setString('MobileVehicleRepairs', mobileVehicleRepairs.toString());
}