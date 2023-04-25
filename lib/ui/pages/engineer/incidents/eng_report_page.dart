import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_settings/card_settings.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vim_mobile/common/api_functions/incidents/postIncidentImages.dart';
import 'package:vim_mobile/common/custom_widgets/error_message.dart';
import 'package:vim_mobile/common/custom_widgets/title_icon.dart';
import 'package:vim_mobile/common/functions/getCompanyId.dart';
import 'package:vim_mobile/common/functions/getDepotId.dart';
import 'package:vim_mobile/common/functions/getLocation.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/common/functions/getUserId.dart';
import 'package:vim_mobile/common/functions/getVehicles.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/incidents/AccidentFault.dart';
import 'package:vim_mobile/models/incidents/CreateIncidentQuestions.dart';
import 'package:vim_mobile/models/incidents/CreateIncidents.dart';
import 'package:vim_mobile/ui/components/pageComponents/CardSettingsGenericWidget.dart';
import 'package:vim_mobile/ui/components/pageComponents/VimCardSettingsInt.dart';
import 'package:vim_mobile/ui/components/pageComponents/VimCardSettingsSwitch.dart';
import 'package:vim_mobile/ui/components/pageComponents/goHome.dart';
import 'package:vim_mobile/ui/components/pageComponents/loadingSplash.dart';
import 'package:vim_mobile/ui/components/pageComponents/multi_pages.dart';
import 'package:vim_mobile/ui/components/pageComponents/page_view_model.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';

TextEditingController driverNameController;
TextEditingController locationController;
TextEditingController driverNumberController;
TextEditingController initialCircumstanceController;
TextEditingController driverInjuredController;
TextEditingController driverVehicleDamagedController;
TextEditingController initialNotesController;
TextEditingController thirdPartyNameController;
TextEditingController thirdPartyNumberController;
TextEditingController thirdPartyAddressController;
TextEditingController thirdPartyInsurerController;
TextEditingController thirdPartyPolicyController;
TextEditingController thirdPartyInjuredController;
TextEditingController vehicleRegController;
TextEditingController vehicleMakeController;
TextEditingController vehicleModelController;
TextEditingController vehicleColourController;
TextEditingController vehicleDamageController;
TextEditingController vehicleNotesController;
TextEditingController propertyOwnerController;
TextEditingController propertyTelephoneController;
TextEditingController propertyAddressController;
TextEditingController propertyTypeController;
TextEditingController propertyDamageController;
TextEditingController propertyNotesController;
TextEditingController injuryNameController;
TextEditingController injuryNumberController;
TextEditingController injuryAddressController;
TextEditingController injuryCircumstanceController;
TextEditingController injuryNotesController;
TextEditingController regController;
TextEditingController emailController;
TextEditingController subjectController;

bool thirdPartyInjured = false;
bool vehicleDamaged = false;
bool propertyDamaged = false;
bool companyRepInjured = false;
bool driverInjured = false;
bool driverVehicleDamaged = false;
bool pageOneValid = false;
bool vehicleRelated = false;
bool propertyRelated = false;
bool injuryRelated = false;

String regString;
String coreOrAgency = "Core";
String banksmanUsed = "No";
String vehiclePassengerNumber;
String getInsurerName;
String getPolicyNumber;
String getInsurerTelephone;
String faultString = "Unspecified";
String getIncidentId;
String backTitle = "Are you sure?";
String backMessage =
    "Leaving this page will result in you losing all progress of your current report.";

int vehicleIdChosen;

Position position;

AccidentFaults faults = new AccidentFaults();

final format = DateFormat("yyyy-MM-dd");

final _picker = ImagePicker();

File video;
File videoFile;
List<File> companyImageList = new List<File>();
List<File> thirdPartyImageList = new List<File>();

DateTime dateTime;
DateTime driverDob;

stringBool(bool b) {
  if (b) {
    return 'Yes - ';
  } else {
    return 'No - ';
  }
}

clearVars() {
  vehicleRelated = false;
  propertyDamaged = false;
  injuryRelated = false;
  vehicleIdChosen = null;
  companyImageList.clear();
  thirdPartyImageList.clear();
}

class EngReportPage extends StatefulWidget {
  const EngReportPage({Key key}) : super(key: key);

  @override
  EngReportPageState createState() => EngReportPageState();
}

