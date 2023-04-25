import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_settings/card_settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vim_mobile/common/api_functions/lease_checks/postLeaseChecksImages.dart';
import 'package:vim_mobile/common/custom_widgets/error_message.dart';
import 'package:vim_mobile/common/custom_widgets/title_icon.dart';
import 'package:vim_mobile/common/functions/getLocation.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/common/functions/getUserId.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/EmergencyService/EmergencyServiceModel.dart';
import 'package:vim_mobile/models/engineer/job_question_answers/job_ans_model.dart';
import 'package:vim_mobile/models/lease_checks/CreateLeaseCheck.dart';
import 'package:vim_mobile/models/lease_checks/CreateLeaseCheckQuestions.dart';
import 'package:vim_mobile/ui/components/pageComponents/CardSettingsGenericWidget.dart';
import 'package:vim_mobile/ui/components/pageComponents/VimCardSettingsHeader.dart';
import 'package:vim_mobile/ui/components/pageComponents/goHome.dart';
import 'package:vim_mobile/ui/components/pageComponents/loadingSplash.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';

import '../../../common/functions/getDepotId.dart';
import '../../components/pageComponents/VimCardSettingsSwitch.dart'; //TODO SIGN

class EmergencyServicePage extends StatefulWidget {
  @override
  _EmergencyServicePage createState() => new _EmergencyServicePage();
}

