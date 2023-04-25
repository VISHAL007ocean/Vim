import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_settings/card_settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:vim_mobile/common/api_functions/driver_checks/getDriverCheckQuestions.dart';
import 'package:vim_mobile/common/api_functions/driver_checks/postDriverChecksImages.dart';
import 'package:vim_mobile/common/custom_widgets/divider.dart';
import 'package:vim_mobile/common/custom_widgets/error_message.dart';
import 'package:vim_mobile/common/custom_widgets/title_icon.dart';
import 'package:vim_mobile/common/functions/getLocation.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/common/functions/getUserId.dart';
import 'package:vim_mobile/common/functions/getVehicles.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/driver_checks/CreateDriverCheck.dart';
import 'package:vim_mobile/models/driver_checks/CreateDriverCheckQuestions.dart';
import 'package:vim_mobile/models/engineer/job_question_answers/job_ans_model.dart';
import 'package:vim_mobile/models/engineer/vehicle/vehiclelistmodel.dart';
import 'package:vim_mobile/ui/components/pageComponents/CardSettingsGenericWidget.dart';
import 'package:vim_mobile/ui/components/pageComponents/SwitchWidget.dart'
    as VimSwitch;
import 'package:vim_mobile/ui/components/pageComponents/VimCardSettingsHeader.dart';
import 'package:vim_mobile/ui/components/pageComponents/VimCardSettingsInt.dart';
import 'package:vim_mobile/ui/components/pageComponents/VimCardSettingsText.dart';
import 'package:vim_mobile/ui/components/pageComponents/goHome.dart';
import 'package:vim_mobile/ui/components/pageComponents/loadingSplash.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';

class DamageReportList extends StatefulWidget {
  @override
  _DamageReportListState createState() => new _DamageReportListState();
}

