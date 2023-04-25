import 'package:shared_preferences/shared_preferences.dart';
import 'package:vim_mobile/models/login/user_id_model.dart';

saveUsersCompanyAndDepot(Map responseJson) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var user;
  if ((responseJson != null && responseJson.isNotEmpty)) {
    user = UserIdModel.fromJson(responseJson);
  } else {
    user = "";
  }
  var companyId = (responseJson != null && responseJson.isNotEmpty)
      ? UserIdModel.fromJson(responseJson).companyId
      : "";
  var depotId = (responseJson != null && responseJson.isNotEmpty)
      ? UserIdModel.fromJson(responseJson).depotId
      : "";

  await preferences.setString('CurrentCompanyId', companyId.toString());
  await preferences.setString('CurrentDepotId', depotId.toString());
}
