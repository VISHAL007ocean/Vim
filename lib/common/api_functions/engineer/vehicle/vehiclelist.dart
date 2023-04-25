import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/common/functions/showDialogSingleButton.dart';
import 'dart:async';
import 'dart:convert';
import 'package:vim_mobile/consts/consts.dart';
import 'package:dio/dio.dart';
import 'package:vim_mobile/models/engineer/job_list/job_list_model.dart';
import 'package:vim_mobile/models/engineer/vehicle/thirdpartyvehmodel.dart';
import 'package:vim_mobile/models/engineer/vehicle/vehiclelistmodel.dart';
Future<List<VehList>> getVehList(String vehNo) async {
  print(" -----vehicle");
  var token;
  var responseJson;
  var dio = new Dio();
  List<VehList> vehList =<VehList>[];

  VehicleListModel model;

  await getToken().then((result) {
    token = result;
  });

  //token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJzaGFocGFsYWtoIiwianRpIjoiYjE1YWIwNWUtOGYxMC00YzI1LTk1OTMtMTk4NzE3MmM2NTg4IiwiaWF0IjoxNjQ2MzYzMDQ1LCJyb2wiOiJhcGlfYWNjZXNzIiwiaWQiOiI4MDE0NDJlYS0yM2EyLTQwN2MtYTU4ZC0yMDRhZjg3MWFlYmQiLCJuYmYiOjE2NDYzNjMwNDUsImV4cCI6MTY0NjQ0OTQ0NSwiaXNzIjoid2ViQXBpIiwiYXVkIjoiaHR0cHM6Ly9kZXYudmltLWx0ZC5jb20vIn0.DVyGcp1vQLF41G3E2iO1CXDkrt2LgrdhqouSGybZUAY";
  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json-patch+json",
    "Authorization": "Bearer $token",
  };

  try {
    final response = await dio.get(
        BASE_URL + '/api/vehicles/checkVehicleRegistration',
        queryParameters: {
          'vehicle': vehNo,
        });

   // responseJson = response.data;
    print(" -----/api/vehicles/checkVehicleRegistration");
    model=VehicleListModel.fromJson(response.data);
    vehList=model.list;
    print(response.data);

  //TODO list vehicle
    print(vehList);
  } catch (e) {
    debugPrint(e.toString());
  }

  return vehList;
}

Future<List<ThirdPartyVehDetails>> getThirdVehList(String vehNo) async {
  var token;
  var responseJson;
  var dio = new Dio();


  ThirdPartyVehDetails details= ThirdPartyVehDetails();

  List<ThirdPartyVehDetails> vehList=<ThirdPartyVehDetails>[];

  ThirdPartyVehModel model;

  await getToken().then((result) {
    token = result;
  });

  //token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJzaGFocGFsYWtoIiwianRpIjoiYjE1YWIwNWUtOGYxMC00YzI1LTk1OTMtMTk4NzE3MmM2NTg4IiwiaWF0IjoxNjQ2MzYzMDQ1LCJyb2wiOiJhcGlfYWNjZXNzIiwiaWQiOiI4MDE0NDJlYS0yM2EyLTQwN2MtYTU4ZC0yMDRhZjg3MWFlYmQiLCJuYmYiOjE2NDYzNjMwNDUsImV4cCI6MTY0NjQ0OTQ0NSwiaXNzIjoid2ViQXBpIiwiYXVkIjoiaHR0cHM6Ly9kZXYudmltLWx0ZC5jb20vIn0.DVyGcp1vQLF41G3E2iO1CXDkrt2LgrdhqouSGybZUAY";
  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json-patch+json",
    "Authorization": "Bearer $token",
  };
