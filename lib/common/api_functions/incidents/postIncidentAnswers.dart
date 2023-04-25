import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vim_mobile/common/functions/showDialogSingleButton.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/consts/consts.dart';

Future postIncidentAnswers(
    BuildContext context,
    var id,
    String questionDateTime,
    String questionReg,
    String questionFront,
    String questionDrivers,
    String questionNear,
    String questionRear,
    String questionCargo,
    String questionThirdParty,
    String questionPassengers,
    String questionThirdPartyDamage) async {
  var token;

  await getToken().then((result) {
    token = result;
  });

  var dateTime = DateTime.now().toString();
  var year = DateTime.now().year.toString();
  var reference = "VIM" + year + "/240" + id;

  var dio = new Dio();

  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json-patch+json",
    "Authorization": "Bearer $token",
  };

  var response =
      await dio.post(BASE_URL + "/api/incidents/PostIncidentAnswers", data: [
    {
      "incidentId": id,
      "questionId": 1,
      "answer": '$questionDateTime',
    },
    {
      "incidentId": id,
      "questionId": 2,
      "answer": "$questionReg",
    },
    {
      "incidentId": id,
      "questionId": 4,
      "answer": "$dateTime",
    },
    {
      "incidentId": id,
      "questionId": 5,
      "answer": "$reference",
    },
    {
      "incidentId": id,
      "questionId": 120,
      "answer": "$questionFront",
    },
    {
      "incidentId": id,
      "questionId": 121,
      "answer": "$questionDrivers",
    },
    {
      "incidentId": id,
      "questionId": 122,
      "answer": "$questionNear",
    },
    {
      "incidentId": id,
      "questionId": 123,
      "answer": "$questionRear",
    },
    {
      "incidentId": id,
      "questionId": 124,
      "answer": "$questionCargo",
    },
    {
      "incidentId": id,
      "questionId": 125,
      "answer": "$questionThirdParty",
    },
    {
      "incidentId": id,
      "questionId": 85,
      "answer": "$questionPassengers",
    },
    {
      "incidentId": id,
      "questionId": 126,
      "answer": "$questionThirdPartyDamage",
    },
  ]);

  if (response.statusCode == 200) {
    return null;
  } else {
    showDialogSingleButton(
        context,
        "Unable to create Incident",
        "You may have supplied the wrong information or you may need to authenticate you account again by signing out and then back in. Please try again or contact your support representative.",
        "OK");
    return null;
  }
}
