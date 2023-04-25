import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vim_mobile/common/functions/saveCurrentLogin.dart';
import 'package:vim_mobile/common/functions/showDialogSingleButton.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/login/login_model.dart';
import 'package:dio/dio.dart';

Future<LoginModel> getUsersPermissions(
    BuildContext context, String companyCode) async {
  var dio = new Dio();

  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  final response = await dio.post(BASE_URL + '/api/getdepots', data: {
    'companyCode': companyCode,
  });

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.data);
    var role = "Driver";
    print(responseJson);
    saveCurrentLogin(responseJson,role);
    return LoginModel.fromJson(responseJson);
  } else {
    final responseJson = json.decode(response.data);
    var role = "Driver";

    saveCurrentLogin(responseJson,role);
    showDialogSingleButton(
        context,
        "Unable to Login",
        "You may have supplied an invalid 'Username' / 'Password' combination. Please try again or contact your support representative.",
        "OK");
    return null;
  }
}
