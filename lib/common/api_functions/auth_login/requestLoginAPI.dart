import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vim_mobile/common/functions/saveCurrentLogin.dart';
import 'package:vim_mobile/common/functions/showDialogSingleButton.dart';
import 'package:vim_mobile/consts/consts.dart';

Future<dynamic> requestLoginAPI(
    BuildContext context, String username, String password) async {
  var dio = new Dio();
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String pushtoken = preferences.getString("push_token");

  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  try {
    print("push=====$pushtoken");

    final response = await dio.post(BASE_URL + '/api/login', data: {
      'userName': username,
      'password': password,
      'DeviceToken': pushtoken
    });

    print("Login API ============================== ${response}");

    if (response.statusCode == 200) {
      var responseJson = response.data;
      var jwt = json.decode(responseJson["jwt"]);
      var role = responseJson["role"];
      var depots = responseJson["depots"];

      if (role == "Engineer") {
        preferences.setString("name", depots[0]["name"]);
        preferences.setString('LastUserRole', role.toString());
        preferences.setString(
            'CurrentDepotId', depots[0]["depotId"].toString());
        preferences.setString(
            'CurrentCompanyId', depots[0]["companyId"].toString());
        if (depots[0]["defaultVehicleId"] != null) {
          preferences.setString(
              'DefaultVehicleId', depots[0]["defaultVehicleId"].toString());
        }
      }

      var companyLogo = responseJson["companyLogo"];
      var logoImageString = companyLogo["logo"];

      await preferences.setString('logoImageUrl', logoImageString);

      saveCurrentLogin(jwt, role.toString());
      return responseJson;
    } else {
      final responseJson = response.data;
      var jwt = json.decode(responseJson["jwt"]);
      var role = responseJson["role"];
      saveCurrentLogin(jwt, role.toString());
      showDialogSingleButton(
          context,
          "Unable to Login",
          "You may have supplied an invalid 'Username' / 'Password' combination. Please try again or contact your support representative.",
          "OK");
      return null;
    }
  } catch (e) {
    showDialogSingleButton(
        context,
        "Unable to Login",
        "You may have supplied an invalid 'Username' / 'Password' combination. Please try again or contact your support representative.",
        "OK");
    return null;
  }
}