class EngReportPageState extends State<EngReportPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //VideoPlayerController _controller;
  //Future<void> _initializeVideoPlayerFuture;
  //final _flutterVideoCompress = FlutterVideoCompress();
  List<dynamic> data = List<dynamic>();
  int depotId;
  var token;

  @override
  void initState() {
    // Create an store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    // _controller = VideoPlayerController.network(
    //   '',
    // );
    // _initializeVideoPlayerFuture = _controller.initialize();
    // // Use the controller to loop the video.
    // _controller.setLooping(true);
    super.initState();
    initialise();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    //_controller.dispose();

    super.dispose();
  }

  void initialise() async {
    driverNameController = TextEditingController();
    locationController = TextEditingController();
    driverNumberController = TextEditingController();
    initialCircumstanceController = TextEditingController();
    driverInjuredController = TextEditingController();
    driverVehicleDamagedController = TextEditingController();
    initialNotesController = TextEditingController();
    thirdPartyNameController = TextEditingController();
    thirdPartyNumberController = TextEditingController();
    thirdPartyAddressController = TextEditingController();
    thirdPartyInsurerController = TextEditingController();
    thirdPartyPolicyController = TextEditingController();
    thirdPartyInjuredController = TextEditingController();
    vehicleRegController = TextEditingController();
    vehicleMakeController = TextEditingController();
    vehicleModelController = TextEditingController();
    vehicleColourController = TextEditingController();
    vehicleDamageController = TextEditingController();
    vehicleNotesController = TextEditingController();
    propertyOwnerController = TextEditingController();
    propertyTelephoneController = TextEditingController();
    propertyAddressController = TextEditingController();
    propertyTypeController = TextEditingController();
    propertyDamageController = TextEditingController();
    propertyNotesController = TextEditingController();
    injuryNameController = TextEditingController();
    injuryNumberController = TextEditingController();
    injuryAddressController = TextEditingController();
    injuryCircumstanceController = TextEditingController();
    injuryNotesController = TextEditingController();
    regController = TextEditingController();
    emailController = TextEditingController();
    subjectController = TextEditingController();
    driverDob = new DateTime(1985, 01, 01);
    data = await getVehicles(0);
    vehicleIdChosen = await getDefaultVehicleId(data);
    position = await getLocation();
    setState(() {});
  }

  // locationAlert() {
  //   Alert(
  //           context: context,
  //           title:
  //               "LOCATION DISABLED! Please ensure that your device's location is enabled before submitting an incident! You may have to restart the app.")
  //       .show();
  // }

  largeImage(Image image, context) {
    Alert(
        context: context,
        type: AlertType.none,
        title: '',
        content: image,
        buttons: []).show();
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

  onImagePressed(List<File> fileList) async {
    //Navigator.pop(context);
    PickedFile imageFile =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 30);
    File pFile = File(imageFile.path);
    setState(() {
      fileList.add(pFile);
    });
  }

  //KEEPING THIS CODE AS IT HAS EXAMPLES OF VIDEO SENDING IMPLEMENTATION.
  // _selectNine(context) {
  //   Alert(
  //     context: context,
  //     type: AlertType.none,
  //     title: "GIVE EVIDENCE",
  //     desc: "Select from your gallery or take an picture to give as evidence.",
  //     buttons: [
  //       DialogButton(
  //         child: Text(
  //           "Take a video",
  //           style: TextStyle(color: Colors.white, fontSize: 20),
  //         ),
  //         onPressed: () async {
  //           Navigator.pop(context);
  //           videoFile = await ImagePicker.pickVideo(source: ImageSource.camera);

  //           final info = await _flutterVideoCompress.compressVideo(
  //             videoFile.path,
  //             deleteOrigin: true,
  //           );

  //           setState(() {
  //             video = info.file;
  //             _controller = VideoPlayerController.file(video);
  //             _initializeVideoPlayerFuture = _controller.initialize();
  //           });

  //           print(video);
  //           print(videoFile);
  //         },
  //         color: vimPrimary,
  //       ),
  //       DialogButton(
  //         child: Text(
  //           "IMAGE",
  //           style: TextStyle(color: Colors.white, fontSize: 20),
  //         ),
  //         color: vimPrimary,
  //         onPressed: () async {
  //           Navigator.pop(context);
  //           File videoFile =
  //               await ImagePicker.pickImage(source: ImageSource.gallery);
  //           setState(() {
  //             video = videoFile;
  //           });
  //         },
  //       ),
  //     ],
  //   ).show();
  // }

  @override
  Widget build(BuildContext context) {
    if (dateTime == null) {
      setState(() {
        dateTime = DateTime.now();
      });
    }

    List<PageViewModel> pages = [
      PageViewModel(
          "Title of first page",
          "Here you can write the description of the page, to explain something...",
          pageOne(), validator: () {
        List<String> errorList = List<String>();

        if (vehicleIdChosen.toString().length < 1) {
          errorList.add("Registration");
        }
        if (driverNameController.text.length < 1) {
          errorList.add("Driver Name");
        }
        if (locationController.text.length < 1) {
          errorList.add("Location");
        }
        if (driverNumberController.text.length < 1) {
          errorList.add("Driver Contact Number");
        }

        if (errorList.length > 0) {
          errorMessage(
              context, errorList, "The following fields are required:");
          return false;
        } else {
          return true;
        }
      }, progressColor: vimButtonColor),
      PageViewModel(
          "Title of second page",
          "Here you can write the description of the page, to explain something...",
          pageTwo(),
          pageColor: Colors.white,
          progressColor: vimButtonColor),
      PageViewModel(
          "Title of third page",
          "Here you can write the description of the page, to explain something...",
          pageThree(), validator: () {
        List<String> errorList = List<String>();
        if (companyImageList.length < 1) {
          errorList.add(
              "Please provide at least one image of the company vehicle/property.");
          errorMessage(context, errorList, "Image required:");
          return false;
        } else {
          return true;
        }
      },
          //
          pageColor: Colors.white,
          progressColor: vimButtonColor),
      PageViewModel(
          "Title of third page",
          "Here you can write the description of the page, to explain something...",
          pageFour(),
          pageColor: Colors.white,
          progressColor: vimButtonColor),
    ];

    MultiPages multiPages = MultiPages(
      pages: pages,
      onDone: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EndEngReportPage()),
        );
      },
      showSkipButton: true,
      nextText: "Next",
      doneText: "Next",
    );

    return WillPopScope(
        onWillPop: () =>
            goHome(context, backTitle, backMessage, () => clearVars()),
        child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    goHome(context, backTitle, backMessage, () => clearVars());
                  }),
              backgroundColor: Colors.white,
              title: titleIcon(),
              centerTitle: true,
            ),
            body: multiPages));
  }

  DateTime getDay() {
    DateTime now = DateTime.now();
    var date = DateTime(now.year, now.month, now.day - 7);
    return date;
  }

  Widget pageOne() {
    return Container(
      child: Stack(
        children: <Widget>[
          CardSettings(
              cardElevation: 2.0,
              contentAlign: TextAlign.center,
              children: <CardSettingsSection>[
                CardSettingsSection(
                  header: CardSettingsHeader(
                      height: MediaQuery.of(context).size.width * 0.15,
                      label: 'Report an Incident',
                      labelAlign: TextAlign.center,
                      color: vimPrimary),
                  children: <CardSettingsWidget>[
                    CardSettingsInstructions(
                      text: 'Please Give incident details below.',
                      backgroundColor: Colors.white,
                    ),

                    CardSettingsDatePicker(
                      label: 'Date of occurrence: ',
                      labelWidth: MediaQuery.of(context).size.width * 0.5,
                      labelAlign: TextAlign.center,
                      firstDate: getDay(),
                      lastDate: DateTime.now(),
                      contentAlign: TextAlign.end,
                      icon: Icon(FontAwesomeIcons.calendar),
                      initialValue: dateTime,
                      onSaved: (value) =>
                          dateTime = updateJustDate(value, dateTime),
                      onChanged: (value) {
                        setState(() {
                          dateTime = value;
                        });
                      },
                    ),

                    CardSettingsTimePicker(
                        label: 'Time: ',
                        labelAlign: TextAlign.center,
                        contentAlign: TextAlign.end,
                        icon: Icon(FontAwesomeIcons.clock),
                        initialValue: TimeOfDay(
                          hour: dateTime.hour,
                          minute: dateTime.minute,
                        ),
                        onSaved: (value) =>
                            dateTime = updateJustTime(value, dateTime),
                        onChanged: (value) =>
                            dateTime = updateJustTime(value, dateTime)),
                    CardSettingsGenericWidget(children: [
                      Row(children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          FontAwesomeIcons.car,
                          color: Colors.black,
                          size: 30.0,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        AutoSizeText(
                          "Registration: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ]),
                      DropdownButtonFormField<int>(
                        items: data.map((item) {
                          return DropdownMenuItem<int>(
                            child: new Text(item['registration']),
                            value: item['id'],
                          );
                        }).toList(),
                        validator: (value) =>
                            value == null ? 'field required' : null,
                        onChanged: (newVal) {
                          setState(() {
                            regString = data.firstWhere((element) =>
                                element["id"] == newVal)["registration"];

                            vehicleIdChosen = newVal;
                          });
                        },
                        value: vehicleIdChosen,
                      ),
                    ]),
                    //
                    // old location widget
                    /*CardSettingsText(
                      label: 'Location: ',
                      hintText: 'Text',
                      contentAlign: TextAlign.left,
                      icon: Icon(FontAwesomeIcons.globe),
                      controller: locationController,
                      initialValue: locationController.text,
                    ),*/
                    //

                    //New Location Widget
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
                      TextFormField(
                        //internal padding in form
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              left: 10,
                              bottom: 0,
                              right: 0,
                              top: 10,
                            )),
                        controller: locationController,
                      )
                    ]),

                    CardSettingsInstructions(
                      text: 'Please Give Driver Details Below.',
                      backgroundColor: Colors.white,
                    ),
                    CardSettingsText(
                      contentOnNewLine: true,
                      label: "Driver Name: ",
                      hintText: "Text",
                      controller: driverNameController,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),

                    CardSettingsGenericWidget(children: [
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: DateTimeField(
                              decoration: InputDecoration(
                                  labelText: "Date Of Birth:",
                                  contentPadding: EdgeInsets.all(10),
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black)),
                              format: format,
                              initialValue: driverDob,
                              onShowPicker: (context, currentValue) {
                                print(currentValue);
                                return showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                              onSaved: (value) =>
                                  driverDob = updateJustDate(value, driverDob),
                              onChanged: (value) {
                                setState(() {
                                  driverDob = value;
                                });
                              }))
                    ]),
                    VimCardSettingsInt(
                        contentOnNewLine: true,
                        maxLength: 13,
                        label: "Driver Contact Number",
                        hintText: 'Number',
                        controller: driverNumberController),
                    VimCardSettingsSwitch(
                        label: "Is The Driver An Agency Worker?",
                        onChanged: (value) {
                          setState(
                              () => coreOrAgency = value ? "Agency" : "Core");
                        },
                        onSaved: (value) {
                          setState(
                              () => coreOrAgency = value ? "Agency" : "Core");
                        }),
                    VimCardSettingsSwitch(
                      label: "Is The Driver Injured?",
                      onChanged: (value) {
                        setState(() => driverInjured = value);
                      },
                    ),
                    CardSettingsParagraph(
                      contentOnNewLine: true,
                      label: "If Yes, Explain Any Injuries",
                      hintText: "Text",
                      controller: driverInjuredController,
                    ),
                    VimCardSettingsSwitch(
                      label: "Is The Driver's Vehicle Damaged?",
                      onChanged: (value) {
                        setState(() => driverVehicleDamaged = value);
                      },
                    ),
                    CardSettingsParagraph(
                      contentOnNewLine: true,
                      label: "If Yes, Explain Any Damage.",
                      hintText: "Text",
                      controller: driverVehicleDamagedController,
                    ),
                  ],
                )
              ]),
        ],
      ),
    );
  }

  Widget pageTwo() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30.0),
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height / 4,
              ),
            ),
          ),
          CardSettings(
            cardElevation: 2.0,
            labelAlign: TextAlign.left,
            labelSuffix: ":",
            children: <CardSettingsSection>[
              CardSettingsSection(children: <CardSettingsWidget>[
                CardSettingsGenericWidget(children: [
                  Wrap(children: [
                    CardSettingsHeader(
                        label:
                            'What type of incident are you reporting? (Tick all that apply)',
                        height: MediaQuery.of(context).size.width * 0.3,
                        labelAlign: TextAlign.center,
                        color: vimPrimary)
                  ]),
                ]),
                VimCardSettingsSwitch(
                    label: 'Vehicle Damage?',
                    labelAlign: TextAlign.left,
                    contentAlign: TextAlign.end,
                    onChanged: (value) {
                      setState(() => vehicleRelated = value);
                    }),
                VimCardSettingsSwitch(
                    label: 'Property Damage?',
                    labelAlign: TextAlign.left,
                    contentAlign: TextAlign.end,
                    onChanged: (value) {
                      setState(() => propertyRelated = value);
                    }),
                VimCardSettingsSwitch(
                    label: 'Injury?',
                    labelAlign: TextAlign.left,
                    contentAlign: TextAlign.end,
                    onChanged: (value) {
                      setState(() => injuryRelated = value);
                    })
              ])
            ],
          ),
        ],
      ),
    );
  }

  Widget pageThree() {
    return Container(
        child: Stack(children: <Widget>[
      /*Container(
        padding: EdgeInsets.all(30.0),
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            height: MediaQuery.of(context).size.height / 4,
          ),
        ),
      ),*/
      CardSettings(cardElevation: 2.0, children: <CardSettingsSection>[
        CardSettingsSection(children: <CardSettingsWidget>[
          CardSettingsHeader(
            label:
                "Provide Photo Evidence Of Damage To Company Vehicle And/Or Property",
            height: MediaQuery.of(context).size.width * 0.30,
            labelAlign: TextAlign.center,
            color: vimPrimary,
          ),
          CardSettingsButton(
            label: 'PICK EVIDENCE',
            textColor: Colors.white,
            onPressed: () => onImagePressed(companyImageList),
            backgroundColor: vimButtonColor,
          ),
          CardSettingsGenericWidget(children: [
            SizedBox(height: 5.0),
            ...imageThumbs(companyImageList)
          ])
        ])
      ])
    ]));
  }

  Widget pageFour() {
    return Container(
        child: Stack(children: <Widget>[
      /*Container(
        padding: EdgeInsets.all(30.0),
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            height: MediaQuery.of(context).size.height / 4,
          ),
        ),
      ),*/
      CardSettings(cardElevation: 2.0, children: <CardSettingsSection>[
        CardSettingsSection(children: <CardSettingsWidget>[
          CardSettingsHeader(
            label:
                "Provide Photo Evidence Of Damage To Third Party Vehicle And/Or Property",
            height: MediaQuery.of(context).size.width * 0.30,
            labelAlign: TextAlign.center,
            color: vimPrimary,
          ),
          CardSettingsButton(
            label: 'PICK EVIDENCE',
            textColor: Colors.white,
            onPressed: () => onImagePressed(companyImageList),
            backgroundColor: vimButtonColor,
          ),
          CardSettingsGenericWidget(children: [
            SizedBox(height: 5.0),
            ...imageThumbs(thirdPartyImageList)
          ])
        ])
      ])
    ]));
  }

  //Keep for reference to image uploading
