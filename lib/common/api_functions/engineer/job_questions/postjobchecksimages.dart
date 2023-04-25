import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/engineer/job_question_answers/job_ans_model.dart';

//todo second in the row
Future<bool> postJobChecksImages(BuildContext context, var id,
    List<QuestionAnswer> answers, List<dynamic> questions,var type) async {
  String messageTitle;
  String message;
  List<dynamic> data = new List<dynamic>();
  List<MapEntry<String, MultipartFile>> mapEntry =
  new List<MapEntry<String, MultipartFile>>();
  FormData formData = FormData();

  int imageIndex = 0;
  String imgType;

  for (int i = 0; i < answers.length; i++) {
    //If question type is a pass/fail, then only images for failed questions will be sent.
    if (answers[i].imageData != null || (answers[i].answer != "" )) {

      for (var j = 0; j < answers[i].imageData.length; j++) {

        String fileExt = answers[i].imageData[j].image.path.split(".").last;

        imgType = answers[i].imageData[j].imgType;

        List<int> imageData = await answers[i].imageData[j].image.readAsBytes();

        var question = questions
            .firstWhere((k) => k["questionId"] == answers[i].questionId);

        String questionName = question["question"];

        final String fileName =
            questionName + " " + (j + 1).toString() + "." + fileExt;
        final String fileName1 = questionName + " " + (j + 1).toString();

        data.add({
          "QuestionTable":question["groupName"].toString().replaceAll("/", ""),
          "ImageIndex": fileName1.replaceAll("/", "-"),
          "QuestionId": question["questionId"],
          "AgeType":imgType,
          "FileName": fileName.replaceAll("/", "-")
        });

        mapEntry.add(MapEntry(
            'Files',
            MultipartFile.fromBytes(imageData,
                filename: fileName.toString())));

        imageIndex++;
      }
    }
  }

  var dio = new Dio();

  var token;
  var driverCheckId = id.toString();
  var url;

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
      onPressed: () => Navigator.pop(context),//Navigator.pushNamed(context, '/dashboard'),
      width: 120,
    )
  ];

  List<DialogButton> buttons2 = [
    DialogButton(
      child: Text(
        "CLOSE",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () => Navigator.pop(context),
      width: 120,
    )
  ];

  try {


    String imageData = jsonEncode(data);
    print(imageData);
    // todo as per new change
    url=BASE_URL + "/api/job/UploadImages";

    //for type specific url old code
   /* if(type=="M"){
      url=BASE_URL + "/api/maintenancerepair/UploadImages";
    }else if(type=="I"){
      url=BASE_URL + "/api/installation/UploadImages";
    }else if(type=="D"){
      url=BASE_URL + "/api/deinstallation/UploadImages";
    }*/
    formData = FormData.fromMap(
        {"Id": driverCheckId, "ImageData": imageData, "Files": mapEntry});
    formData.files.addAll(mapEntry);

    var response = await dio.post(url,
      data: formData,
    );
    print(response.data.toString());
    /*messageTitle = "Success";
    message = response.data["message"];

      Alert(
          context: context,
          title: messageTitle,
          desc: message,
          buttons: buttons)
          .show();*/

    return true;
  } catch (e) {

    messageTitle = "Something went wrong!";
    message = "try again later";
    Alert(
        context: context,
        title: messageTitle,
        desc: message,
        buttons: buttons2)
        .show();
    print("PostIncidentImages Error" + e.toString());
    return false;
  }
}

//to last in the row
Future<bool> postSignatureImages(BuildContext context, var id,
    List<QuestionAnswer> answers, var type,
    String vimChasis,
    String compDate,
    String millage,
    String dvrNo,
    String cableNotes,
    String cables) async {

  String messageTitle;
  String message;
  List<dynamic> data = new List<dynamic>();
  List<MapEntry<String, MultipartFile>> mapEntry =
  new List<MapEntry<String, MultipartFile>>();
  FormData formData = FormData();

  int imageIndex = 0;
  String imgType;
  String imgFor="";

  for (int i = 0; i < answers.length; i++) {
    //If question type is a pass/fail, then only images for failed questions will be sent.
    if (answers[i].imageData != null || (answers[i].answer != "" )) {
      for (var j = 0; j < answers[i].imageData.length; j++) {
        String fileExt = answers[i].imageData[j].image.path.split(".").last;

        imgType = answers[i].imageData[j].imgType;

        List<int> imageData = await answers[i].imageData[j].image.readAsBytes();


        if(imgType.contains("Eng")){

          imgFor="Engineer";
        }else {
          imgFor="Customer";
        }


        final String fileName =
            imgType + " " + (j + 1).toString() + "." + fileExt;

        final String fileName1 =
            imgType + " " + (j + 1).toString();

        data.add({
          "ImageFor":imgFor,
          "ImageIndex":fileName1.replaceAll("/", "-"),
           "AgeType":"New",
          "FileName":fileName.replaceAll("/", "-")
        });

        mapEntry.add(MapEntry(
            'Files',
            MultipartFile.fromBytes(imageData,
                filename: fileName.toString())));

        imageIndex++;
      }
    }
  }

  var dio = new Dio();

  var token;
  var driverCheckId = id.toString();
  var url;

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
      onPressed: () => Navigator.pushNamed(context, '/joblist'),
      width: 120,
    )
  ];

  List<DialogButton> buttons2 = [
    DialogButton(
      child: Text(
        "CLOSE",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () => Navigator.pop(context),
      width: 120,
    )
  ];

  try {
    String imageData;

      imageData=jsonEncode(data);




    print(imageData);

    //for type specific url

      url=BASE_URL + "/api/job/UploadEngineerSign";

    formData = FormData.fromMap(
        {"Id": driverCheckId,"VINChasis":vimChasis,"DVRNo":dvrNo,"Millage":millage,"DateCompleted":compDate,"CableNotes":cableNotes,"Cables":cables,"ImageData":imageData,"Files": mapEntry});
    formData.files.addAll(mapEntry);
    var response = await dio.post(url,
      data: formData,
    );
    print(response.data.toString());
    messageTitle = "Success";
    message = response.data;

    Alert(
        context: context,
        title: messageTitle,
        desc: message,
        buttons: buttons)
        .show();

    return true;

  } catch (e) {
    messageTitle = "Something went wrong!";
    message = "try again later";
    Alert(
        context: context,
        title: messageTitle,
        desc: message,
        buttons: buttons2)
        .show();
    print("PostIncidentImages Error" + e.toString());
    return false;
  }
}