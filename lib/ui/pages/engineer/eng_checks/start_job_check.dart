import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_settings/card_settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:vim_mobile/common/api_functions/engineer/job_questions/job_questions.dart';
import 'package:vim_mobile/common/api_functions/engineer/job_questions/postjobchecksimages.dart';
import 'package:vim_mobile/common/custom_widgets/divider.dart';
import 'package:vim_mobile/common/custom_widgets/error_message.dart';
import 'package:vim_mobile/common/custom_widgets/title_icon.dart';
import 'package:vim_mobile/common/functions/getLocation.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/common/functions/getUserId.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/engineer/job_list/job_list_model.dart';
import 'package:vim_mobile/models/engineer/job_question_answers/job_ans_model.dart';
import 'package:vim_mobile/ui/components/pageComponents/CardSettingsGenericWidget.dart';
import 'package:vim_mobile/ui/components/pageComponents/SwitchWidget.dart'
    as VimSwitch;
import 'package:vim_mobile/ui/components/pageComponents/VimCardSettingsHeader.dart';
import 'package:vim_mobile/ui/components/pageComponents/VimCardSettingsInt.dart';
import 'package:vim_mobile/ui/components/pageComponents/VimCardSettingsSwitch.dart';
import 'package:vim_mobile/ui/components/pageComponents/VimCardSettingsText.dart';
import 'package:vim_mobile/ui/components/pageComponents/goHome.dart';
import 'package:vim_mobile/ui/components/pageComponents/loadingSplash.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';
import 'package:vim_mobile/ui/pages/engineer/eng_checks/inapp_webview.dart';

class StartJoBCheckPage extends StatefulWidget {
  final String type;
  final int jobID;
  final int compID;
  final JobListModel jobListModel;
  final bool isPending;

  const StartJoBCheckPage(
      {Key key,
      this.type,
      this.jobID,
      this.compID,
      this.jobListModel,
      this.isPending})
      : super(key: key);

  @override
  _StartJoBCheckState createState() =>
      new _StartJoBCheckState(type, jobID, compID, jobListModel);
}