class _EmergencyServicePage extends State<EmergencyServicePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int vehicleId;
  int companyId;
  String userId;
  int depotId = 0;
  int serviceId999 = 999;
  int serviceId100 = 100;
  SharedPreferences _preferences;
  List<dynamic> questions;
  ImagePicker picker = ImagePicker();

  List<File> emergencyImageList = new List<File>();

  //Needs to be instantiated with blank values as build is called before initialisation.
  //TODO
  CreateLeaseChecks leaseCheck = new CreateLeaseChecks(
      0, "", "", "", 0, 0, new List<CreateLeaseCheckAnswers>(), "", "");

  TextEditingController leaseNameController;
  //TODO
  TextEditingController locationController = TextEditingController();
  String location;

  Position position;
  bool isLoading = true;
  bool isSending = false;
  MediaQueryData mediaQuery;
  double discHeight = 200.0;

  String backTitle = "Are you sure?";
  String backMessage =
      "Leaving this page will result in you losing all progress of your current emergency request.";
  //TODO SIGN
  var showSignaturePad = false;
  var showSignaturePadCustomer = false;
  bool isCustSigned = false;
  bool isEngSigned = false;
  QuestionAnswer signatureQA = QuestionAnswer();
  GlobalKey<SfSignaturePadState> _signaturePadEngKey = GlobalKey();

  Future<List<EmergencyServiceModel>> emergencyServices;

  TextEditingController emergencyNotesController = TextEditingController();

  List<int> selectedService = [];

  initState() {
    super.initState();
    emergencyServices = _getEmergencyServices();

    initialise().then((result) {
      setState(() {
        isLoading = false;
        isSending = false;
      });
    });
    super.initState();
  }

  Future<List<EmergencyServiceModel>> _getEmergencyServices() async {
    var list;
    var userId;
    var token;

    await getToken().then((result) {
      token = result;
    });

    await getUserId().then((result) {
      userId = result;
    });

    final response = await http.get(
        Uri.parse(BASE_URL + '/api/emergencybutton/GetEmergencyService'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });

    var jsonData = json.decode(response.body);

    List<EmergencyServiceModel> emergencyServices = [];

    for (var i in jsonData) {
      EmergencyServiceModel driverCheck = EmergencyServiceModel(
          id: i["id"], serviceName: i["serviceName"], isSelected: false);

      if (driverCheck.serviceName == "999") {
        serviceId999 = driverCheck.id;
      }

      if (driverCheck.serviceName == "100") {
        serviceId100 = driverCheck.id;
      }

      emergencyServices.add(driverCheck);
    }

    print(jsonData.length);

    return emergencyServices;
  }

  //Used to clear any variables upon the closing of the view
  clearVars() {
    questions.clear();
    vehicleId = null;
    companyId = null;
    userId = null;
    position = null;
    leaseCheck = null;
    isLoading = true;
    isSending = false;
  }

  onImagePressed(List<File> fileList) async {
    //Navigator.pop(context);
    PickedFile imageFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 85);
    File pFile = File(imageFile.path);
    setState(() {
      fileList.add(pFile);
    });
  }

  initialise() async {
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
    initialiseLeasesCheck();
  }

  initialiseLeasesCheck() {
    //TODO
    this.leaseCheck = new CreateLeaseChecks(
        vehicleId,
        new DateTime.now().toString(),
        userId,
        "",
        position.latitude ?? 0,
        position.longitude ?? 0,
        new List<CreateLeaseCheckAnswers>(),
        location,
        location);
  }

  largeImage(Image image, context) {
    Alert(
        context: context,
        type: AlertType.none,
        title: '',
        content: image,
        buttons: []).show();
  }

  List<Widget> imageWidget(CreateLeaseCheckAnswers answerController) {
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
      // onPressed: () => onImagePressed(answerController),
    ));

    return list;
  }

  validate() {
    if (selectedService.isEmpty) {
      print(emergencyImageList);
      errorMessage(
          context, ["Please select a Emergency Service Request"], "Required");
    } else {
      // sendLeasesChecks();
      sendEmergencyPostResquest();
    }
  }

  postEmergencyService() async {
    var token;
    var dio = new Dio();
    List<dynamic> data = new List<dynamic>();
    FormData formData = FormData();
    List<MapEntry<String, MultipartFile>> mapEntry =
        new List<MapEntry<String, MultipartFile>>();

    await getToken().then((result) {
      token = result;
    });

    leaseCheck.currLocation = locationController.text;

    List<int> imageData =
        await FileImage(emergencyImageList[0]).file.readAsBytes();

    data.add({
      "ImageIndex": "imageText", //imageIndex.toString(),
      "QuestionId": 0,
      "QuestionTable": "",
      "AgeType": "New",
      "FileName": "imageText.png" //"imageText.png".replaceAll("/", "-")
    });

    mapEntry.add(MapEntry('Files',
        MultipartFile.fromBytes(imageData, filename: "imageText.png")));

    // String imageData = jsonEncode(data);
    print(token);

    try {
      dio.options.headers = {
        // "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      formData = FormData.fromMap({
        'Latitude': '0',
        'Longitude': '0',
        'RequestedLocation': 'Online',
        'RequestedService': '1,2,4',
        'Notes': 'Test Emergency Button',
        "ImageData": imageData,
        "Files": mapEntry
      });

      formData.files.addAll(mapEntry);
      print("$formData");

      var response = await dio
          .post(
            BASE_URL + "/api/emergencybutton/RequestEmergencyService",
            data: formData,
          )
          .timeout(new Duration(seconds: 300));
      print("jjk" + response.data);
      // messageTitle = "Success";
      // message = response.data;
      // if(check){
      //   Alert(
      //       context: context,
      //       title: messageTitle,
      //       desc: message,
      //       buttons: buttons)
      //       .show();
      // }

      print(response.data.toString());
    } on TimeoutException catch (e) {
      // messageTitle = "Slow connection!";
      // message =
      // "Images could not be sent due to a slow internet connection. Please try again later.";
      // Alert(
      //     context: context,
      //     title: messageTitle,
      //     desc: message,
      //     buttons: buttons)
      //     .show();
      print("PostEmergency Error" + e.toString());
    } catch (e) {
      // messageTitle = "Something went wrong!";
      // message = e.response.data["message"];
      // Alert(
      //     context: context,
      //     title: messageTitle,
      //     desc: message,
      //     buttons: buttons)
      //     .show();
      print("PostEmergency Error" + e.toString());
    }
  }

  sendEmergencyPostResquest() async {
    getDepId();

    List<DialogButton> buttons = [
      DialogButton(
        child: Text(
          "CLOSE",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          // Navigator.pop(context);
          Navigator.pushNamed(context, '/dashboard');
        },
        width: 120,
      )
    ];

    // try{
    var selectedVal = ((emergencyImageList.length > 0) ||
        (!selectedService.contains(999)) ||
        ((!selectedService.contains(100))));

    var token;

    await getToken().then((result) {
      token = result;
    });

    var headers = {'Authorization': 'Bearer $token'};

    final extension = (emergencyImageList.length > 0)
        ? p.extension(emergencyImageList[0].path)
        : "";

    var request = http.MultipartRequest('POST',
        Uri.parse(BASE_URL + '/api/emergencybutton/RequestEmergencyService'));

    request.fields.addAll({
      'Latitude': '${position.latitude}',
      'Longitude': '${position.longitude}',
      'RequestedLocation': locationController.text,
      'RequestedService': selectedService.join(','),
      'Notes': emergencyNotesController?.text ?? "",
      'DepotId': depotId.toString(),
      'ImageData': (emergencyImageList.length > 0)
          ? '[{"ImageIndex":"Emergency_Request","QuestionId":0,"QuestionTable":"","AgeType":"New","FileName":"Emergency_Request$extension" }]'
          : 'null'
    });

    // request.fields.addAll({
    //   'Latitude': '${position.latitude}',
    //   'Longitude': '${position.longitude}',
    //   'RequestedLocation': 'Online',
    //   'RequestedService': selectedService.join(','),
    //   'Notes': emergencyNotesController?.text ?? "",
    //   'ImageData': '[{"ImageIndex":${selectedVal ? 'Emergency_Request' : '' },"QuestionId":0,"QuestionTable":"","AgeType":"New","FileName":${selectedVal ? 'Emergency_Request$extension' : ""}]'
    // });
    // if(selectedVal)
    if (emergencyImageList.length > 0)
      request.files.add(await http.MultipartFile.fromPath(
          'Files', emergencyImageList[0].path,
          filename: 'Emergency_Request$extension'));
    request.headers.addAll(headers);

    print(request.fields);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var streamResponse = response.stream.bytesToString();
      print(await streamResponse);
      if (await streamResponse == "Success") {
        Alert(
          context: context,
          title: 'Success',
          desc: 'Emergency request submitted successfully',
          buttons: buttons,
          closeFunction: () => Navigator.pushNamed(context, '/dashboard'),
        ).show();
      } else {
        Alert(
          context: context,
          title: 'Failed',
          desc: 'Emergency request Failed',
          buttons: buttons,
          closeFunction: () => Navigator.pushNamed(context, '/dashboard'),
        ).show();
      }
    } else {
      print(response.reasonPhrase);
    }
    // }
    // catch(e){
    //   Alert(
    //         context: context,
    //         title: "Something went wrong!",
    //         desc: e.response.data["message"],
    //         buttons: buttons)
    //         .show();
    // }
  }

  getDepId() async {
    await getDepotId().then((result) {
      print(result);
      setState(() {
        depotId = int.parse(result) != null ? int.parse(result) : 0;
      });
    });
  }

  _launchCaller(String number) async {
    var url = "tel:$number";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  sendLeasesChecks() async {
    var token;
    var dio = new Dio();
    //TODO
    leaseCheck.currLocation = locationController.text;
    var dc = leaseCheck.toJson();
    var body = json.encode(dc);
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
      int leaseCheckId;

      var response =
          await dio.post(BASE_URL + "/api/leasechecks/Create", data: body);
      print(response.data.toString());
      leaseCheckId = response.data["leaseCheckId"];
      //leaseCheckId = 1;

      //Make a list of answers that have images, then Post Images
      List<CreateLeaseCheckAnswers> imageAnswers = leaseCheck.leaseChecksAnswers
          .where((dca) =>
              dca.type == QuestionTypes.image.index ||
              dca.type == QuestionTypes.passFail.index)
          .toList();
      //TODO SIGN
      CreateLeaseCheckAnswers img = CreateLeaseCheckAnswers(0, 0, "", "");

      List<File> images = [];
      images.addAll(signatureQA.images);
      img.images = images;
      imageAnswers.add(img);

      await postLeasesChecksImages(
          context, leaseCheckId, imageAnswers, questions);

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

  imageThumbs(List<File> fileList) {
    var list = <Widget>[];
    if (fileList.length > 0) {
      for (int i = 0; i < fileList.length; i++) {
        list.add(
          ListTile(
            leading: Image(image: FileImage(fileList[i])),
            title: AutoSizeText(
              'Tap to enlarge',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                setState(() {
                  fileList.removeAt(i);
                });
              },
            ),
            onTap: () =>
                largeImage(Image(image: FileImage(fileList[i])), context).show,
          ),
        );
      }
      return list;
    } else {
      return <Widget>[];
    }
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
                ? loadingSplash(
                    context, "Getting lease check questions", "Please wait")
                : (isSending
                    ? loadingSplash(
                        context, "Sending lease check", "Please wait")
                    : ListView(children: [
                        CardSettings(showMaterialonIOS: true, children: [
                          CardSettingsSection(children: [
                            CardSettingsGenericWidget(children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                        child: AutoSizeText('999',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.white)),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red)),
                                        onPressed: () async {
                                          setState(() {
                                            selectedService = [serviceId999];
                                          });

                                          sendEmergencyPostResquest();

                                          _launchCaller("999");
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                        child: AutoSizeText('100',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black)),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.yellow)),
                                        onPressed: () async {
                                          setState(() {
                                            selectedService = [serviceId100];
                                          });

                                          sendEmergencyPostResquest();

                                          _launchCaller("100");
                                        }),
                                  ),
                                  /*Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                              child: AutoSizeText('DEPOT',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white)),
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      vimPrimary)),
                              onPressed: () async {

                              }),
                        ),*/
                                ],
                              ),

                              VimCardSettingsHeader(
                                label: "Emergency Service request",
                                labelAlign: TextAlign.center,
                                color: vimPrimary,
                              ),

                              FutureBuilder(
                                  future: emergencyServices,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                      case ConnectionState.active:
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      default:
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              if ((snapshot.data[index]
                                                          .serviceName ==
                                                      "999") ||
                                                  (snapshot.data[index]
                                                          .serviceName ==
                                                      "100")) {
                                                return Container();
                                              } else {
                                                return VimCardSettingsSwitch(
                                                  label: snapshot
                                                      .data[index].serviceName,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      snapshot.data[index]
                                                          .isSelected = value;

                                                      if (selectedService
                                                          .contains(999)) {
                                                        selectedService
                                                            .remove(999);
                                                      }

                                                      if (selectedService
                                                          .contains(100)) {
                                                        selectedService
                                                            .remove(100);
                                                      }

                                                      if (selectedService
                                                          .contains(snapshot
                                                              .data[index]
                                                              .id)) {
                                                        selectedService.remove(
                                                            snapshot.data[index]
                                                                .id);
                                                      } else {
                                                        selectedService.add(
                                                            snapshot.data[index]
                                                                .id);
                                                      }
                                                    });
                                                  },
                                                );
                                              }
                                            });
                                    }
                                  }),

                              Divider(),

                              CardSettingsParagraph(
                                contentOnNewLine: true,
                                label: "Notes (if any)",
                                hintText: "Text",
                                controller: emergencyNotesController,
                              ),

                              CardSettingsSection(
                                  children: <CardSettingsWidget>[
                                    CardSettingsButton(
                                      label: 'PIC (one pic only if any)',
                                      textColor: Colors.white,
                                      onPressed: () {
                                        if (emergencyImageList.length == 0)
                                          onImagePressed(emergencyImageList);
                                      },
                                      backgroundColor: vimButtonColor,
                                    ),
                                    CardSettingsGenericWidget(children: [
                                      SizedBox(height: 5.0),
                                      ...imageThumbs(emergencyImageList)
                                    ])
                                  ]),

                              //TODO SIGN
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
                                  onPressed: () async {
                                    // isSending ? {} : validate()

                                    validate();
                                  })
                            ])
                          ])
                        ])
                      ]))));
  }

//TODO SIGN
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
}
