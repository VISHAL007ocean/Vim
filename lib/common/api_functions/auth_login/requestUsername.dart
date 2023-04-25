import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/login/username_model.dart';
import 'package:vim_mobile/common/functions/saveUsername.dart';

Future<UsernameModel> requestUsername() async {
  var token;

  await getToken().then((result) {
    token = result;
  });

  var dio = new Dio();

  dio.options.headers = {
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  };

  final response = await dio.get(BASE_URL + '/api/incidents/GetUsername');

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.data);
    saveCurrentUsername(responseJson);
    return UsernameModel.fromJson(responseJson);
  } else {
    final responseJson = json.decode(response.data);

    saveCurrentUsername(responseJson);
    return null;
  }
}
