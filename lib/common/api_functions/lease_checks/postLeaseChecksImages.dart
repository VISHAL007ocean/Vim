import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/lease_checks/CreateLeaseCheckQuestions.dart';

Future postLeasesChecksImages(BuildContext context, var id,
    List<CreateLeaseCheckAnswers> answers, List<dynamic> questions) async {
  String messageTitle;
  String message;
  List<dynamic> data = new List<dynamic>();
  List<MapEntry<String, MultipartFile>> mapEntry =
      new List<MapEntry<String, MultipartFile>>();
  FormData formData = FormData();

  int imageIndex = 0;

  for (int i = 0; i < answers.length; i++) {
    //If question type is a pass/fail, then only images for failed questions will be sent.
    if (answers[i].images != null ||
        (answers[i].type == QuestionTypes.passFail.index &&
            (answers[i].answer != null ||
                answers[i].answer != "" ||
                answers[i].answer != "fail"))) {
      for (var j = 0; j < answers[i].images.length; j++) {
        String fileExt = answers[i].images[j].path.split(".").last;

        List<int> imageData = await answers[i].images[j].readAsBytes();
        String questionName;
        String fileName;
        if(answers[i].questionId!=0){
          var question = questions
              .firstWhere((k) => k["questionId"] == answers[i].questionId);


          questionName = question["question"];
          fileName =
              questionName   + " " + (j + 1).toString() + "." + fileExt;

          data.add({
            "imageIndex": imageIndex.toString(),
            "questionId": question["questionId"],
            "fileName": fileName.replaceAll("/", "-")
          });
        }
        else {
          fileName =
          "Signature"+ " " + (j + 1).toString() + "." + fileExt;
          data.add({
            "imageIndex": imageIndex.toString(),
            "questionId": 0,
            "fileName": fileName.replaceAll("/", "-")
          });
        }







        mapEntry.add(MapEntry(
            'Files',
            MultipartFile.fromBytes(imageData,
                filename: imageIndex.toString())));

        imageIndex++;
      }
    }
  }

  var dio = new Dio();

  var token;
  var leaseCheckId = id.toString();

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
    String imageData = jsonEncode(data);
    print(imageData);

    formData = FormData.fromMap(
        {"Id": leaseCheckId, "ImageData": imageData, "Files": mapEntry});
    formData.files.addAll(mapEntry);
    var response = await dio
        .post(
          BASE_URL + "/api/leasechecks/UploadImages",
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

onTimeout() {
  return new Response(
      statusCode: 408, data: "{message: 'Timed out, slow connection'}");
}
