import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vim_mobile/common/functions/saveUsersPermissions.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/common/functions/getUserId.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/login/users_permissions.dart';

Future<UserPermissionsModel> requestPermissions(BuildContext context) async {
  var token;
  var userId;

  await getToken().then((result) {
    token = result;
  });

  await getUserId().then((result) {
    userId = result;
  });

  Map<String, String> body = {'userId': userId};

  final response =
      await http.post(Uri.parse(BASE_URL + '/api/incidents/GetUsersPermissions'),
          headers: {
            "Content-Type": "application/json-patch+json",
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
          body: json.encode(body));

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    await saveUserPermissions(responseJson);
    Navigator.pushNamed(context, '/dashboard');
    return UserPermissionsModel.fromJson(responseJson);
  } else {
    final responseJson = json.decode(response.body);

    saveUserPermissions(responseJson);
    return null;
  }
}
