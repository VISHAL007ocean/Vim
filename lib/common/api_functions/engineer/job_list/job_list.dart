import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/engineer/job_list/job_list_model.dart';

Future<List<JobListModel>> getJobList(String status) async {
  var token;
  var responseJson;
  var dio = new Dio();
  List<JobListModel> jobList = <JobListModel>[];

  await getToken().then((result) {
    token = result;
  });

  //token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJzaGFocGFsYWtoIiwianRpIjoiYjE1YWIwNWUtOGYxMC00YzI1LTk1OTMtMTk4NzE3MmM2NTg4IiwiaWF0IjoxNjQ2MzYzMDQ1LCJyb2wiOiJhcGlfYWNjZXNzIiwiaWQiOiI4MDE0NDJlYS0yM2EyLTQwN2MtYTU4ZC0yMDRhZjg3MWFlYmQiLCJuYmYiOjE2NDYzNjMwNDUsImV4cCI6MTY0NjQ0OTQ0NSwiaXNzIjoid2ViQXBpIiwiYXVkIjoiaHR0cHM6Ly9kZXYudmltLWx0ZC5jb20vIn0.DVyGcp1vQLF41G3E2iO1CXDkrt2LgrdhqouSGybZUAY";
  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json-patch+json",
    "Authorization": "Bearer $token",
  };

  print("=======20-4 $status");
  print("=======20-4 $token");

  try {
    final response =
        await dio.get(BASE_URL + '/api/job/GetEngineerJob', queryParameters: {
      'status': status,
    });

    responseJson = response.data;
    jobList = (response.data as List)
        .map((data) => JobListModel.fromJson(data))
        .toList();
    print("==GetEngineerJob====${response.data}==============>>>>$jobList");
  } catch (e) {
    debugPrint(e.toString());
  }

  return jobList;
}
