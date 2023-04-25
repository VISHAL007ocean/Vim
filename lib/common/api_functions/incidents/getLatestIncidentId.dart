import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vim_mobile/common/functions/showDialogSingleButton.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/consts/consts.dart';

Future<int> getLatestIncidentId(BuildContext context) async {
  var id;
  var token;

  await getToken().then((result) {
    token = result;
  });

  var dio = new Dio();

  dio.options.headers = {
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  };

  final idResponse =
      await dio.get(BASE_URL + '/api/incidents/LatestIncidentId');

  if (idResponse.statusCode == 200) {
    id = idResponse.data;
  } else {
    showDialogSingleButton(
        context,
        'No Incident found',
        'You hae somehow got to he report page without creating an incident please close the app and start again.',
        'OK');
  }

  return id;
}