/*
  Widget pageTen() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30.0),
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height / 4,
              ),
            ),
          ),
          CardSettings(
            cardElevation: 2.0,
            children: <CardSettingsSection>[
              CardSettingsSection(children: <CardSettingsWidget>[
                CardSettingsHeader(
                  label:
                      'In addition you can also take a video for us to upload (Optional). Please give it time to for the video to compress for you to view it.',
                  height: 85.0,
                  labelAlign: TextAlign.center,
                  color: vimPrimary,
                ),
                CardSettingsButton(
                  label: 'PICK EVIDENCE',
                  textColor: Colors.white,
                  onPressed: () => _selectNine(context),
                  backgroundColor: vimButtonColor,
                ),
                SizedBox(height: 5.0),
                Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // If the VideoPlayerController has finished initialization, use
                          // the data it provides to limit the aspect ratio of the VideoPlayer.
                          return AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            // Use the VideoPlayer widget to display the video.
                            child: VideoPlayer(_controller),
                          );
                        } else {
                          // If the VideoPlayerController is still initializing, show a
                          // loading spinner.
                          return Center(
                              child: CircularProgressIndicator(
                            backgroundColor: vimButtonColor,
                          ));
                        }
                      },
                    )),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      MaterialButton(
                        minWidth: MediaQuery.of(context).size.width / 4,
                        height: 100,
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        color: vimButtonColor,
                        onPressed: () {
                          // Wrap the play or pause in a call to `setState`. This ensures the
                          // correct icon is shown
                          setState(() {
                            // If the video is playing, pause it.
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              // If the video is paused, play it.
                              _controller.play();
                            }
                          });
                        },
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: SizedBox(width: 1.0),
                        ),
                      ),
                      MaterialButton(
                        minWidth: MediaQuery.of(context).size.width / 4,
                        height: 100,
                        child: Icon(
                          Icons.restore,
                          color: Colors.white,
                        ),
                        color: vimButtonColor,
                        onPressed: () {
                          setState(() {
                            _controller.initialize();
                            _controller.play();
                          });
                        },
                      ),
                    ],
                  ),
                )
              ])
            ],
          ),
        ],
      ),
    );
  }*/
}