class _DamageReportListState extends State<DamageReportList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int vehicleId;
  int companyId;
  String userId;
  String name;
  SharedPreferences _preferences;
  List<dynamic> questions;
  ImagePicker picker = ImagePicker();
  TextEditingController locationController = TextEditingController();
  String location;

  //Needs to be instantiated with blank values as build is called before initialisation.
  // CreateFltChecks driverCheck = new CreateFltChecks(
  //     0, "", "", "", 0, 0, new List<CreateDriverCheckAnswers>(),"","");

  CreateDamageChecks damageCheck = new CreateDamageChecks(0, "", "", "", 0, 0,
      "", "", depotId, 0, '', new List<CreateDriverCheckAnswers>());

  TextEditingController driverNameController;
  Position position;
  bool isLoading = true;
  bool isSending = false;

  String backTitle = "Are you sure?";
  String backMessage =
      "Leaving this page will result in you losing all progress of your current flt check.";
  VehicleLocalModel localModel = VehicleLocalModel();
  MediaQueryData mediaQuery;
  double discHeight = 200.0;

  var showSignaturePad = false;
  var showSignaturePadCustomer = false;
  bool isCustSigned = false;
  bool isEngSigned = false;
  QuestionAnswer signatureQA = QuestionAnswer();
  GlobalKey<SfSignaturePadState> _signaturePadEngKey = GlobalKey();

  @override
  void initState() {
    print("damage report Page loaded");
    locationController = TextEditingController();
    driverNameController = TextEditingController();
    initialise().then((result) {
      setState(() {
        isLoading = false;
        isSending = false;
      });
    });
    super.initState();
  }

  //Used to clear any variables upon the closing of the view
  clearVars() {
    questions.clear();
    vehicleId = null;
    companyId = null;
    userId = null;
    position = null;
    damageCheck = null;
    isLoading = true;
    isSending = false;
  }

  onImagePressed(CreateDriverCheckAnswers answer) async {
    //Navigator.pop(context);
    PickedFile imageFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 30,
        preferredCameraDevice: CameraDevice.rear);
    File pFile = File(imageFile.path);

    print(pFile.lengthSync());
    setState(() {
      answer.images.add(pFile);
    });
  }

  initialise() async {
    //vehCheck
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    _preferences = await SharedPreferences.getInstance();
    vehicleId = int.parse(_preferences.getString('CurrentVehicleId'));
    companyId = int.parse(_preferences.getString('CurrentCompanyId'));
    depotId = int.parse(_preferences.getString('CurrentDepotId'));

    damageCheck.damageVehicleCheckCode =
        _preferences.getString('CurrentCompanyCode');
    print("My data");
    print(_preferences.getString('CurrentCompanyCode'));
    String vehInfo = _preferences.getString("CurrentVehicleInfo");

    localModel = VehicleLocalModel.fromJson(jsonDecode(vehInfo));
    //questions = await getFltCheckQuestions(companyId);
    questions = await getDamageReportCheckQuestions(companyId);
    damageCheck.companyId = companyId;
    print(questions);
    userId = await getUserId();
    // var pos = await getLocation().catchError((Object error) {
    //   print(error.toString());
    // });
    // position = pos.runtimeType == Position ? pos : new Position();
    // final co =new Coordinates(position.latitude,position.longitude);
    // var addresses = await Geocoder.local.findAddressesFromCoordinates(co);
    // var first = addresses.first;
    // location=first.addressLine;
    // locationController.text=location;
    bool locationEnabled = true;
    var pos = await getLocation().catchError((Object error) {
      print(error.toString());
      print('location error');
      locationEnabled = false;
    });

    if (locationEnabled == false) {
      position = pos.runtimeType == Position ? pos : new Position();
      location = ""; //first.addressLine;
      locationController.text = "";
    } else {
      position = pos.runtimeType == Position ? pos : new Position();
      final co = new Coordinates(position.latitude, position.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(co);
      var first = addresses.first;
      location = first.addressLine;
      locationController.text = location;
    }

    initialiseDriversCheck();
    _getUser();
  }

  _getUser() async {
    await getRole().then((value) async {
      if (value == "Driver") {
        await getFullName().then((result) {
          setState(() {
            if (result != null) {
              name = result;
            } else {
              name = "";
            }
          });
        });
      } else if (value == "Engineer") {
        await getName().then((result) {
          setState(() {
            if (result != null) {
              name = result;
            } else {
              name = "";
            }
          });
        });
      }
    });
    driverNameController.text = name;
  }

  initialiseDriversCheck() {
    this.damageCheck = new CreateDamageChecks(
        vehicleId,
        '',
        userId,
        "",
        position.latitude ?? 0,
        position.longitude ?? 0,
        location,
        location,
        depotId,
        companyId,
        '',
        new List<CreateDriverCheckAnswers>());
    //TODO
    this.signatureQA = new QuestionAnswer();
    signatureQA.imageData = <ImageFiles>[];
    signatureQA.images = <File>[];
  }

  largeImage(Image image, context) {
    Alert(
        context: context,
        type: AlertType.none,
        title: '',
        content: image,
        buttons: []).show();
  }

  DateTime getDay() {
    DateTime now = DateTime.now();
    var date = DateTime(now.year, now.month, now.day - 7);
    return date;
  }

  CardSettingsWidget processQuestionType(String title, QuestionTypes type,
      CreateDriverCheckAnswers answerController) {
    var theme = Theme.of(context);
    var style = theme.textTheme.subtitle1;
    style = style.copyWith(color: theme.disabledColor);

    switch (type) {
      case QuestionTypes.date:
        if (answerController.answer == null || answerController.answer == "") {
          answerController.answer =
              DateFormat("yyyy-MM-dd").format(DateTime.now());
        }
        return CardSettingsGenericWidget(children: [
          VimCardSettingsText(
            labelAlign: TextAlign.center,
            contentOnNewLine: true,
            enabled: false,
            label: title,
          ),
          CardSettingsDatePicker(
            label: "Date",
            dateFormat: DateFormat("dd-MM-yyyy"),
            onChanged: (input) => {
              answerController.answer = DateFormat("yyyy-MM-dd").format(input)
            },
          )
        ]);

      case QuestionTypes.datetime:
        if (answerController.answer == null || answerController.answer == "") {
          answerController.answer =
              DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
        }
        return CardSettingsGenericWidget(
          children: [
            // VimCardSettingsText(
            //   labelAlign: TextAlign.center,
            //   contentOnNewLine: true,
            //   enabled: false,
            //   label: title,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                AutoSizeText(
                  //question text
                  title,
                  style: TextStyle(
                      color: theme.disabledColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  maxLines: 1,
                ),
              ],
            ),
            CardSettingsDatePicker(
              showMaterialonIOS: false,
              firstDate: getDay(),
              lastDate: DateTime.now(),
              initialValue: DateTime.now(),
              label: "Date",
              dateFormat: DateFormat("dd-MM-yyyy"),
              onChanged: (input) => {
                answerController.answer = dateTimeBuilder(
                    input.toString().split(" ")[0], answerController.answer)
              },
            ),
            CardSettingsTimePicker(
                initialValue: TimeOfDay.now(),
                showMaterialonIOS: false,
                label: "Time",
                onChanged: (input) => {
                      answerController.answer = dateTimeBuilder(
                          input.toString().split(" ")[0],
                          answerController.answer,
                          input.hour,
                          input.minute)
                    })
          ],
        );

      case QuestionTypes.freeText:
        if (title == "Company Name") {
          var companyName = _preferences.getString('companyName');
          return VimCardSettingsText(
            hintText: companyName,
            maxLength: 255,
            contentOnNewLine: true,
            label: title,
            initialValue: companyName,
            enabled: false,
            onChanged: (input) => {answerController.answer = input},
            //  onChanged: (input) => {answerController.answer = input},
          );
        }

        if (title == "Depot Name") {
          var depotName = _preferences.getString('depotName');
          print("=======21/4/23===Depot Name==$depotName");
          return VimCardSettingsText(
            // hintText: localModel,
            hintText: depotName,
            maxLength: 255,
            contentOnNewLine: true,
            label: title,
            initialValue: depotName,
            enabled: false,
            onChanged: (input) => {answerController.answer = input},
            //  onChanged: (input) => {answerController.answer = input},
          );
        }

        return VimCardSettingsText(
          hintText: "Text",
          maxLength: 255,
          contentOnNewLine: true,
          label: title,
          onChanged: (input) => {answerController.answer = input},
          //  onChanged: (input) => {answerController.answer = input},
        );

      case QuestionTypes.image:
        return CardSettingsGenericWidget(
          children: [
            // VimCardSettingsText(
            //   labelAlign: TextAlign.center,
            //   enabled: true,
            //   contentOnNewLine: true,
            //   label: title,
            //   onChanged:(input) => {answerController.answer = input},
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                AutoSizeText(
                  //question text
                  title,
                  style: TextStyle(
                      color: theme.disabledColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  maxLines: 1,
                ),
              ],
            ),
            SizedBox(height: 10),
            ...imageWidget(answerController),
            SizedBox(height: 10),
          ],
        );

      case QuestionTypes.longText:
        return CardSettingsParagraph(
          hintText: "Text",
          maxLength: 255,
          label: title,
          contentOnNewLine: true,
          onChanged: (input) => {answerController.answer = input},
        );

      case QuestionTypes.number:
        return VimCardSettingsInt(
          contentOnNewLine: true,
          label: title,
          hintText: "Text",
          onChanged: (input) => {answerController.answer = input.toString()},
        );
      case QuestionTypes.passFail:
        if (answerController.answer == "" || answerController.answer == null) {
          answerController.answer = "Fail";
        }
        return new CardSettingsGenericWidget(children: [
          VimSwitch.CreateDriverSwitch(
            controller: answerController,
            questionLabel: title,
            trueLabel: "Pass",
            falseLabel: "Fail",
            notesLabel: "Notes",
            hintText: "Required if question has failed.",
            numLines: 4,
            stateFunction: setState,
            imagesFunction: imageWidget,
            hideOnFail: true,
          )
        ]);
      case QuestionTypes.YesNoUnsure:
        String _yesNoValue = "Yes";
        return CardSettingsGenericWidget(children: [
          Row(children: <Widget>[
            SizedBox(
              width: 10,
            ),
            AutoSizeText(
              title,
              style: TextStyle(
                  color: theme.disabledColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          buildCardWidget(
            DropdownButtonFormField<String>(
              //underline: const SizedBox(),
              focusColor: Colors.white,
              isExpanded: true,
              items: <String>['Yes', 'No', 'Unsure'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text(_yesNoValue),
              value: _yesNoValue,
              decoration: InputDecoration(border: InputBorder.none),
              onChanged: (newValue) {
                setState(
                  () {
                    _yesNoValue = newValue;
                    print("value changed");
                    answerController.answer = _yesNoValue;
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ]);

      case QuestionTypes.ThirdPartyMySelfUnsure:
        return VimSwitch.CreateDriverDropdown(
          controller: answerController,
          questionLabel: title,
          trueLabel: "",
          falseLabel: "",
          notesLabel: "",
          hintText: "",
          numLines: 4,
          stateFunction: setState,
          imagesFunction: imageWidget,
          hideOnFail: false,
        );
      //  String _dropValue = "Third-Party";
      //
      //  return   CardSettingsGenericWidget(children: [
      //    Row(children: <Widget>[
      //      SizedBox(
      //        width: 10,
      //      ),
      //
      //      AutoSizeText(
      //        title,
      //        style: TextStyle(
      //            color: theme.disabledColor,
      //            fontWeight: FontWeight.bold,
      //            fontSize: 16),
      //
      //      ),
      //    ]),
      //    SizedBox(height: 10,),
      //    buildCardWidget(DropdownButton<String>(
      //      underline: const SizedBox(),
      //      focusColor: Colors.white,
      //      isExpanded: true,
      //      items: <String>['Third-Party', 'My-Self', 'Unsure'].map((String value) {
      //        return DropdownMenuItem<String>(
      //          value: value,
      //          child: Text(value),
      //        );
      //      }).toList(),
      //      hint: Text(_dropValue),
      //      onChanged: (value) {
      //        setState(
      //              () {
      //                _dropValue = value;
      //            answerController.answer = _dropValue;
      //            //  widget?.onChanged(_dropDownValue);
      //          },
      //        );
      //      },
      //
      //    )
      //    ),
      //    SizedBox(height: 10,),
      //
      //  ]);
      default:
        return VimSwitch.CreateDamageSwitch(
          controller: answerController,
          questionLabel: title,
          trueLabel: "Yes",
          falseLabel: "No",
          notesLabel: "Notes",
          hintText: "Text",
          numLines: 4,
          stateFunction: setState,
          imagesFunction: imageWidget,
          hideOnFail: false,
        );
    }
  }

  String dateTimeBuilder(String input, String answer, [int hour, int minute]) {
    var split = answer.split(" ");
    bool date = hour == null && minute == null;
    var newSection = date
        ? input
        : (hour == null ? "00" : hour.toString()) +
            ":" +
            (minute == null ? "00" : minute.toString()) +
            ":00";
    String newAnswer = "";

    int section = date ? 0 : 1;
    split[section] = newSection;
    newAnswer = split.join(" ");

    return newAnswer;
  }

  List<Widget> imageWidget(CreateDriverCheckAnswers answerController) {
    List<Widget> list = [];
    bool multiples =
        answerController.images != null && answerController.images.length > 0;

    if (answerController.images != null) {
      answerController.images.forEach((image) => {
            list.add(ListTile(
              leading: Image(image: FileImage(image)),
              title: AutoSizeText(
                'Tap to enlarge',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              trailing: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () {
                  setState(() {
                    answerController.images.remove(image);
                  });
                },
              ),
              onTap: () =>
                  largeImage(Image(image: FileImage(image)), context).show,
            ))
          });
    }

    list.add(CardSettingsButton(
        backgroundColor: vimPrimary,
        label: multiples ? "Add Another Image" : "Add Image",
        textColor: Theme.of(context).cardColor,
        onPressed: () => onImagePressed(answerController)));

    return list;
  }

  validate() {
    bool error = false;
    List<String> errorList = new List<String>();

    //List<dynamic> saveAnswerArray = [];

    for (var i = 0; i < questions.length; i++) {
      var answer = damageCheck.driverChecksAnswers
          .firstWhere((a) => a.questionId == questions[i]["questionId"]);

      if (questions[i]["required"] && answer.answer == "") {
        if (answer.type == QuestionTypes.image.index &&
            answer.images.length > 0) {
          continue;
        }
        error = true;
        errorList.add(questions[i]["question"] + ".");
      } else if (answer.type == QuestionTypes.passFail.index &&
          answer.answer == "false" &&
          (answer.notes == null || answer.notes == "")) {
        error = true;
        errorList
            .add("Pass/Fail questions must include notes if they have failed.");
      }
    }

    //If Driver name is blank, display error message. At this point they would have been initialised so no need for null check.
    if (damageCheck.driverName == "") {
      error = true;
      errorList.add("Driver Name.");
    }
    if (signatureQA.images.isEmpty || signatureQA.images == null) {
      error = true;
      errorList.add("Signature images are required" + ".");
    }

    if (error) {
      String plural = errorList.length > 1 ? "Fields" : "Field";

      errorMessage(context, errorList, plural + " Required");
    } else {
      // print('final question');
      // for (var i = 0; i < questions.length; i++) {
      //   print(questions[i]);
      // }

      sendDamageChecks();
    }
  }

  sendDamageChecks() async {
    print('/api/damagevehicle/Create called');
    //damageCheck.depotId = 65;
    //  damageCheck.damageVehicleCheckCode = "HT";
    damageCheck.damageVehicleCheckCode = _preferences.getString('companyCode');

    var token;
    var dio = new Dio();
    damageCheck.currLocation = locationController.text;

    var dc = damageCheck.toJson();
    var body = json.encode(dc);
    setState(() {
      isSending = true;
    });

    //print(body);

    await getToken().then((result) {
      token = result;
    });

    dio.options.headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      int damageCheckId;

      var response =
          await dio.post(BASE_URL + "/api/damagevehicle/Create", data: body);

      print('Response');
      print(response.data.toString());
      print('/api/damagevehicle/Create called');

      damageCheckId = response.data.toInt();
      print(damageCheckId);
      //driverCheckId = 1;

      //Make a list of answers that have images, then Post Images
      List<CreateDriverCheckAnswers> imageAnswers = damageCheck
          .driverChecksAnswers
          .where((dca) =>
              dca.type == QuestionTypes.image.index ||
              dca.type == QuestionTypes.passFail.index)
          .toList();

      //TODO
      CreateDriverCheckAnswers img = CreateDriverCheckAnswers(0, 0, "", "");

      List<File> images = [];
      images.addAll(signatureQA.images);
      img.images = images;

      imageAnswers.add(img);

      await postDamageReportChecksImages(
          context, damageCheckId, imageAnswers, questions);
      await saveAnswer(
        damageCheckId,
      );

      setState(() {
        isSending = false;
      });
    } catch (e) {
      setState(() {
        isSending = false;
      });
      print(e.toString());
    }
  }

  saveAnswer(damageCheckId) async {
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

    List<dynamic> saveAnswerArray = [];
    for (var i = 0; i < questions.length; i++) {
      Map<String, dynamic> questionDict = {
        'QuestionId': 0,
      };

      var answer = damageCheck.driverChecksAnswers
          .firstWhere((a) => a.questionId == questions[i]["questionId"]);
      questionDict["QuestionId"] = answer.questionId;
      questionDict["Answer"] = answer.answer;
      questionDict["DamageVehicleCheckId"] = damageCheckId;
      questionDict["Type"] = "Driver Mobile";
      saveAnswerArray.add(questionDict);
    }
    String jsonBody = jsonEncode(saveAnswerArray);
    print(jsonBody);

    var token;
    var dio = new Dio();

    //  var dc = damageAnswerCheck.toJson();
    // var body = json.encode(dc);
    var body = jsonBody;
    setState(() {
      isSending = true;
    });

    print(body);

    await getToken().then((result) {
      token = result;
    });

    dio.options.headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      // int damageCheckId;

      var response = await dio.post(BASE_URL + "/api/damagevehicle/SaveAnswer",
          data: body);

      print('Response');
      print(response.data.toString());
      print('/api/damagevehicle/SaveAnswer');

      setState(() {
        isSending = false;
        Alert(
          context: context,
          title: 'Success',
          desc: 'Damage report submitted successfully',
          buttons: buttons,
          closeFunction: () => Navigator.pushNamed(context, '/dashboard'),
        ).show();
      });
    } catch (e) {
      setState(() {
        isSending = false;
      });
      print(e.toString());
    }
  }

  List<Widget> getGroups() {
    List<Widget> list = [];
    List<CreateDriverCheckAnswers> answers = damageCheck.driverChecksAnswers;

    if (questions != null) {
      for (var i = 0; i < questions.length; i++) {
        //Instantiate and populate answers
        if (answers.length < questions.length) {
          //   print("groups print");
          // print(questions[i]);
          CreateDriverCheckAnswers answer = new CreateDriverCheckAnswers(
              questions[i]["questionId"], questions[i]["questionType"], "", "");
          if (questions[i]["questionType"] == 7) {
            answer = new CreateDriverCheckAnswers(questions[i]["questionId"],
                questions[i]["questionType"], "No", "");
          }
          if (questions[i]["questionType"] == 8) {
            answer = new CreateDriverCheckAnswers(questions[i]["questionId"],
                questions[i]["questionType"], "Yes", "");
          }
          if (questions[i]["questionType"] == 9) {
            answer = new CreateDriverCheckAnswers(questions[i]["questionId"],
                questions[i]["questionType"], "ThirdParty", "");
          }
          if (questions[i]["question"] == 'Depot Name') {
            var companyName = _preferences.getString('depotName');
            answer = new CreateDriverCheckAnswers(questions[i]["questionId"],
                questions[i]["questionType"], companyName, "");
          }
          if (questions[i]["question"] == 'Company Name') {
            var companyName = _preferences.getString('companyName');
            answer = new CreateDriverCheckAnswers(questions[i]["questionId"],
                questions[i]["questionType"], companyName, "");
          }
          // CreateDriverCheckAnswers answer = new CreateDriverCheckAnswers(
          //     questions[i]["questionId"], 0, "Fail", "");
          answer.images = new List<File>();

          answers.add(answer);
        }

        //Display the group header if the group name is different to the previous question
        if (list.length == 0 ||
            questions[i]["groupName"] != questions[i - 1]["groupName"]) {
          list.add(new VimCardSettingsHeader(
            label: questions[i]["groupName"],
            labelAlign: TextAlign.center,
            color: vimPrimary,
          ));
        }

        QuestionTypes type = QuestionTypes.values[questions[i]["questionType"]];
        //  QuestionTypes type = QuestionTypes.values[6];

        //Question body
        list.add(
            processQuestionType(questions[i]["question"], type, answers[i]));

        list.add(questionDivider());
      }
    }
    print(list);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => goHome(context, backTitle, backMessage, () => {}),
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    goHome(context, backTitle, backMessage, () => {});
                  }),
              backgroundColor: Colors.white,
              title: titleIcon(),
              centerTitle: true,
            ),
            body: isLoading
                ? loadingSplash(context,
                    "Getting damage report check questions", "Please wait")
                : (isSending
                    ? loadingSplash(
                        context, "Sending damage report check", "Please wait")
                    : ListView(children: [
                        CardSettings(showMaterialonIOS: true, children: [
                          CardSettingsSection(children: [
                            CardSettingsGenericWidget(children: [
                              VimCardSettingsHeader(
                                label: "Vehicle Information",
                                labelAlign: TextAlign.center,
                                color: vimPrimary,
                              ),
                              vehInfo(localModel, context),
                              VimCardSettingsHeader(
                                label: "General Information",
                                labelAlign: TextAlign.center,
                                color: vimPrimary,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // CardSettingsText(
                              //   hintText: "Text",
                              //   // decoration: InputDecoration(
                              //   //   contentPadding: EdgeInsets.all(15.0),
                              //   //   border: OutlineInputBorder(
                              //   //     borderSide: BorderSide(color: Color(0xFF56122f), width: 1.0),
                              //   //   ),
                              //   //   focusedBorder: OutlineInputBorder(
                              //   //     borderSide: BorderSide(color: Color(0xFF56122f), width: 1.0),
                              //   //   ),
                              //   //   enabledBorder: OutlineInputBorder(
                              //   //     borderSide: BorderSide(color: Color(0xFF56122f), width: 1.0),
                              //   //   ),
                              //   //
                              //   //   hintText: "location",
                              //   //   isDense: true,
                              //   // ),
                              //   label: "Driver Name",
                              //   contentOnNewLine: true,
                              //   controller: driverNameController,
                              //   onChanged: (val) =>
                              //   {damageCheck.driverName = val},
                              // ),
                              CardSettingsGenericWidget(children: [
                                Row(children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ),
                                  AutoSizeText(
                                    //question text
                                    "Driver Name",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    maxLines: 1,
                                  ),
                                ]),
                                //text form
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0,
                                      right: 12,
                                      top: 5,
                                      bottom: 10),
                                  child: TextFormField(
                                    //internal padding in form
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15.0),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF56122f),
                                            width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF56122f),
                                            width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF56122f),
                                            width: 1.0),
                                      ),
                                      hintText: "Driver Name",
                                      isDense: true,
                                    ),
                                    autocorrect: true,
                                    enableSuggestions: true,

                                    controller: driverNameController,
                                    onChanged: (val) =>
                                        {damageCheck.driverName = val},
                                  ),
                                )
                              ]),
                              CardSettingsGenericWidget(children: [
                                Row(children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ),
                                  //adds icon
                                  Icon(
                                    FontAwesomeIcons.globe,
                                    color: Colors.black,
                                    size: 30.0,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  AutoSizeText(
                                    //question text
                                    "Location:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    maxLines: 1,
                                  ),
                                ]),
                                //text form
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0,
                                      right: 12,
                                      top: 5,
                                      bottom: 10),
                                  child: TextFormField(
                                    //internal padding in form
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15.0),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF56122f),
                                            width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF56122f),
                                            width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF56122f),
                                            width: 1.0),
                                      ),
                                      hintText: "location",
                                      isDense: true,
                                    ),
                                    autocorrect: true,
                                    enableSuggestions: true,
                                    readOnly: true,
                                    enabled: false,
                                    controller: locationController,
                                  ),
                                )
                              ]),
                              ...getGroups(),
                              ...signImageWidget(signatureQA, context),
                              if (questions.length > 0)
                                TextButton(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          AutoSizeText('SEND',
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.white)),
                                          const SizedBox(width: 10.0),
                                          Icon(
                                            Icons.send,
                                            color: Colors.white,
                                          ),
                                        ]),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                vimPrimary)),
                                    onPressed: () =>
                                        isSending ? {} : validate())
                            ])
                          ])
                        ])
                      ]))));
  }

  Widget vehInfo(VehicleLocalModel model, BuildContext context) {
    mediaQuery = MediaQuery.of(context);

    if (mediaQuery.size.height >= 700 && mediaQuery.devicePixelRatio >= 3.0) {
      discHeight = MediaQuery.of(context).size.height / 1.6;
    } else if (mediaQuery.size.height >= 700) {
      discHeight = MediaQuery.of(context).size.height / 1.9;
    } else if (mediaQuery.size.height <= 700) {
      discHeight = mediaQuery.size.height / 1.3;
    }

    print("Height${mediaQuery.size.height}");
    print("Aspect Ratio${mediaQuery.devicePixelRatio}");
    damageCheck.registration = model.registration;
    // damageCheck.damageVehicleCheckCode = model.companyCode;

    return Container(
      //  height: discHeight,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Registration:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                      textAlign: TextAlign.end,
                      textScaleFactor: 1.0,
                    ),
                    Text(
                      model.registration,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1,
                      ),
                      textAlign: TextAlign.end,
                      textScaleFactor: 1.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Make:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                      textAlign: TextAlign.end,
                      textScaleFactor: 1.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4.0),
                      width: 200,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          model.make != null ? model.make : "-",
                          maxLines: 2,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('Model:',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textAlign: TextAlign.end),
                    Text(model.model != null ? model.model : "-",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1,
                        ),
                        textAlign: TextAlign.end),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('Colour:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                    Text(model.colour != null ? model.colour : "-",
                        style: TextStyle(fontSize: 15),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                /*Row(
                  children: [
                    Text(
                        'Vehicle No:',
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,height: 1,),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                    Text(
                        ' ${model.vehicle}',
                        style: TextStyle(fontSize: 15),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> signImageWidget(
      QuestionAnswer answerController, BuildContext context) {
    List<Widget> list = [];

    bool multiples =
        answerController.images != null && answerController.images.length > 0;

    if (answerController.images != null) {
      answerController.imageData.forEach((image) => {
            list.add(ListTile(
              leading: Image(image: FileImage(image.image)),
              title: AutoSizeText(
                image.imgType == "Sign"
                    ? "Tap to enlarge Signature"
                    : "Tap to enlarge Signature",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
              // trailing: GestureDetector(
              //   child: Icon(Icons.delete),
              //   onTap: () {
              //     setState(() {
              //       answerController.images.remove(image.image);
              //       answerController.imageData.remove(image);
              //     });
              //   },
              // ),
              onTap: () =>
                  largeImage(Image(image: FileImage(image.image)), context)
                      .show,
            ))
          });
    }

    list.add(SizedBox(
      height: 10,
    ));
    list.add(Column(
      children: [
        showSignaturePad
            ? signaturePadEng(context, answerController, "Sign")
            : Container()
      ],
    ));

    if (answerController.images.length == 0) {
      list.add(CardSettingsButton(
          backgroundColor: vimPrimary,
          label: (showSignaturePad ? "Cancel" : "Add Signature Image "),
          textColor: Theme.of(context).cardColor,
          onPressed: () {
            setState(() {
              showSignaturePad = !showSignaturePad;
            });
          }));
    }

    return list;
  }

  Widget signaturePadEng(
      BuildContext context, QuestionAnswer answer, String type) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: vimPrimary)),
          child: SfSignaturePad(
            key: _signaturePadEngKey,
            minimumStrokeWidth: 1,
            maximumStrokeWidth: 3,
            strokeColor: Colors.black,
            backgroundColor: Colors.white,
            onDrawStart: handleEngOnDrawStart,
          ),
          height: 200,
          width: 300,
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                child: Container(
                  height: 35,
                  color: vimPrimary,
                  child: Center(
                    child: Text(
                      "Clear",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                ),
                onTap: () {
                  _signaturePadEngKey.currentState.clear();
                  setState(() {
                    isEngSigned = false;
                  });
                },
              ),
            ),
            Container(
              width: 2,
              color: Colors.white,
            ),
            Expanded(
                child: InkWell(
              child: Container(
                height: 35,
                color: vimPrimary,
                child: Center(
                  child: Text(
                    "Save Signature",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              onTap: () async {
                if (isEngSigned) {
                  ui.Image img =
                      await _signaturePadEngKey.currentState.toImage();

                  await getImageFileFromImage(img, type).then((file) {
                    ImageFiles imgData = ImageFiles();
                    imgData.imgType = type;
                    imgData.image = file;

                    setState(() {
                      answer.images.add(file);
                      answer.imageData.add(imgData);

                      showSignaturePad = !showSignaturePad;
                    });
                  });
                } else {
                  var erList = ["Please Draw Signature on pad"];
                  //TODO error popup
                  errorMessage(context, erList, "");
                }
              },
            )),
          ],
        )
      ],
    );
  }

  bool handleEngOnDrawStart() {
    isEngSigned = true;

    return false;
  }

  Future<File> getImageFileFromImage(ui.Image asset, String type) async {
    var byteData = await asset.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final bytes = byteData.buffer.asUint8List();

    String tempPath = (await getTemporaryDirectory()).path;

    File file = File('$tempPath/$type.png');
    file.writeAsBytes(bytes, flush: true).then((value) {
      if (value != null) {
        return value;
      }
    });

    return file;
  }

  buildCardWidget(Widget child) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
        child: child,
      ),
    );
  }
}