print(vehNo);
  try {
    final response = await dio.get(
        BASE_URL + '/api/vehicles/GetVehicleDataFromDVLA',
        queryParameters: {
          'vrm': vehNo,
        });

    // responseJson = response.data;

    model=ThirdPartyVehModel.fromJson(response.data);
    details=model.dataitem;
    vehList.add(details);
    print(response.data);

    //TODO list vehicle
    print(details);
  } catch (e) {
    debugPrint(e.toString());
  }

  return vehList;
}
Future<bool> checkVehicleStatus(String vehNo,BuildContext context,) async {
  var token;
  var responseJson;
  var dio = new Dio();
  List<DialogButton> buttons = [
    DialogButton(
      child: Text(
        "CLOSE",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () => Navigator.pop(context),
      width: 120,
    )
  ];



  await getToken().then((result) {
    token = result;
  });

  //token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJzaGFocGFsYWtoIiwianRpIjoiYjE1YWIwNWUtOGYxMC00YzI1LTk1OTMtMTk4NzE3MmM2NTg4IiwiaWF0IjoxNjQ2MzYzMDQ1LCJyb2wiOiJhcGlfYWNjZXNzIiwiaWQiOiI4MDE0NDJlYS0yM2EyLTQwN2MtYTU4ZC0yMDRhZjg3MWFlYmQiLCJuYmYiOjE2NDYzNjMwNDUsImV4cCI6MTY0NjQ0OTQ0NSwiaXNzIjoid2ViQXBpIiwiYXVkIjoiaHR0cHM6Ly9kZXYudmltLWx0ZC5jb20vIn0.DVyGcp1vQLF41G3E2iO1CXDkrt2LgrdhqouSGybZUAY";
  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json-patch+json",
    "Authorization": "Bearer $token",
  };
  print(vehNo);
  try {
    final response = await dio.post(
        BASE_URL + '/api/driverchecks/vehiclestatuscheck',
        queryParameters: {
          'vrm': vehNo,
        });

    if(response.statusCode==200){
      var responseJson = response.data;
      var status = json.decode(responseJson["status"].toString());
      print("HELOO");
      print(status);
      print("STTTTT"+status.toString());
      if(status==1){
        var msg = responseJson["message"];
        Alert(
            context: context,
            title: "Alert !",
            desc: msg,
            buttons: buttons)
            .show();
        return false;
      }else {
        return true;
      }

    }

    // responseJson = response.data;

  } catch (e) {
    debugPrint(e.toString());
    return false;
  }

  return true;
}


Future<bool> checkFltStatus(String vehNo,BuildContext context,) async {
  var token;
  var responseJson;
  var dio = new Dio();
  List<DialogButton> buttons = [
    DialogButton(
      child: Text(
        "CLOSE",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () => Navigator.pop(context),
      width: 120,
    )
  ];



  await getToken().then((result) {
    token = result;
  });

  //token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJzaGFocGFsYWtoIiwianRpIjoiYjE1YWIwNWUtOGYxMC00YzI1LTk1OTMtMTk4NzE3MmM2NTg4IiwiaWF0IjoxNjQ2MzYzMDQ1LCJyb2wiOiJhcGlfYWNjZXNzIiwiaWQiOiI4MDE0NDJlYS0yM2EyLTQwN2MtYTU4ZC0yMDRhZjg3MWFlYmQiLCJuYmYiOjE2NDYzNjMwNDUsImV4cCI6MTY0NjQ0OTQ0NSwiaXNzIjoid2ViQXBpIiwiYXVkIjoiaHR0cHM6Ly9kZXYudmltLWx0ZC5jb20vIn0.DVyGcp1vQLF41G3E2iO1CXDkrt2LgrdhqouSGybZUAY";
  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json-patch+json",
    "Authorization": "Bearer $token",
  };
  print(vehNo);
  try {
    final response = await dio.post(
        BASE_URL + '/api/fltchecks/vehiclestatuscheck',
        queryParameters: {
          'vrm': vehNo,
        });
    print('vrm: $vehNo');
    print('/api/fltchecks/vehiclestatuscheck');
    if(response.statusCode==200){
      var responseJson = response.data;
      var status = json.decode(responseJson["status"].toString());
      print("HELOO");
      print(status);
      print("STTTTT"+status.toString());
      if(status==1){
        var msg = responseJson["message"];
        Alert(
            context: context,
            title: "Alert !",
            desc: msg,
            buttons: buttons)
            .show();
        return false;
      }else {
        return true;
      }

    }

    // responseJson = response.data;

  } catch (e) {
    debugPrint(e.toString());
    return false;
  }

  return true;
}

