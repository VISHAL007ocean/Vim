import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vim_mobile/common/functions/showDialogSingleButton.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/consts/consts.dart';

Future<int> getLatestDriverCheckId(BuildContext context) async {
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
      await dio.get(BASE_URL + '/api/driverchecks/LatestDriverChecksId');

  if (idResponse.statusCode == 200) {
    id = idResponse.data;
  } else {
    showDialogSingleButton(context, 'No driver check found',
        'Something has just gone wrong contact Vim team for help.', 'OK');
  }

  return id;
}
