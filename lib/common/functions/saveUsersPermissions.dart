import 'package:shared_preferences/shared_preferences.dart';
import 'package:vim_mobile/models/login/users_permissions.dart';

saveUserPermissions(Map responseJson) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var user;
  if ((responseJson != null && responseJson.isNotEmpty)) {
    user = UserPermissionsModel.fromJson(responseJson);
  } else {
    user = "";
  }
  var mobileDriverChecks = (responseJson != null && responseJson.isNotEmpty) ? UserPermissionsModel.fromJson(responseJson).mobileDriverChecks : "";
  var mobileIncidents = (responseJson != null && responseJson.isNotEmpty) ? UserPermissionsModel.fromJson(responseJson).mobileIncidents : "";
  var mobileVehicleRepairs = (responseJson != null && responseJson.isNotEmpty) ? UserPermissionsModel.fromJson(responseJson).mobileVehicleRepairs : "";

  await preferences.setString('PermissionsDriverChecks', mobileDriverChecks.toString());
  await preferences.setString('PermissionsIncidents', mobileIncidents.toString());
  await preferences.setString('PermissionsVehicleRepairs', mobileVehicleRepairs.toString());
  await preferences.setString('PermissionsVehicleRepairs', mobileVehicleRepairs.toString());
}