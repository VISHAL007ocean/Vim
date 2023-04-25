import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vim_mobile/common/functions/saveUserInfo.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/login/user_info.dart';
import 'package:vim_mobile/common/functions/getToken.dart';

Future<UserInfoModel> requestUserInfo() async {
  var token;

  await getToken().then((result) {
    token = result;
  });
  final response = await http.get(
      Uri.parse(BASE_URL + '/api/incidents/GetUserInfo'),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    saveUserInfo(responseJson);
    return UserInfoModel.fromJson(responseJson);
  } else {
    final responseJson = json.decode(response.body);

    saveUserInfo(responseJson);
    return null;
  }
}
