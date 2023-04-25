import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/common/functions/getCompanyId.dart';
import 'package:vim_mobile/common/functions/getDepotId.dart';
import 'package:vim_mobile/common/functions/getUserId.dart';
import 'package:vim_mobile/consts/consts.dart';

Future postIncident(
    BuildContext context,
    String questionDateTime,
    String questionReg,
    String questionFront,
    String questionDrivers,
    String questionNear,
    String questionRear,
    String questionCargo,
    String questionThirdParty,
    String questionPassengers,
    String questionThirdPartyDamage,
    int vehicleId) async {
  var token;
  var companyId;
  var depotId;
  var userId;
  Position position;

  await getToken().then((result) {
    token = result;
  });

  await getCompanyId().then((result) {
    companyId = result;
  });

  await getDepotId().then((result) {
    depotId = result;
  });

  await getUserId().then((result) {
    userId = result;
  });

  // position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

  //Create time of incident
  var dateTime = DateTime.now();
  var formatter = new DateFormat('dd/MM/yyyy HH:mm:ss');
  String formatted = formatter.format(dateTime).toString();

  //Accident time of incident
  var accidentDateTimeString = DateTime.parse(questionDateTime);
  var accidentFormatter = new DateFormat('dd/MM/yyyy HH:mm:ss');
  var accidentTime = accidentFormatter.format(accidentDateTimeString);

  var dio = new Dio();

  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json-patch+json",
    "Authorization": "Bearer $token",
  };

  try {
    var response = await dio.post(
      BASE_URL + "/api/incidents/Create",
      data: {
        'deleted': 0,
        'label': 'client',
        'companyId': companyId,
        'depotId': depotId,
        'vehicleId': vehicleId,
        'createdTime': '$formatted',
        'userId': '$userId',
        'latitude': position.latitude,
        'longitude': position.longitude,
        'status': 'Pending',
        'incidentQuestions': [
          {
            'questionId': 1,
            'answer': '$accidentTime',
          },
          {
            'questionId': 4,
            'answer': '$formatted',
          },
          {
            'questionId': 120,
            'answer': '$questionFront',
          },
          {
            'questionId': 121,
            'answer': '$questionDrivers',
          },
          {
            'questionId': 122,
            'answer': '$questionNear',
          },
          {
            'questionId': 123,
            'answer': '$questionRear',
          },
          {
            'questionId': 124,
            'answer': '$questionCargo',
          },
          {
            'questionId': 125,
            'answer': '$questionThirdParty',
          },
          {
            'questionId': 85,
            'answer': '$questionPassengers',
          },
          {
            'questionId': 126,
            'answer': '$questionThirdPartyDamage',
          },
        ]
      },
    );
    print(response.data.toString());
  } catch (e) {
    print(e);
  }
}
