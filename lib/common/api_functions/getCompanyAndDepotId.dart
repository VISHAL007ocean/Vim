import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vim_mobile/common/functions/saveUsersCompanyAndDepot.dart';
import 'package:vim_mobile/common/functions/showDialogSingleButton.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/login/user_id_model.dart';
import 'package:vim_mobile/common/functions/getToken.dart';

Future<UserIdModel> getCompanyAndDepotAPI(
    BuildContext context, String companyCode, int depotChoosen) async {
  final url = BASE_URL + "/api/incidents/GetCompanyAndDepotId";

  Map<String, String> body = {
    'companyCode': companyCode,
    'depotId': depotChoosen.toString()
  };

  var token;

  await getToken().then((result) {
    token = result;
  });

  final response = await http.post(Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json-patch+json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(body));

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    saveUsersCompanyAndDepot(responseJson);
    return UserIdModel.fromJson(responseJson);
  } else {
    final responseJson = json.decode(response.body);

    saveUsersCompanyAndDepot(responseJson);
    showDialogSingleButton(
        context,
        "Unable to Login",
        "You may have supplied an invalid 'Username' / 'Password' combination. Please try again or contact your support representative.",
        "OK");
    return null;
  }
}
