import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vim_mobile/common/functions/saveLogout.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/login/login_model.dart';

Future<LoginModel> requestLogoutAPI(BuildContext context) async {
  final url = BASE_URL + "/api/logout";

  final response = await post(
      Uri.parse(url),
    // headers: {HttpHeaders.authorizationHeader: "Token $token"},
  );

  if (response.statusCode == 200) {
    saveLogout();
    return null;
  } else {
    saveLogout();
    return null;
  }
}
