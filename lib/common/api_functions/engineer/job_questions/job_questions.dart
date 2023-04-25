import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/consts/consts.dart';

Future<List<dynamic>> getInstallationQuestions(int companyId) async {
  var token;
  var responseJson;
  var dio = new Dio();

  await getToken().then((result) {
    token = result;
  });

  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json-patch+json",
    "Authorization": "Bearer $token",
  };

  try {
    final response = await dio.get(
        BASE_URL + '/api/installation/GetInstallationQuestions',
        queryParameters: {
          'companyId': companyId,
        });

    responseJson = response.data;
    print("=========GetInstallationQuestions======${response.data}");
  } catch (e) {
    debugPrint(e.toString());
  }

  return responseJson;
}

Future<List<dynamic>> getDeInstallationQuestions(int companyId) async {
  var token;
  var responseJson;
  var dio = new Dio();

  await getToken().then((result) {
    token = result;
  });

  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json-patch+json",
    "Authorization": "Bearer $token",
  };

  try {
    final response = await dio.get(
        BASE_URL + '/api/deinstallation/GetDeInstallationQuestions',
        queryParameters: {
          'companyId': companyId,
        });

    responseJson = response.data;

    print("=========GetDeInstallationQuestions======${response.data}");
  } catch (e) {
    debugPrint(e.toString());
  }

  return responseJson;
}

Future<List<dynamic>> getRepairQuestions(int companyId, {int jobID}) async {
  var token;
  var responseJson;
  var dio = new Dio();

  await getToken().then((result) {
    token = result;
  });

  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json-patch+json",
    "Authorization": "Bearer $token",
  };

  try {
    final response = await dio.get(
      BASE_URL + '/api/maintenancerepair/GetMaintenanceRepairQuestions',
      queryParameters: jobID != null
          ? {'companyId': companyId, "jobId": jobID}
          : {'companyId': companyId},
    );

    responseJson = response.data;
    print("=========GetMaintenanceRepairQuestions======${response.data}");
  } catch (e) {
    debugPrint(e.toString());
  }

  return responseJson;
}

Future<List<dynamic>> getCableQuestions(int companyId, {int jobID}) async {
  var token;
  var responseJson;
  var dio = new Dio();

  await getToken().then((result) {
    token = result;
  });

  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json-patch+json",
    "Authorization": "Bearer $token",
  };

  try {
    final response = await dio.get(
      BASE_URL + '/api/installationcable/GetInstallationCableQuestions',
      queryParameters: jobID != null
          ? {'companyId': companyId, "jobId": jobID}
          : {'companyId': companyId},
    );

    responseJson = response.data;
    print("=========GetInstallationCableQuestions======${response.data}");
  } catch (e) {
    debugPrint("====DIO ERROR $e=====");
  }

  return responseJson;
}
