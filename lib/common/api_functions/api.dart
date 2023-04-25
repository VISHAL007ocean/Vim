import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/consts/consts.dart';

Future getIncidents(BuildContext context) async {
  var list;
  var token;

  await getToken().then((result) {
    token = result;
  });

  var dio = new Dio();

  dio.options.headers = {
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  };

  final response = await dio.get(BASE_URL + '/api/incidents/GetUserIncidents');

  if (response.statusCode == 200) {
    list = response.data;
  }

  return list;
}
