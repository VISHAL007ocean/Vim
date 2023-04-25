import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/driver_checks/CreateDriverCheckQuestions.dart';

Future postDriversChecksImages(BuildContext context, var id,
    List<CreateDriverCheckAnswers> answers, List<dynamic> questions) async {
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
  var driverCheckId = id.toString();

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
        {"Id": driverCheckId, "ImageData": imageData, "Files": mapEntry});
    formData.files.addAll(mapEntry);
    var response = await dio.post(
      BASE_URL + "/api/driverchecks/UploadImages",
      data: formData,
    );
    print(response.data.toString());
    messageTitle = "Success";
    message = response.data["message"];
    Alert(
            context: context,
            title: messageTitle,
            desc: message,
            buttons: buttons)
        .show();
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

Future postFltChecksImages(BuildContext context, var id,
    List<CreateDriverCheckAnswers> answers, List<dynamic> questions) async {
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

          var fileNameString = fileName.replaceAll("/", "-");
          var imageIndexString  = fileNameString.split(".")[0];
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
            "imageIndex":imageIndex.toString(),
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
  var driverCheckId = id.toString();

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
        {"Id": driverCheckId, "ImageData": imageData, "Files": mapEntry});
    formData.files.addAll(mapEntry);
    var response = await dio.post(
      BASE_URL + "/api/fltchecks/UploadImages",
      data: formData,
    );
    print(response.data.toString());
    messageTitle = "Success";
    message = response.data["message"];
    Alert(
        context: context,
        title: messageTitle,
        desc: message,
        buttons: buttons)
        .show();
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

Future postDamageReportChecksImages(BuildContext context, var id,
    List<CreateDriverCheckAnswers> answers, List<dynamic> questions) async {
  String messageTitle;
  String message;
  List<dynamic> data = new List<dynamic>();
  List<MapEntry<String, MultipartFile>> mapEntry =
  new List<MapEntry<String, MultipartFile>>();
  FormData formData = FormData();

  int imageIndex = 0;
  var imageText = "0";

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
          var fileNameString = fileName.replaceAll("/", "-");
          var imageIndexString  = fileNameString.split(".")[0];
          imageText = imageIndexString;
          data.add({
            "ImageIndex": imageIndexString,//imageIndex.toString(),
            "QuestionId": question["questionId"],
            "QuestionTable": "Damage",
            "AgeType": "New",
            "FileName": fileName.replaceAll("/", "-")
          });
        }
        else {
          fileName =
              "Signature"+ " " + (j + 1).toString() + "." + fileExt;
           var fileNameString = fileName.replaceAll("/", "-");
           var imageIndexString  = fileNameString.split(".")[0];
           imageText = imageIndexString;
          //imageText = "$imageText 1";
           print("ImageText $imageText");
          data.add({
            "QuestionTable":"Damage",
            "AgeType":"Signature",
            "ImageIndex": imageIndexString,//imageIndex.toString(),
            "QuestionId": 0,
            "FileName": fileName.replaceAll("/", "-")
          });

        }

            print("----Map name $imageText");
            print("----Map Ex $fileExt");

        mapEntry.add(MapEntry(
            'Files',
            MultipartFile.fromBytes(imageData,
                filename: imageText)));

        // mapEntry.add(MapEntry(
        //     'Files',
        //     MultipartFile.fromBytes(imageData,
        //         filename: imageIndex.toString())));

        imageIndex++;
      }
    }
  }


  print("---data--");
  print(data);

  var dio = new Dio();

  var token;
  var damageCheckId = id.toString();

  await getToken().then((result) {
    token = result;
  });

  dio.options.headers = {
    "Authorization": "Bearer $token",
    "Content-Type": "multipart/form-data",
  };

  try {
    String imageData = jsonEncode(data);
    print(imageData);

    formData = FormData.fromMap(
        {"Id": damageCheckId, "ImageData": imageData, "Files": mapEntry});
    formData.files.addAll(mapEntry);
    print("$damageCheckId");
    print("$mapEntry");

    var response = await dio.post(
      BASE_URL + "/api/damagevehicle/UploadImages",
      data: formData,
    );
    print("/api/damagevehicle/UploadImages called");
    print(response.data.toString());


    // messageTitle = "Success";
    // message = response.data["message"];
    // Alert(
    //     context: context,
    //     title: messageTitle,
    //     desc: message,
    //     buttons: buttons)
    //     .show();
  } catch (e) {
    // messageTitle = "Something went wrong!";
    // message = e.response.data["message"];
    // Alert(
    //     context: context,
    //     title: messageTitle,
    //     desc: message,
    //     buttons: buttons)
    //     .show();
    // print("PostIncidentImages Error" + e.toString());
  }
}


// Future saveAnswer(BuildContext context, var damageCheckId,
//     List<CreateDriverCheckAnswers> answers, List<dynamic> questions)  async {
//
//   Map<String, dynamic> questionDict = {'QuestionId': 0,};
//   List<dynamic> saveAnswerArray = [];
//   for(var i = 0; i < answers.length; i++){
//     questionDict["QuestionId"] = answers[i].questionId;
//     questionDict["Answer"] = answers[i].answer;
//     questionDict["DamageVehicleCheckId"] =   damageCheckId;
//     questionDict["Type"] =   "Driver Mobile";
//     saveAnswerArray.add(questionDict);
//   }
//   String jsonBody = jsonEncode(saveAnswerArray);
//   print(jsonBody);
//
//   var token;
//   var dio = new Dio();
//
//
//   //  var dc = damageAnswerCheck.toJson();
//   // var body = json.encode(dc);
//   var body = jsonBody;
//   setState(() {
//     isSending = true;
//   });
//
//   print(body);
//
//   await getToken().then((result) {
//     token = result;
//   });
//
//   dio.options.headers = {
//     "Accept": "application/json",
//     "Authorization": "Bearer $token",
//   };
//
//   try {
//     // int damageCheckId;
//
//     var response =
//     await dio.post(BASE_URL + "/api/damagevehicle/SaveAnswer", data: body);
//
//     print('Response');
//     print(response.data.toString());
//     print('/api/damagevehicle/SaveAnswer');
//
//     setState(() {
//       isSending = false;
//     });
//   } catch (e) {
//     setState(() {
//       isSending = false;
//     });
//     print(e.toString());
//   }
// }