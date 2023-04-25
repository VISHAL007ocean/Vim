import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/consts/consts.dart';

Future postVehicleRepairsImages(
  BuildContext context,
  var id,
  List<http.MultipartFile> files,
) async {
  var dio = new Dio();
  String messageTitle;
  String message;

  var token;
  var incidentId = id.toString();

  await getToken().then((result) {
    token = result;
  });

  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "multipart/form-data",
    "Authorization": "Bearer $token",
  };

  List<DialogButton> buttons = [
    DialogButton(
      child: Text(
        "CLOSE",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () => Navigator.pushNamed(context, '/dashboard'),
      width: 120,
    )
  ];

  try {
    FormData formData =
        new FormData.fromMap({"Id": incidentId, "Files": files});

    var response = await dio
        .post(
          BASE_URL + "/api/vehiclerepairs/PostImages",
          data: formData,
        )
        .timeout(new Duration(seconds: 300));
    print(response.data["message"]);
    messageTitle = "Success";
    message = response.data["message"];
    Alert(
            context: context,
            title: messageTitle,
            desc: message,
            buttons: buttons)
        .show();
  } on TimeoutException catch (e) {
    messageTitle = "Slow connection!";
    message =
        "Images could not be sent due to a slow internet connection. Please try again later.";
    Alert(
            context: context,
            title: messageTitle,
            desc: message,
            buttons: buttons)
        .show();
    print("PostVehicleRepairsImages Error" + e.toString());
  } catch (e) {
    messageTitle = "Something went wrong!";
    message = e.response.data["message"];
    Alert(
            context: context,
            title: messageTitle,
            desc: message,
            buttons: buttons)
        .show();
    print("PostVehicleRepairsImages Error" + e.toString());
  }
}
