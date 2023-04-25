import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:vim_mobile/consts/consts.dart';

Future postIncidentImages(
    BuildContext context, var id, List<File> imageList, bool thirdParty,bool check,int sign) async {
  String messageTitle;
  String message;
  List<MultipartFile> files = new List<MultipartFile>();
  List<MapEntry<String, MultipartFile>> mapEntry =
      new List<MapEntry<String, MultipartFile>>();
  FormData formData = FormData();

  for (int i = 0; i < imageList.length; i++) {
    List<int> imageData = await imageList[i].readAsBytes();
    MultipartFile multipartFile = new MultipartFile.fromBytes(
      imageData,
      filename: 'Image ' + (i + 1).toString(),
      contentType: MediaType("image", "jpg"),
    );
    mapEntry.add(MapEntry(
        'Files',
        MultipartFile.fromBytes(imageData,
            filename: thirdParty
                ? "Third-Party-Damage" + (i + 1).toString()
                : sign==1?("Signature" + (i + 1).toString()):("Company-Damage" + (i + 1).toString()))));
  }

  var dio = new Dio();

  var token;
  var incidentId = id.toString();

  await getToken().then((result) {
    token = result;
  });

  dio.options.headers = {
    "Authorization": "Bearer $token",
    "Content-Type": "multipart/form-data",
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
    formData = FormData.fromMap({"Id": incidentId, "Files": mapEntry});
    formData.files.addAll(mapEntry);
    print(formData.toString());
    var response = await dio
        .post(
          BASE_URL + "/api/incidents/PostIncidentImages",
          data: formData,
        )
        .timeout(new Duration(seconds: 300));
    print(response.data);
    messageTitle = "Success";
    message = response.data;
    if(check){
      Alert(
          context: context,
          title: messageTitle,
          desc: message,
          buttons: buttons)
          .show();
    }

    print(response.data.toString());
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
    print("PostIncidentImages Error" + e.toString());
  } catch (e) {
    messageTitle = "Something went wrong!";
    message = e.response.data["message"];
    Alert(
            context: context,
            title: messageTitle,
            desc: message,
            buttons: buttons)
        .show();
    print("PostIncidentImages Error" + e.toString());
  }
}