class _StartJoBCheckState extends State<StartJoBCheckPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  GlobalKey<SfSignaturePadState> _signaturePadEngKey = GlobalKey();

  final String type;
  final int jobID;
  final int compID;
  final JobListModel jobListModel;
  int vehicleId;
  int companyId;
  String userId;
  SharedPreferences _preferences;
  List<dynamic> questions;
  List<dynamic> cablequestions;
  ImagePicker picker = ImagePicker();
  var showSignaturePad = false;
  var showSignaturePadCustomer = false;
  MediaQueryData mediaQuery;
  bool isCustSigned = false;
  bool isEngSigned = false;

  //Needs to be instantiated with blank values as build is called before initialisation.
  /*CreateDriverChecks driverCheck = new CreateDriverChecks(
      0, "", "", "", 0, 0, new List<CreateDriverCheckAnswers>());*/

  JobQuestionAnswersModel jobCheck =
      new JobQuestionAnswersModel(questionAnswer: <QuestionAnswer>[]);
  JobQuestionAnswersModel jobCableCheck =
      new JobQuestionAnswersModel(questionAnswer: <QuestionAnswer>[]);
  TextEditingController vinChasisController = TextEditingController();
  TextEditingController millageController = TextEditingController();
  TextEditingController dvrNoController = TextEditingController();
  TextEditingController completionDateController = TextEditingController();
  TextEditingController cableNotesController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  Position position;
  bool isLoading = true;
  bool isSending = false;
  bool isCable = false;
  double discHeight = 200.0;
  QuestionAnswer signatureQA = QuestionAnswer();

  String backTitle = "Are you sure?";
  String completionDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String backMessage =
      "Leaving this page will result in you losing all progress of your current job information.";

  _StartJoBCheckState(this.type, this.jobID, this.compID, this.jobListModel);

  bool handleEngOnDrawStart() {
    isEngSigned = true;

    return false;
  }

  bool handleCustOnDrawStart() {
    isCustSigned = true;

    return false;
  }

  @override
  void initState() {
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
    //driverCheck = null;
    jobCheck = null;
    isLoading = true;
    isSending = false;
  }

  onImagePressed(QuestionAnswer answer, String type) async {
    //Navigator.pop(context);
    PickedFile imageFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.rear);
    File pFile = File(imageFile.path);
    ImageFiles imgData = ImageFiles();
    imgData.imgType = type;
    imgData.image = pFile;

    setState(() {
      answer.images.add(pFile);
      answer.imageData.add(imgData);
      print("image Picker ========");
    });
  }

  initialise() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _preferences = preferences;

    print("==job id========$jobID==");

    if (type == "M") {
      questions = await getRepairQuestions(compID, jobID: jobID);
    } else if (type == "I") {
      questions = await getInstallationQuestions(compID);
    } else if (type == "D") {
      questions = await getDeInstallationQuestions(compID);
    }
    // questions = await getInstallationQuestions(companyId);
    cablequestions = widget.isPending
        ? await getCableQuestions(compID, jobID: jobID)
        : await getCableQuestions(compID);
    userId = await getUserId();
    var pos = await getLocation().catchError((Object error) {
      print(error.toString());
    });
    position = pos.runtimeType == Position ? pos : new Position();
    initialiseJobCheck();

    print("======questions====${questions}");

    list = [];
    List<QuestionAnswer> answers = jobCheck.questionAnswer;

    if (questions != null) {
      for (var i = 0; i < questions.length; i++) {
        //Instantiate and populate answers
        if (answers.length < questions.length) {
          /*QuestionAnswer answer = new QuestionAnswer(
              questions[i]["questionId"], questions[i]["questionType"], "", "");*/

          QuestionAnswer answer = new QuestionAnswer(
              questionId: questions[i]["questionId"],
              jobId: jobID,
              notes: "",
              answer: questions[i]["groupName"] == "Simcard" ? "" : "No",
              qty: 0.0,
              serialNumber: "",
              imgdisable: questions[i]["imgdisable"]);
          answer.images = new List<File>();
          answers.add(answer);
        }

        //Display the group header if the group name is different to the previous question
        if (list.length == 0 ||
            questions[i]["groupName"] != questions[i - 1]["groupName"]) {
          list.add(new VimCardSettingsHeader(
            // ADDADD
            label: questions[i]["groupName"],
            labelAlign: TextAlign.center,
            color: vimPrimary,
          ));
        }

        QuestionTypes type = QuestionTypes.values[questions[i]["questionType"]];

        if (widget.isPending) {
          answers[i].notes = questions[i]["notes"];
          answers[i].serialNumber = questions[i]["serialNumber"];
          answers[i].answer = questions[i]["answer"];
          answers[i].qty = double.parse(questions[i]["qty"].toString());
          answers[i].images = [];
        }

        //Question body
        list.add(processQuestionType(questions[i]["question"], type, answers[i],
            0, questions[i]["imgdisable"], questions[i]));

        print("================question====${questions[i]}");
        print("================ans====${answers[i].notes}");
        print("================ans====${answers[i].qty}");
        print("================ans====${answers[i].serialNumber}");
        print("================ans====${answers[i].answer}");

        list.add(questionDivider());
      }
    }
  }

  List<Widget> list = [];

  // init jobcheck
  initialiseJobCheck() {
    this.jobCheck =
        new JobQuestionAnswersModel(questionAnswer: <QuestionAnswer>[]);
    this.jobCableCheck =
        new JobQuestionAnswersModel(questionAnswer: <QuestionAnswer>[]);
    this.signatureQA = new QuestionAnswer();
    signatureQA.imageData = <ImageFiles>[];
    signatureQA.images = <File>[];
  }

  //for large image check
  largeImage(Image image, context) {
    Alert(
        context: context,
        type: AlertType.none,
        title: '',
        content: image,
        buttons: []).show();
  }

  //for processing UI
  CardSettingsWidget processQuestionType(String title, QuestionTypes type,
      QuestionAnswer answerController, int t, String img, Map questionMap) {
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
            VimCardSettingsText(
              labelAlign: TextAlign.center,
              contentOnNewLine: true,
              enabled: false,
              label: title,
            ),
            CardSettingsDatePicker(
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
        return VimCardSettingsText(
          hintText:
              answerController.imgdisable == "1" ? "Enter ${title}" : "Text",
          maxLength: 255,
          contentOnNewLine: true,
          keyboardType:
              title.contains("No") ? TextInputType.number : TextInputType.text,
          label: title,
          onChanged: (input) => {answerController.answer = input},
        );

      case QuestionTypes.image:
        return CardSettingsGenericWidget(
          children: [
            VimCardSettingsText(
              labelAlign: TextAlign.center,
              enabled: false,
              contentOnNewLine: true,
              label: title,
            ),
            ...imageWidget(answerController)
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
          VimSwitch.CreateJobSwitch(
            controller: answerController,
            questionLabel: title,
            trueLabel: "Yes",
            falseLabel: "No",
            notesLabel: t == 0 ? "Notes" : "Qty.",
            hintText: "Required if question has failed.",
            numLines: 4,
            stateFunction: setState,
            imagesFunction: t == 0 ? imageWidget : null,
            hideOnFail: true,
          )
        ]);
      default:
        return VimSwitch.CreateJobSwitch(
          controller: answerController,
          questionLabel: title,
          trueLabel: "Yes",
          falseLabel: "No",
          notesLabel: t == 0 ? "Notes" : "Qty.",
          hintText: t == 0 ? "Text" : "Enter Qty",
          numLines: t == 0 ? 4 : 1,
          stateFunction: setState,
          imagesFunction: imageWidget,
          hideOnFail: false,
          // controllerForText: TextEditingController(
          //     text: (widget.isPending) ? questionMap["notes"] : ""),
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

  // for processing add image UI TODO change done
  List<Widget> imageWidget(QuestionAnswer answerController) {
    List<Widget> list = [];
    bool multiples =
        answerController.images != null && answerController.images.length > 0;

    if (answerController.images != null) {
      answerController.imageData.forEach((image) => {
            list.add(ListTile(
              leading: Image(image: FileImage(image.image)),
              title: AutoSizeText(
                image.imgType == "Serial"
                    ? 'Tap to enlarge part image with Sr.No.'
                    : 'Tap to enlarge ${image.imgType} part image',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              trailing: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () {
                  setState(() {
                    answerController.images.remove(image.image);
                    answerController.imageData.remove(image);
                  });
                },
              ),
              onTap: () =>
                  largeImage(Image(image: FileImage(image.image)), context)
                      .show,
            ))
          });
    }

    list.add(CardSettingsButton(
        backgroundColor: vimPrimary,
        label: multiples ? "Add Another Old Part Image" : "Add Old Part Image",
        textColor: Theme.of(context).cardColor,
        onPressed: () => onImagePressed(answerController, "Old")));
    list.add(SizedBox(
      height: 10,
    ));
    list.add(CardSettingsButton(
        backgroundColor: vimPrimary,
        label: multiples ? "Add Another New Part Image" : "Add New Part Image",
        textColor: Theme.of(context).cardColor,
        onPressed: () => onImagePressed(answerController, "New")));
    list.add(SizedBox(
      height: 10,
    ));
    list.add(CardSettingsButton(
        backgroundColor: vimPrimary,
        label: multiples
            ? "Add Another Image With Sr.No."
            : "Add Part Image With Sr.No.",
        textColor: Theme.of(context).cardColor,
        onPressed: () => onImagePressed(answerController, "Serial")));

    return list;
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
                image.imgType == "Eng_Sign"
                    ? "Tap to enlarge Engineer Signature"
                    : "Tap to enlarge Customer Signature",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
              trailing: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () {
                  setState(() {
                    answerController.images.remove(image.image);
                    answerController.imageData.remove(image);
                  });
                },
              ),
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
            ? signaturePadEng(context, answerController, "Eng_Sign")
            : Container()
      ],
    ));
    list.add(CardSettingsButton(
        backgroundColor: vimPrimary,
        label: (showSignaturePad ? "Cancel" : "Add Engineer Signature Image "),
        textColor: Theme.of(context).cardColor,
        onPressed: () {
          setState(() {
            showSignaturePad = !showSignaturePad;
          });
        }));
    list.add(SizedBox(
      height: 10,
    ));
    list.add(Column(
      children: [
        showSignaturePadCustomer
            ? signaturePad(context, answerController, "Cust_Sign")
            : Container()
      ],
    ));
    list.add(CardSettingsButton(
        backgroundColor: vimPrimary,
        label: (showSignaturePadCustomer
            ? "Cancel"
            : "Add Customer Signature Image "),
        textColor: Theme.of(context).cardColor,
        onPressed: () {
          setState(() {
            showSignaturePadCustomer = !showSignaturePadCustomer;
          });
        }));

    return list;
  }

  Widget signaturePad(
      BuildContext context, QuestionAnswer answer, String type) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: vimPrimary)),
          child: SfSignaturePad(
            key: _signaturePadKey,
            minimumStrokeWidth: 1,
            maximumStrokeWidth: 3,
            strokeColor: Colors.black,
            backgroundColor: Colors.white,
            onDrawStart: handleCustOnDrawStart,
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
                  _signaturePadKey.currentState.clear();
                  setState(() {
                    isCustSigned = false;
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
                if (isCustSigned) {
                  ui.Image img = await _signaturePadKey.currentState.toImage();

                  await getImageFileFromImage(img, type).then((file) {
                    ImageFiles imgData = ImageFiles();
                    imgData.imgType = type;
                    imgData.image = file;

                    setState(() {
                      answer.images.add(file);
                      answer.imageData.add(imgData);
                      if (type.contains("Eng")) {
                        showSignaturePad = !showSignaturePad;
                      } else {
                        showSignaturePadCustomer = !showSignaturePadCustomer;
                      }
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
                      if (type.contains("Eng")) {
                        showSignaturePad = !showSignaturePad;
                      } else {
                        showSignaturePadCustomer = !showSignaturePadCustomer;
                      }
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

  //for validation TODO change done
  validate(BuildContext context) {
    bool error = false;
    List<String> errorList = new List<String>();

    for (var i = 0; i < questions.length; i++) {
      var answer = jobCheck.questionAnswer
          .firstWhere((a) => a.questionId == questions[i]["questionId"]);

      if (questions[i]["required"] == true && answer.answer == "") {
        errorList.add(questions[i]["question"] + ".");
      }
      if (questions[i]["groupName"] == "Installation" &&
          answer.answer == "Yes" &&
          questions[i]["imgdisable"] == "0") {
        if (answer.images.length > 0) {
          var o = 0;
          var n = 0;
          var s = 0;
          answer.imageData.forEach((element) {
            if (element.imgType == "Old") {
              o = o + 1;
            }
            if (element.imgType == "New") {
              n = n + 1;
            }
            if (element.imgType == "Serial") {
              s = s + 1;
            }
          });
          if (o == 0) {
            error = true;
            errorList.add(questions[i]["question"] + ". Old Image is required");
          } else if (n == 0) {
            error = true;
            errorList.add(questions[i]["question"] + ". New Image is required");
          } else if (s == 0) {
            error = true;
            errorList
                .add(questions[i]["question"] + ". Sr.No. Image is required");
          } else {
            continue;
          }
        } else {
          errorList.add(questions[i]["question"] +
              ". Old,New and Image with Sr.No. is required");
        }
      }
      if (questions[i]["groupName"] == "Simcard" &&
          questions[i]["required"] == true &&
          answer.answer == "") {
        errorList.add(questions[i]["question"] + ".");
      }
      /* else if (answer.answer == "false" &&
          (answer.notes == null || answer.notes == "")) {
        error = true;
        errorList
            .add("Pass/Fail questions must include notes if they have failed.");
      }*/
    }

    // validation for cable

    if (isCable) {
      Iterable<QuestionAnswer> contain = [];
      for (var i = 0; i < cablequestions.length; i++) {
        var answer = jobCableCheck.questionAnswer
            .firstWhere((a) => a.questionId == cablequestions[i]["questionId"]);

        contain = jobCableCheck.questionAnswer
            .where((element) => element.answer == "Yes");

        if (cablequestions[i]["required"] || answer.answer == "Yes") {
          if (answer.qty > 0.0) {
          } else {
            error = true;
            errorList.add(cablequestions[i]["question"] + ". Qty ");
          }

          if (answer.images.length > 0) {
            var o = 0;
            var n = 0;
            var s = 0;
            answer.imageData.forEach((element) {
              if (element.imgType == "Old") {
                o = o + 1;
              }
              if (element.imgType == "New") {
                n = n + 1;
              }
              if (element.imgType == "Serial") {
                s = s + 1;
              }
            });
            if (o == 0) {
              error = true;
              errorList.add(
                  cablequestions[i]["question"] + ". Old Image is required");
            } else if (n == 0) {
              error = true;
              errorList.add(
                  cablequestions[i]["question"] + ". New Image is required");
            } else if (s == 0) {
              error = true;
              errorList.add(
                  cablequestions[i]["question"] + ". Sr.No. Image is required");
            } else {
              continue;
            }
          } else {
            errorList.add(cablequestions[i]["question"] +
                ". Old,New and Image with Sr.No. is required");
          }
        }

        /* else if (answer.answer == "false" &&
          (answer.notes == null || answer.notes == "")) {
        error = true;
        errorList
            .add("Pass/Fail questions must include notes if they have failed.");
      }*/
      }
      if (contain.isEmpty) {
        error = true;
        errorList.add("Please select at least one cable. ");
      }
      /* if(cableNotesController.text.isEmpty){
        error=true;
        errorList.add("VIN/Chasis, Milage, Completion Date are required");
      }*/
    }

// validation for signature  CLOSE BY
//     if (signatureQA.images.isEmpty || signatureQA.images == null) {
//       error = true;
//       errorList.add("Signature images are required" + ".");
//     } else if (signatureQA.images.length > 0) {
//       var c = 0;
//       var e = 0;
//       signatureQA.imageData.forEach((element) {
//         if (element.imgType == "Cust_Sign") {
//           c = c + 1;
//         }
//         if (element.imgType == "Eng_Sign") {
//           e = e + 1;
//         }
//       });
//
//       if (c == 0) {
//         error = true;
//         errorList.add("Customer Signature is required");
//       } else if (e == 0) {
//         error = true;
//         errorList.add("Engineer Signature is required");
//       }
//     }

    if (formKey.currentState.validate()) {
    } else {
      error = true;

      errorList.add("VIN/Chasis, Mileage, Completion Date are required");
    }

    if (error) {
      String plural = errorList.length > 1 ? "Fields" : "Field";

      errorMessage(context, errorList, plural + " Required");
    } else {
      sendJobChecks(context);
    }
  }

//for save TODO change pending
  //todo first in row
  sendJobChecks(BuildContext context) async {
    var isSuccess = false;
    String messageTitle;
    String message;
    var url;
    var token;
    var dio = new Dio();
    //var dc = jobCheck.questionAnswer.to;
    var body = json.encode(jobCheck.questionAnswer);
    bool sendSign = false;

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
      int jobDoneId;

      //for type specific url
      if (type == "M") {
        url = BASE_URL + "/api/maintenancerepair/Create";
      } else if (type == "I") {
        url = BASE_URL + "/api/installation/Create";
      } else if (type == "D") {
        url = BASE_URL + "/api/deinstallation/Create";
      }

      var response = await dio.post(url, data: body);
      print(response.data.toString());
      /* if(type=="M"){
        jobDoneId = response.data["maintenancerepairId"];
      }else if(type=="I"){
        jobDoneId = response.data["installationId"];
      }else if(type=="D"){
        jobDoneId = response.data["deinstallationId"];
      }*/

      jobDoneId = jobID;

      if (isCable) {
        sendJobCableChecks(context);
      } else {
        List<QuestionAnswer> imageAnswers = jobCheck.questionAnswer.toList();
        var val = await postJobChecksImages(
            context, jobDoneId, imageAnswers, questions, type);
        setState(() {
          sendSign = val;
        });

        if (sendSign) {
          List<QuestionAnswer> sign = <QuestionAnswer>[];
          sign.add(signatureQA);
          isSuccess = await postSignatureImages(
              context,
              jobDoneId,
              sign,
              questions,
              vinChasisController.text,
              completionDate,
              millageController.text,
              dvrNoController.text,
              cableNotesController.text ?? "",
              isCable ? "Yes" : "No");
        }
        if (isSuccess) {
          vinChasisController.text = "";
          millageController.text = "";
          dvrNoController.text = "";
          cableNotesController.text = "";
          isCable = false;
          completionDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
          _signaturePadKey = GlobalKey();
          _signaturePadEngKey = GlobalKey();
        }
        setState(() {
          isSending = false;
        });
      }
    } catch (e) {
      messageTitle = "Something went wrong!";
      message = e.toString();

      setState(() {
        isSending = false;
      });
      Alert(
              context: context,
              title: messageTitle,
              desc: message,
              buttons: buttons2)
          .show();
      print(e.toString());
    }
  }

  //if isCable then in row
  sendJobCableChecks(
    BuildContext context,
  ) async {
    String messageTitle;
    String message;
    var isSuccess = false;
    var url;
    var token;
    var dio = new Dio();
    bool sendSign = false;
    //var dc = jobCheck.questionAnswer.to;

    var body2 = json.encode(jobCableCheck.questionAnswer);
    setState(() {
      isSending = true;
    });

    print(body2);

    await getToken().then((result) {
      token = result;
    });

    dio.options.headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
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
      int jobDoneId;
      url = BASE_URL + "/api/installationcable/Create";

      var response = await dio.post(url, data: body2);

      print(response.data.toString());

      jobDoneId = jobID;

      //for QA and cable image upload
      List<QuestionAnswer> imageAnswers = jobCheck.questionAnswer.toList();

      jobCableCheck.questionAnswer.forEach((element) {
        imageAnswers.add(element);
      });

      cablequestions.forEach((element) {
        questions.add(element);
      });

      var val = await postJobChecksImages(
          context, jobDoneId, imageAnswers, questions, type);
      setState(() {
        sendSign = val;
      });

      if (sendSign) {
        List<QuestionAnswer> sign = <QuestionAnswer>[];
        sign.add(signatureQA);
        var isSuccess = await postSignatureImages(
            context,
            jobDoneId,
            sign,
            questions,
            vinChasisController.text,
            completionDate,
            millageController.text,
            dvrNoController.text,
            cableNotesController.text,
            isCable ? "Yes" : "No");
      }

      setState(() {
        isSending = false;
      });

      if (isSuccess) {
        vinChasisController.text = "";
        millageController.text = "";
        dvrNoController.text = "";
        cableNotesController.text = "";
        isCable = false;
        completionDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
        _signaturePadKey = GlobalKey();
        _signaturePadEngKey = GlobalKey();
      }
    } catch (e) {
      setState(() {
        isSending = false;
      });
      messageTitle = "Something went wrong!";
      message = e.toString();

      Alert(
              context: context,
              title: messageTitle,
              desc: message,
              buttons: buttons2)
          .show();
      print(e.toString());
    }
  }

  // for UI TODO change done
  List<Widget> getGroups() {
    /*if (cablequestions != null) {
      for (var i = 0; i < cablequestions.length; i++) {
        //Instantiate and populate answers
        if (answers.length < cablequestions.length) {
          CreateDriverCheckAnswers answer = new CreateDriverCheckAnswers(
              cablequestions[i]["questionId"], cablequestions[i]["questionType"], "", "");
          answer.images = new List<File>();

          answers.add(answer);
        }

        //Display the group header if the group name is different to the previous question
        if (list.length == 0 ||
            cablequestions[i]["groupName"] != cablequestions[i - 1]["groupName"]) {
          list.add(new VimCardSettingsHeader(
            label: cablequestions[i]["groupName"],
            labelAlign: TextAlign.center,
            color: vimPrimary,
          ));
        }

        QuestionTypes type = QuestionTypes.values[cablequestions[i]["questionType"]];

        //Question body
        list.add(
            processQuestionType(cablequestions[i]["question"], type, answers[i]));

        list.add(questionDivider());
      }
    }*/

    setState(() {});
    return list;
  }

  List<Widget> getCableGroups() {
    List<Widget> list = [];
    List<QuestionAnswer> answers = jobCableCheck.questionAnswer;

    if (cablequestions != null) {
      for (var i = 0; i < cablequestions.length; i++) {
        //Instantiate and populate answers
        if (answers.length < cablequestions.length) {
          QuestionAnswer answer = new QuestionAnswer(
              questionId: cablequestions[i]["questionId"],
              jobId: jobID,
              notes: "",
              answer: "No",
              qty: 0.0,
              serialNumber: "",
              imgdisable: "0");
          answer.images = new List<File>();

          answers.add(answer);
        }

        //Display the group header if the group name is different to the previous question
        if (list.length == 0 ||
            cablequestions[i]["groupName"] !=
                cablequestions[i - 1]["groupName"]) {
          list.add(new VimCardSettingsHeader(
            label: cablequestions[i]["groupName"],
            labelAlign: TextAlign.center,
            color: vimPrimary,
          ));
        }

        QuestionTypes type =
            QuestionTypes.values[cablequestions[i]["questionType"]];

        //Question body
        list.add(processQuestionType(cablequestions[i]["question"], type,
            answers[i], 1, "0", cablequestions[i]));

        list.add(questionDivider());
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    return WillPopScope(
        onWillPop: () => goList(context, backTitle, backMessage, () => {}),
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    goList(context, backTitle, backMessage, () => {});
                  }),
              backgroundColor: Colors.white,
              title: titleIcon(),
              centerTitle: true,
            ),
            body: isLoading
                ? loadingSplash(context, "Getting job questions", "Please wait")
                : (isSending
                    ? loadingSplash(
                        context, "Saving job information", "Please wait")
                    : ListView(children: [
                        CardSettings(showMaterialonIOS: true, children: [
                          CardSettingsSection(children: [
                            CardSettingsGenericWidget(children: [
                              SizedBox(
                                height: 5,
                              ),
                              jobInfo(jobListModel, context),
                              SizedBox(
                                height: 5,
                              ),
                              linkButtons(jobListModel),
                              SizedBox(
                                height: 5,
                              ),
                              ...getGroups(),
                              additionalQuestions(context),
                              VimCardSettingsSwitch(
                                  label: "Cable Installation",
                                  trueLabel: "Yes",
                                  falseLabel: "No",
                                  onChanged: (value) {
                                    setState(() {
                                      isCable = value ? true : false;
                                    });
                                  }),
                              if (isCable) showCableData(),
                              ...signImageWidget(signatureQA, context),
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
                                      isSending ? {} : validate(context))
                            ])
                          ])
                        ])
                      ]))));
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

  Widget jobInfo(JobListModel model, BuildContext context) {
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
    return Container(
      //  height: discHeight,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: vimPrimary,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Job Information",
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Reference:',
                        style: TextStyle(
                            fontSize: 16,
                            height: 1,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                    Text(
                        " " +
                            model.reference.toString().replaceAll("Job :", ""),
                        style: TextStyle(
                          fontSize: 15,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Job Type:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                      textAlign: TextAlign.end,
                      textScaleFactor: 1.0,
                    ),
                    Text(
                      model.jobType.contains("Main")
                          ? " Maintenance/Repair"
                          : ' ${model.jobType}',
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
                      'Location:',
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
                          model.location != null ? ' ${model.location}' : " -",
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
                    Text('Job Date:',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textAlign: TextAlign.end),
                    Text(' ${model.jobCreatedTime}',
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
                    Text('Status:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                    Text(' ${model.status}',
                        style: TextStyle(fontSize: 15),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('Vehicle No:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                    Text(' ${model.vehicle}',
                        style: TextStyle(fontSize: 15),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                model.make != null
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  ' ${model.make != null ? model.make : ""} ${model.model != null ? model.model : ""} ${model.colour != null ? model.colour : ""}',
                                  style: TextStyle(fontSize: 15),
                                  textScaleFactor: 1.0,
                                  textAlign: TextAlign.end),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      )
                    : Container(),
                Row(
                  children: [
                    Text('Site Contact:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                    Text(' ${model.siteContact}',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('Company:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                    Text(' ${model.company}',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('Depot:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                    Text(' ${model.depotName}',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      width: mediaQuery.size.width / 2.2,
                      child: Text(
                        'Site Contact Email:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                    InkWell(
                      child: Container(
                        width: mediaQuery.size.width / 2.2,
                        child: Text(
                          ' ${model.siteContactEmail}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent,
                            height: 1,
                          ),
                          textScaleFactor: 1.0,
                        ),
                      ),
                      onTap: () {
                        UrlLauncher.launch('mailto:${model.siteContactEmail}');
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      width: mediaQuery.size.width / 2.2,
                      child: Text(
                        'Site Contact Phone:',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                    InkWell(
                      child: Text(
                        ' ${model.siteContactPhone}',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueAccent,
                          height: 1,
                        ),
                      ),
                      onTap: () {
                        UrlLauncher.launch('tel:+${model.siteContactPhone}');
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text('Job Request:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                    Text(' ${model.jobRequest}',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      width: mediaQuery.size.width / 2.2,
                      child: Text(
                        'Defect Reference Number:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                    Container(
                      width: mediaQuery.size.width / 2.2,
                      child: Text(
                        ' ${model.defectReferenceNumber}',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      width: mediaQuery.size.width / 2.2,
                      child: Text(
                        'Work Order Number:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                    Container(
                      width: mediaQuery.size.width / 2.2,
                      child: Text(
                        ' ${model.workOrderNumber}',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ],
                ),
                /*SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                        'Job Raised:',
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end),
                    Text(
                        model.jobRaised!=null?' ${model.jobRaised}':" -",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.end),
                  ],
                ),*/
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notes:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end),
                    Expanded(
                      child: Text(
                        model.notes != null ? ' ${model.notes}' : " -",
                        style: TextStyle(
                          fontSize: 15,
                          height: 1,
                        ),
                        // textScaleFactor: 1.0,
                        // maxLines: 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget linkButtons(JobListModel model) {
    print("JOB INFO=== " + jsonEncode(model));

    return Container(
      child: Column(
        children: [
          if (jobListModel.previousJob > 0)
            InkWell(
              child: Container(
                height: 35,
                color: vimPrimary,
                child: Center(
                  child: Text(
                    "Engineer History",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HeadlessInAppWebViewExampleScreen(
                              url: model.previousJobUrl,
                              title: "Engineer History",
                            )));
              },
            ),
          Container(
            height: 5,
            color: Colors.white,
          ),
          // if(jobListModel.previousIncident>0)InkWell(
          //   child: Container(
          //     height: 35,
          //     color: vimPrimary,
          //     child: Center(
          //       child: Text("Incident History",style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 16,
          //         fontWeight: FontWeight.bold,
          //       ),),
          //     ),
          //   ),
          //   onTap: () async {
          //
          //
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => HeadlessInAppWebViewExampleScreen(url: model.previousIncidentUrl,title:"Incident History",)));
          //
          //
          //
          //   },
          // ),
        ],
      ),
    );
  }

  Widget additionalQuestions(BuildContext context) {
    mediaQuery = MediaQuery.of(context);

    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CardSettingsText(
              hintText: "Enter VIN/Chassis ",
              label: "VIN/Chassis",
              contentOnNewLine: true,
              controller: vinChasisController,
              onChanged: (val) {},
              validator: (value) => value == null ? 'field required' : null,
            ),
            SizedBox(
              height: 5,
            ),
            CardSettingsText(
              hintText: "Enter Mileage",
              label: "Mileage",
              contentOnNewLine: true,
              controller: millageController,
              onChanged: (val) {},
              validator: (value) => value == null ? 'field required' : null,
            ),
            SizedBox(
              height: 5,
            ),
            CardSettingsText(
              hintText: "Enter  DVR No",
              label: "DVR No",
              contentOnNewLine: true,
              controller: dvrNoController,
              onChanged: (val) {},
            ),
            SizedBox(
              height: 5,
            ),
            CardSettingsDatePicker(
              label: "Completion Date",
              dateFormat: DateFormat("dd-MM-yyyy"),
              firstDate: DateTime(DateTime.now().year, DateTime.now().month - 1,
                  DateTime.now().day),
              labelWidth: 140.0,
              contentAlign: TextAlign.center,
              fieldPadding: EdgeInsets.all(2.0),
              lastDate: DateTime.now(),
              onChanged: (input) {
                setState(() {
                  completionDate = DateFormat("yyyy-MM-dd").format(input);
                });
              },
              validator: (value) => value == null ? 'field required' : null,
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }

  Widget showCableData() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          ...getCableGroups(),
          SizedBox(
            height: 5,
          ),
          CardSettingsParagraph(
            hintText: "Enter Cable Notes",
            label: "Cable Notes",
            contentOnNewLine: true,
            maxLength: 255,
            numberOfLines: 4,
            controller: cableNotesController,
            onChanged: (val) {
//TODO Cable notes
            },
            validator: (value) => value == null ? 'field required' : null,
          ),
        ],
      ),
    );
  }
}