class EndEngReportPage extends StatefulWidget {
  @override
  EndEngReportPageState createState() => EndEngReportPageState();
}

class EndEngReportPageState extends State<EndEngReportPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool uploading = false;

  generateHeader(String text) {
    return new Container(
        height: 50,
        child: Row(
          children: <Widget>[
            DotsIndicator(
              dotsCount: 1,
              decorator: DotsDecorator(
                color: vimButtonColor,
                activeColor: vimPrimary,
              ),
            ),
            AutoSizeText(
              text,
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ],
        ));
  }

  _emailPopup() async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CardSettings(children: <CardSettingsSection>[
                CardSettingsSection(children: <CardSettingsWidget>[
                  CardSettingsHeader(
                    label: 'Send Email',
                    color: vimPrimary,
                  ),
                  CardSettingsInstructions(
                    text:
                        'We aim to reply to our customers as soon as possible...',
                  ),
                  CardSettingsText(
                    contentOnNewLine: true,
                    label: 'Subject:',
                    controller: subjectController,
                    hintText: "Text",
                  ),
                  CardSettingsParagraph(
                      contentOnNewLine: true,
                      label: 'Body:',
                      controller: emailController,
                      hintText: "Text"),
                  CardSettingsButton(
                    backgroundColor: vimPrimary,
                    label: 'Send',
                    textColor: Colors.white,
                    onPressed: () async {
                      try {
                        // final Email email = Email(
                        //     body: emailController.text,
                        //     subject: subjectController.text,
                        //     recipients: ['general@vim-ltd.com']);
                        // await FlutterEmailSender.send(email);
                      } catch (e) {
                        Alert(
                                title:
                                    "Could not start Email service! Make sure you have set up a default email provider on your device.",
                                context: context)
                            .show();
                      }
                    },
                  ),
                ])
              ]));
        });
  }

  _callOptions(context) async {
    const telephone = "tel:0845 140 0201";
    Alert(
        context: context,
        type: AlertType.none,
        title: "INCIDENT CREATED REFERENCE NUMBER IS: " +
            '$getIncidentId' +
            "\n" +
            "INSURER: " +
            '$getInsurerName' +
            "\n" +
            "POLICY NUMBER: " +
            '$getPolicyNumber' +
            "\n" +
            "INSURER TELEPHONE: " +
            '$getInsurerTelephone' +
            "\n",
        desc:
            "Please note that VIM Ltd is a First Notice Of Loss Service not the covering insurance company.",
        buttons: [
          DialogButton(
            child: Text(
              "Call Vim",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              if (await canLaunch(telephone)) {
                await launch(telephone);
              } else {
                throw 'Could not launch $telephone';
              }
            },
            color: vimPrimary,
          )
        ],
        closeFunction: () {
          clearVars();
          Navigator.pushNamed(context, '/dashboard');
        }).show();
  }

  @override
  Widget build(BuildContext context) {
    var thirdPartyQuestions = CardSettingsSection(
      children: <CardSettingsWidget>[
        CardSettingsGenericWidget(children: [
          generateHeader('THIRD PARTY INFO'),
          CardSettingsHeader(
            label: 'Third Party Contact Info:',
            color: vimPrimary,
          ),
          CardSettingsText(
            contentOnNewLine: true,
            label: 'Name',
            hintText: 'Text',
            controller: thirdPartyNameController,
            initialValue: thirdPartyNameController.text,
            contentAlign: TextAlign.left,
          ),
          VimCardSettingsInt(
            contentOnNewLine: true,
            maxLength: 13,
            label: "Contact Number",
            hintText: 'Number',
            controller: thirdPartyNumberController,
          ),
          CardSettingsParagraph(
            label: "Address",
            hintText: 'Text',
            contentOnNewLine: true,
            controller: thirdPartyAddressController,
            initialValue: thirdPartyAddressController.text,
          ),
          CardSettingsHeader(
            label: 'Third Party Insurance Details:',
            color: vimPrimary,
          ),
          CardSettingsText(
            contentOnNewLine: true,
            label: 'Insurer',
            hintText: 'Text',
            contentAlign: TextAlign.left,
            controller: thirdPartyInsurerController,
            initialValue: thirdPartyInsurerController.text,
          ),
          CardSettingsText(
            contentOnNewLine: true,
            label: 'Policy No.',
            hintText: 'Text',
            contentAlign: TextAlign.left,
            controller: thirdPartyPolicyController,
            initialValue: thirdPartyPolicyController.text,
          ),
          CardSettingsHeader(
            label: 'Third Party Injury:',
            color: vimPrimary,
          ),
          VimCardSettingsSwitch(
            label: 'Is the third party injured?',
            onChanged: (value) {
              setState(() => thirdPartyInjured = value);
            },
          ),
          CardSettingsParagraph(
            label: 'If yes, explain any injuries',
            hintText: 'Text',
            controller: thirdPartyInjuredController,
            initialValue: thirdPartyInjuredController.text,
          )
        ])
      ],
    );

    var vehicleRelatedQuestions =
        CardSettingsSection(children: <CardSettingsWidget>[
      CardSettingsGenericWidget(children: [
        generateHeader('VEHICLE INFO'),
        CardSettingsHeader(
          label: 'Third Party Vehicle details:',
          color: vimPrimary,
        ),
        CardSettingsText(
          contentOnNewLine: true,
          label: 'Registration',
          labelWidth: MediaQuery.of(context).size.width * 0.37,
          hintText: 'Text',
          contentAlign: TextAlign.left,
          controller: vehicleRegController,
          initialValue: vehicleRegController.text,
        ),
        CardSettingsNumberPicker(
          label: "Number Of Passengers?",
          labelWidth: MediaQuery.of(context).size.width * 0.4,
          onChanged: (value) => vehiclePassengerNumber = value.toString(),
          onSaved: (value) => vehiclePassengerNumber = value.toString(),
          min: 0,
          max: 6,
        ),
        CardSettingsText(
          contentOnNewLine: true,
          label: 'Make',
          hintText: 'Text',
          contentAlign: TextAlign.left,
          controller: vehicleMakeController,
          initialValue: vehicleMakeController.text,
        ),
        CardSettingsText(
          contentOnNewLine: true,
          label: 'Model',
          hintText: 'Text',
          contentAlign: TextAlign.left,
          controller: vehicleModelController,
          initialValue: vehicleModelController.text,
        ),
        CardSettingsText(
          contentOnNewLine: true,
          label: 'Colour',
          hintText: 'Text',
          contentAlign: TextAlign.left,
          controller: vehicleColourController,
          initialValue: vehicleColourController.text,
        ),
        CardSettingsHeader(
          label: 'Third Party Vehicle Damage:',
          color: vimPrimary,
        ),
        VimCardSettingsSwitch(
          labelWidth: MediaQuery.of(context).size.width * 0.4,
          label: 'Is the vehicle damaged?',
          onChanged: (value) {
            setState(() => vehicleDamaged = value);
          },
        ),
        CardSettingsParagraph(
          contentOnNewLine: true,
          label: 'If yes, explain any damage',
          hintText: 'Text',
          controller: vehicleDamageController,
          initialValue: vehicleDamageController.text,
        ),
        CardSettingsHeader(
          label: 'Notes:',
          color: vimPrimary,
        ),
        CardSettingsParagraph(
          contentOnNewLine: true,
          label: 'Notes',
          hintText: 'Text',
          controller: vehicleNotesController,
          initialValue: vehicleNotesController.text,
        )
      ])
    ]);

    var propertyRelatedQuestions =
        CardSettingsSection(children: <CardSettingsWidget>[
      CardSettingsGenericWidget(children: [
        generateHeader('PROPERTY INFO'),
        CardSettingsHeader(
          label: 'Property Owner Details:',
          color: vimPrimary,
        ),
        CardSettingsText(
          contentOnNewLine: true,
          label: 'Owner Name',
          hintText: 'Text',
          contentAlign: TextAlign.left,
          controller: propertyOwnerController,
          initialValue: propertyOwnerController.text,
        ),
        VimCardSettingsInt(
          contentOnNewLine: true,
          maxLength: 13,
          label: "Owner Contact No.",
          controller: propertyTelephoneController,
          hintText: "Number",
        ),
        CardSettingsHeader(
          label: 'Property Details:',
          color: vimPrimary,
        ),
        CardSettingsText(
          contentOnNewLine: true,
          label: 'Property Type (Hotel, House etc.)',
          hintText: 'Text',
          contentAlign: TextAlign.left,
          controller: propertyTypeController,
          initialValue: propertyTypeController.text,
        ),
        CardSettingsParagraph(
          contentOnNewLine: true,
          label: "Property Address",
          hintText: "Text",
          contentAlign: TextAlign.left,
          controller: propertyAddressController,
          initialValue: propertyAddressController.text,
        ),
        CardSettingsHeader(
          label: 'Property Damage:',
          color: vimPrimary,
        ),
        VimCardSettingsSwitch(
          label: 'Is the property damaged?',
          onChanged: (value) {
            setState(() => propertyDamaged = value);
          },
        ),
        CardSettingsParagraph(
          contentOnNewLine: true,
          label: 'If yes, explain any damage',
          hintText: 'Text',
          controller: propertyDamageController,
          initialValue: propertyDamageController.text,
        ),
        CardSettingsHeader(
          label: 'Notes:',
          color: vimPrimary,
        ),
        CardSettingsParagraph(
          contentOnNewLine: true,
          label: 'Notes',
          hintText: 'Text',
          controller: propertyNotesController,
          initialValue: propertyNotesController.text,
        )
      ])
    ]);

    var injuryRelatedQuestions = CardSettingsSection(
      children: <CardSettingsWidget>[
        CardSettingsGenericWidget(children: [
          generateHeader('INJURY INFO'),
          CardSettingsHeader(
            label: 'Contact info:',
            color: vimPrimary,
          ),
          CardSettingsText(
            contentOnNewLine: true,
            label: 'Name',
            hintText: 'Text',
            contentAlign: TextAlign.left,
            controller: injuryNameController,
            initialValue: injuryNameController.text,
          ),
          VimCardSettingsInt(
            contentOnNewLine: true,
            maxLength: 13,
            label: "Contact Number",
            hintText: 'Number',
            controller: injuryNumberController,
          ),
          CardSettingsParagraph(
            label: "Address",
            hintText: 'Text',
            contentOnNewLine: true,
            controller: injuryAddressController,
            initialValue: injuryAddressController.text,
          ),
          CardSettingsHeader(
            label: 'Circumstances:',
            color: vimPrimary,
          ),
          VimCardSettingsSwitch(
            label: 'Are You A Representative Of The Company?',
            onChanged: (value) {
              setState(() => companyRepInjured = value);
            },
          ),
          CardSettingsParagraph(
            contentOnNewLine: true,
            label: 'Explain Any Injuries',
            hintText: 'Text',
            controller: injuryCircumstanceController,
            initialValue: injuryCircumstanceController.text,
          ),
          CardSettingsHeader(
            label: 'Notes:',
            color: vimPrimary,
          ),
          CardSettingsParagraph(
            contentOnNewLine: true,
            label: 'Notes',
            hintText: 'Text',
            controller: injuryNotesController,
            initialValue: injuryNotesController.text,
          )
        ])
      ],
    );

    return WillPopScope(
        onWillPop: () =>
            goHome(context, backTitle, backMessage, () => clearVars()),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  goHome(context, backTitle, backMessage, () => clearVars());
                }),
            backgroundColor: Colors.white,
            title: titleIcon(),
            centerTitle: true,
          ),
          body: uploading
              ? loadingSplash(context, "Currently Uploading", "Please wait")
              : Stack(
                  children: <Widget>[
                    CardSettings(children: <CardSettingsSection>[
                      //Beginning of Report Form
                      //
                      CardSettingsSection(
                        children: <CardSettingsWidget>[
                          CardSettingsGenericWidget(children: [
                            generateHeader('GENERAL INFORMATION'),
                            CardSettingsHeader(
                              label: 'Date & Time:',
                              color: vimPrimary,
                            ),
                            CardSettingsDatePicker(
                              label: 'Date: ',
                              labelAlign: TextAlign.center,
                              contentAlign: TextAlign.end,
                              icon: Icon(FontAwesomeIcons.calendar),
                              initialValue: dateTime,
                              onSaved: (value) =>
                                  dateTime = updateJustDate(value, dateTime),
                              onChanged: (value) =>
                                  dateTime = updateJustDate(value, dateTime),
                            ),
                            CardSettingsTimePicker(
                              label: 'Time: ',
                              labelAlign: TextAlign.center,
                              contentAlign: TextAlign.end,
                              icon: Icon(FontAwesomeIcons.clock),
                              initialValue: TimeOfDay(
                                hour: dateTime.hour,
                                minute: dateTime.minute,
                              ),
                              onSaved: (value) =>
                                  dateTime = updateJustTime(value, dateTime),
                              onChanged: (value) {
                                setState(() {
                                  updateJustTime(value, dateTime);
                                });
                              },
                            ),
                            CardSettingsHeader(
                              label: 'Vehicle:',
                              color: vimPrimary,
                            ),
                            CardSettingsText(
                              contentOnNewLine: true,
                              label: 'Reg: ',
                              hintText: 'Text',
                              labelAlign: TextAlign.left,
                              enabled: false,
                              contentAlign: TextAlign.left,
                              icon: Icon(FontAwesomeIcons.car),
                              initialValue: regString,
                            ),
                            CardSettingsHeader(
                              label: 'Notes:',
                              color: vimPrimary,
                            ),
                            CardSettingsParagraph(
                              contentOnNewLine: true,
                              label: 'Notes',
                              controller: initialNotesController,
                              hintText: 'Text',
                            )
                          ])
                        ],
                      ),
                      CardSettingsSection(
                        children: <CardSettingsWidget>[
                          CardSettingsGenericWidget(children: [
                            generateHeader('INITIAL QUESTIONS'),
                            CardSettingsHeader(
                                label: 'Circumstances:', color: vimPrimary),
                            CardSettingsParagraph(
                              contentOnNewLine: true,
                              label: 'What Happened?',
                              hintText: 'Text',
                              controller: initialCircumstanceController,
                              contentAlign: TextAlign.left,
                            ),
                            CardSettingsListPicker(
                              label: "Who was at fault?",
                              labelAlign: TextAlign.center,
                              // options: faults.faults,
                              onChanged: (value) => faultString = value,
                            ),
                            VimCardSettingsSwitch(
                              label: "Was The Banksman Used?",
                              onChanged: (value) =>
                                  banksmanUsed = value ? "Yes" : "No",
                            )
                          ])
                        ],
                      ),
                      //If Incident is Either Vehicle related or property
                      //related then show third party Questions
                      (vehicleRelated || propertyRelated
                          ? thirdPartyQuestions
                          : CardSettingsSection()),
                      (vehicleRelated
                          ? vehicleRelatedQuestions
                          : CardSettingsSection()),
                      (propertyRelated
                          ? propertyRelatedQuestions
                          : CardSettingsSection()),
                      (injuryRelated
                          ? injuryRelatedQuestions
                          : CardSettingsSection()),
                      CardSettingsSection(children: <CardSettingsWidget>[
                        CardSettingsGenericWidget(children: [
                          TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(15.0),
                                backgroundColor: vimPrimary,
                              ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                              onPressed: uploading ? {} : sendReport)
                        ]),
                      ])
                      //End of report form
                      //
                    ]),
                    uploading
                        ? loadingSplash(
                            context, "Currently Uploading", "Please wait")
                        : Container()
                  ],
                ),
        ));
  }

  String dateFormat(DateTime date) {
    var formatter = new DateFormat('yyyy-MM-ddTHH:mm:ss');
    String formatted = formatter.format(date).toString();
    return formatted;
  }

  void sendReport() async {
    //START PROGRESS LOADER
    setState(() {
      uploading = true;
    });

    //CREATE A NEW INCIDENT
    //Declare vars
    var token;
    var companyId;
    var depotId;
    var userId;
    Map responseBody;

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

    //Creation time of incident
    var createdTime = dateFormat(DateTime.now());

    //Accident time of incident
    var accidentTime = dateFormat(dateTime);

    //Driver DOB
    var driverDobString = dateFormat(driverDob);

    var dio = new Dio();

    dio.options.headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    //Create empty list of incident questions. Populate list using form data.
    try {
      var incidentQuestions = new List<CreateIncidentsQuestions>();

      //Answers that dont appear in the UI
      incidentQuestions.add(new CreateIncidentsQuestions(7, "Driver"));
      incidentQuestions.add(new CreateIncidentsQuestions(
          41,
          companyImageList.length < 1 && thirdPartyImageList.length < 1
              ? "No"
              : "Yes"));

      //Initial questions
      incidentQuestions
          .add(new CreateIncidentsQuestions(8, driverNameController.text));
      incidentQuestions
          .add(new CreateIncidentsQuestions(21, driverNameController.text));
      incidentQuestions.add(new CreateIncidentsQuestions(136, faultString));
      incidentQuestions.add(new CreateIncidentsQuestions(22, driverDobString));
      incidentQuestions.add(new CreateIncidentsQuestions(1, accidentTime));
      incidentQuestions.add(new CreateIncidentsQuestions(4, createdTime));
      incidentQuestions.add(new CreateIncidentsQuestions(
          137, initialCircumstanceController.text));
      incidentQuestions
          .add(new CreateIncidentsQuestions(38, locationController.text));
      incidentQuestions.add(new CreateIncidentsQuestions(
          26, stringBool(driverInjured) + driverInjuredController.text));
      incidentQuestions.add(new CreateIncidentsQuestions(
          39,
          stringBool(driverVehicleDamaged) +
              driverVehicleDamagedController.text));
      incidentQuestions
          .add(new CreateIncidentsQuestions(9, driverNumberController.text));
      //UNCOMMENT BEFORE RELEASE THEN DELETE API CODE!!
      // incidentQuestions
      //     .add(new CreateIncidentsQuestions(23, driverNumberController.text));
      incidentQuestions.add(new CreateIncidentsQuestions(25, coreOrAgency));
      incidentQuestions.add(new CreateIncidentsQuestions(43, banksmanUsed));
      incidentQuestions
          .add(new CreateIncidentsQuestions(111, initialNotesController.text));

      //Third party questions
      if (vehicleRelated || propertyRelated) {
        incidentQuestions.add(
            new CreateIncidentsQuestions(138, thirdPartyNameController.text));
        incidentQuestions.add(
            new CreateIncidentsQuestions(139, thirdPartyNumberController.text));
        incidentQuestions.add(new CreateIncidentsQuestions(
            140, thirdPartyAddressController.text));
        incidentQuestions.add(
            new CreateIncidentsQuestions(83, thirdPartyInsurerController.text));
        incidentQuestions.add(
            new CreateIncidentsQuestions(142, thirdPartyPolicyController.text));
        incidentQuestions.add(new CreateIncidentsQuestions(143,
            stringBool(thirdPartyInjured) + thirdPartyInjuredController.text));
      }

      //Third Party Vehicle related questions
      if (vehicleRelated) {
        incidentQuestions
            .add(new CreateIncidentsQuestions(158, vehicleRegController.text));
        incidentQuestions
            .add(new CreateIncidentsQuestions(85, vehiclePassengerNumber));
        incidentQuestions
            .add(new CreateIncidentsQuestions(144, vehicleMakeController.text));
        incidentQuestions.add(
            new CreateIncidentsQuestions(145, vehicleModelController.text));
        incidentQuestions.add(
            new CreateIncidentsQuestions(146, vehicleColourController.text));
        incidentQuestions.add(new CreateIncidentsQuestions(
            147, stringBool(vehicleDamaged) + vehicleDamageController.text));
        incidentQuestions.add(
            new CreateIncidentsQuestions(148, vehicleNotesController.text));
      }

      //Third party property questions
      if (propertyRelated) {
        incidentQuestions.add(
            new CreateIncidentsQuestions(103, propertyOwnerController.text));
        incidentQuestions.add(new CreateIncidentsQuestions(
            104, propertyTelephoneController.text));
        incidentQuestions.add(
            new CreateIncidentsQuestions(105, propertyAddressController.text));
        incidentQuestions.add(
            new CreateIncidentsQuestions(149, propertyTypeController.text));
        incidentQuestions.add(new CreateIncidentsQuestions(
            150, stringBool(propertyDamaged) + propertyDamageController.text));
        incidentQuestions.add(
            new CreateIncidentsQuestions(151, propertyNotesController.text));
      }

      //Injury related Questions
      if (injuryRelated) {
        incidentQuestions.add(
            new CreateIncidentsQuestions(152, stringBool(companyRepInjured)));
        incidentQuestions
            .add(new CreateIncidentsQuestions(153, injuryNameController.text));
        incidentQuestions.add(
            new CreateIncidentsQuestions(154, injuryNumberController.text));
        incidentQuestions.add(
            new CreateIncidentsQuestions(155, injuryAddressController.text));
        incidentQuestions
            .add(new CreateIncidentsQuestions(157, injuryNotesController.text));
        incidentQuestions.add(new CreateIncidentsQuestions(
            156, injuryCircumstanceController.text));
      }

      //Create Incident object, encode to JSON and send POST request
      var incident = new CreateIncidents(
              0,
              "client",
              int.parse(companyId),
              int.parse(depotId),
              vehicleIdChosen,
              createdTime,
              userId,
              position != null ? position.latitude : 0,
              position != null ? position.longitude : 0,
              "Pending",
              incidentQuestions,
              false)
          .toJson();
      var body = json.encode(incident);
      print(body.toString());
      var response =
          await dio.post(BASE_URL + "/api/incidents/Create", data: body);
      debugPrint(response.data.toString());

      //Save response data to display in completion dialog
      responseBody = response.data;
    }
    //Error handling
    catch (response) {
      print('ERROR!!!: ${response.toString()}');
      Alert(
          context: context,
          title: "There Was An Error Creating The Incident!",
          closeFunction: () {
            clearVars();
            Navigator.pushNamed(context, '/dashboard');
          }).show();
      setState(() {
        uploading = false;
      });
    }

    //Use response Data to define vars for completion dialog.
    //IdResponse is used in upload image call. DO NOT CONVERT TO STRING!
    final idResponse = responseBody["incidentId"];
    final companyCode = responseBody["companyCode"];
    final incidentReference = companyCode != null
        ? companyCode + idResponse.toString()
        : idResponse.toString();
    final insurerResponse = responseBody["insurerName"];
    final policyResponse = responseBody["policyNumber"];
    final insurerPhoneResponse = responseBody["insurerTelephone"];

    //POST IMAGES
    if (companyImageList.length > 0) {
      await postIncidentImages(
          context, idResponse, companyImageList, false, false, 0);
    }
    if (thirdPartyImageList.length > 0) {
      await postIncidentImages(
          context, idResponse, thirdPartyImageList, true, false, 0);
    }

    //STILL IN DEVELOPMENT
    // await postIncidentVideo(incidentId, video);

    //Set global vars using response data for completion dialog and finish the uploading process.
    setState(() {
      getIncidentId = incidentReference;
      getInsurerName = insurerResponse;
      getPolicyNumber = policyResponse;
      getInsurerTelephone = insurerPhoneResponse;
      uploading = false;
    });

    //Call completion dialog
    _callOptions(context);
  }
}
