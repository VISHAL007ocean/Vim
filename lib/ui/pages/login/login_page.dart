import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:vim_mobile/common/api_functions/auth_login/requestLoginAPI.dart';
import 'package:vim_mobile/common/api_functions/auth_login/requestPermissions.dart';
import 'package:vim_mobile/common/api_functions/auth_login/requestUserInfo.dart';
import 'package:vim_mobile/common/api_functions/wellbeing_checks/postEmotionCheck.dart';
import 'package:vim_mobile/common/custom_widgets/title_icon.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/ui/components/pageComponents/CardSettingsGenericWidget.dart';
import 'package:vim_mobile/ui/components/pageComponents/loadingSplash.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';

dynamic depotChosen;
UserEmotions emotionChosen = UserEmotions.neutral;
List<dynamic> data = List<dynamic>();
bool isLoading = false;

chooseDepot(
  BuildContext context,
  State state,
) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await requestUserInfo();
  await preferences.setString(
      'CurrentCompanyId', depotChosen["companyId"].toString());
  await preferences.setString(
      'CurrentDepotId', depotChosen["depotId"].toString());
  if (depotChosen["defaultVehicleId"] != null) {
    await preferences.setString(
        'DefaultVehicleId', depotChosen["defaultVehicleId"].toString());
    await preferences.setString(
        'CurrentVehicleId', depotChosen["defaultVehicleId"].toString());
  }

  await preferences.setString(
      'FeatureIncidents', depotChosen['featureIncidents'].toString());
  await preferences.setString(
      'FeatureDriverChecks', depotChosen['featureDriverChecks'].toString());
  await preferences.setString(
      'FeatureVehicleRepairs', depotChosen['featureVehicleRepairs'].toString());
  await preferences.setString(
      'FeatureLeaseChecks', depotChosen['featureLeaseChecks'].toString());
  await preferences.setString('FeatureVerificationChecks',
      depotChosen['featureVerificationChecks'].toString());
  await preferences.setString('FeaturePropertyRepairs',
      depotChosen['featurePropertyRepairs'].toString());
  await preferences.setString(
      'FeatureVehicleRentals', depotChosen['featureVehicleRentals'].toString());
  await preferences.setString(
      'FeatureDriverHealth', depotChosen['featureDriverHealth'].toString());

  await preferences.setString(
      'FeatureFltChecks', depotChosen['featureFLTChecks'].toString());

  await preferences.setString('FeatureDamageChecks',
      depotChosen['featureDamageVehicleChecks'].toString());

  await preferences.setString('FeatureEmergencyButton',
      depotChosen['featureEmergencyButton'].toString());

  await preferences.setString(
      'FeatureJob', depotChosen['featureJob'].toString());

  if (preferences.getString("FeatureDriverHealth") == "true" &&
      dueEmotionCheck(preferences)) {
    driverEmotion(context);
  } else {
    await requestPermissions(context);
  }
}

bool dueEmotionCheck(SharedPreferences preferences) {
  String dateString = preferences.getString("LastEmotionCheck");

  if (dateString == null) {
    return true;
  }

  DateTime date = DateTime.parse(dateString);

  final date2 = DateTime.now();
  final difference = date2.difference(date).inHours;

  return difference >= 10;
}

List<Widget> emotionsList(void Function(void Function()) setState) {
  List<Widget> emotions = new List<Widget>();

  for (var value in UserEmotions.values) {
    String emotionName = value.toString().split('.').elementAt(1);

    emotionName = emotionName.replaceRange(0, 1, emotionName[0].toUpperCase());

    emotionName =
        value == UserEmotions.angryStressed ? "Angry/Stressed" : emotionName;

    emotions.add(new GestureDetector(
        onTap: () => {
              setState(() => {emotionChosen = value})
            },
        child: Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    getEmojiIcon(value),
                    width: 50,
                    height: 50,
                  ),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(emotionName))),
                  emotionChosen == value ? Icon(Icons.check) : Text("")
                ]))));
  }

  return emotions;
}

String getEmojiIcon(UserEmotions emotion) {
  switch (emotion) {
    case UserEmotions.angryStressed:
      return "assets/images/explode.png";
    case UserEmotions.happy:
      return "assets/images/happy.png";
    case UserEmotions.sad:
      return "assets/images/unhappy.png";
    case UserEmotions.tired:
      return "assets/images/tired.png";
    case UserEmotions.unwell:
      return "assets/images/unwell.png";
    default:
      return "assets/images/neutral.png";
  }
}

driverEmotion(BuildContext context) async {
  emotionChosen = UserEmotions.neutral;
  await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return isLoading
              ? loadingSplash(context, "Currently Uploading", "Please wait")
              : AlertDialog(
                  title: Text("How are you feeling today?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        ...emotionsList(setState),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(5),
                                child: DialogButton(
                                  child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text("Send",
                                          style:
                                              TextStyle(color: Colors.white))),
                                  onPressed: () async {
                                    setState(() => {isLoading = true});

                                    await postEmotionCheck(emotionChosen);
                                    await requestPermissions(context).then(
                                        (result) => setState(
                                            () => {isLoading = false}));

                                    /*   if(role=="Eng"){
                                      await postEmotionCheck(emotionChosen);
                                      await requestPermissions(context).then(
                                              (result) => setState(
                                                  () => {isLoading = false}));

                                    }else{
                                      await postEmotionCheck(emotionChosen);
                                      await requestPermissions(context).then(
                                              (result) => setState(
                                                  () => {isLoading = false}));
                                    }*/
                                  },
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[],
                );
        });
      });
}

class ChooseDepotPage extends StatefulWidget {
  @override
  _ChooseDepotState createState() => new _ChooseDepotState();
}

class _ChooseDepotState extends State<ChooseDepotPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  depotThumbs(List<dynamic> depotList) {
    var list = <Widget>[];
    if (depotList.length > 0) {
      for (int i = 0; i < depotList.length; i++) {
        list.add(
          ListTile(
              title: AutoSizeText(
                depotList[i]["name"],
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              subtitle: AutoSizeText(
                depotList[i]["companyName"],
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              onTap: () async {
                setState(() {
                  isLoading = true;
                });

                depotChosen = depotList[i];
                print(depotChosen);

                chooseDepot(context, this);
              }),
        );
      }
      setState(() {
        isLoading = false;
      });
      return list;
    } else {
      return <Widget>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.white,
          title: titleIcon(),
          centerTitle: true,
        ),
        body: Stack(children: <Widget>[
          CardSettings(children: <CardSettingsSection>[
            CardSettingsSection(children: [
              CardSettingsGenericWidget(children: [
                CardSettingsHeader(
                  color: vimPrimary,
                  label: "Please Choose A Depot.",
                  labelAlign: TextAlign.center,
                ),
                ...depotThumbs(data)
              ])
            ])
          ])
        ]));
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  bool _isSelected = false;
  SharedPreferences pref;
  @override
  initState() {
    _controller = VideoPlayerController.network(
        'https://vim-ltd.com/assets/Vehcam-App-Training-Vid.mp4');

    _initializeVideoPlayerFuture = _controller.initialize();
    initLocation();
    initPrefs();
    super.initState();
  }

  initPrefs() async {
    pref = await SharedPreferences.getInstance();
  }

  initLocation() async {
    //This will prompt the user to accept location permissions upon first use of the app.
    //This prompt has been blocking async API calls on other views, resulting in bad UX on the first use.

    LocationPermission permission;
    bool serviceEnabled;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    print("=============LOCATION  $serviceEnabled=============");

    // PermissionStatus status = await Permission.location.status;

    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      var pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }

    print("=====20-4======GET PERMISSION");
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  playVideo(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          Icon _playIcon = new Icon(Icons.play_arrow);
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                insetPadding: EdgeInsets.all(5),
                title: Text("How to use the app.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                content: SingleChildScrollView(
                    child: Center(
                  child: Column(children: [
                    FutureBuilder(
                        future: _initializeVideoPlayerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            // If the VideoPlayerController has finished initialization, use
                            // the data it provides to limit the aspect ratio of the VideoPlayer.
                            return FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _controller.value.size?.width ?? 0,
                                height: _controller.value.size?.height ?? 0,
                                child: VideoPlayer(_controller),
                              ),
                            );
                          } else {
                            // If the VideoPlayerController is still initializing, show a
                            // loading spinner.
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                    FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                              _playIcon = new Icon(Icons.play_arrow);
                            } else {
                              // If the video is paused, play it.
                              _controller.play();
                              _playIcon = new Icon(Icons.pause);
                            }
                          });
                        },
                        child: _playIcon)
                  ]),
                )));
          });
        });
    _controller.pause();
    _controller.seekTo(Duration.zero);
  }

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController companyCodeController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();

  bool depotListReady = false;

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  goToChooseDepot() {}

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: new ScreenUtil().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(750, 1334),
    ); // allowFontScaling: true
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50.0),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Image.asset(
                        "assets/images/image_04.png",
                        width: new ScreenUtil().setWidth(650),
                        height: new ScreenUtil().setHeight(200),
                      ))
                    ],
                  ),
                  //TODO Branding
                  SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.75,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0.0, 15.0),
                                blurRadius: 15.0),
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0.0, -10.0),
                                blurRadius: 10.0),
                          ]),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Login",
                                style: TextStyle(
                                    fontSize: new ScreenUtil().setSp(45),
                                    fontFamily: "Poppins-Bold",
                                    letterSpacing: .6)),
                            Text("Username",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize: new ScreenUtil().setSp(26))),
                            TextField(
                              decoration: InputDecoration(
                                  hintText: "username",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                              controller: usernameController,
                            ),
                            Text("Password",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize: new ScreenUtil().setSp(26))),
                            TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                              controller: passwordController,
                            ),
                            SizedBox(
                              height: new ScreenUtil().setHeight(15),
                            ),
                            SizedBox(
                              height: new ScreenUtil().setHeight(15),
                            ),
                            SizedBox(
                              height: new ScreenUtil().setHeight(15),
                            ),
                            SizedBox(
                              height: new ScreenUtil().setHeight(25),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: _radio,
                                  child: radioButton(_isSelected),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                AutoSizeText("Remember me",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Poppins-Medium"))
                              ],
                            ),
                            SizedBox(
                              height: new ScreenUtil().setHeight(15),
                            ),
                            Center(
                              child: Container(
                                width: new ScreenUtil().setWidth(330),
                                height: new ScreenUtil().setHeight(120),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color(0xFF56122F),
                                      Color(0xFF88333C)
                                    ]),
                                    borderRadius: BorderRadius.circular(6.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color(0xFF88333C).withOpacity(.3),
                                          offset: Offset(0.0, 8.0),
                                          blurRadius: 8.0)
                                    ]),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      if (!isLoading) {
                                        var data1 = await requestLoginAPI(
                                            context,
                                            usernameController.text,
                                            passwordController.text);
                                        setState(() {
                                          if (data1 != null) {
                                            pref.setString("session",
                                                DateTime.now().toString());
                                            print("Session Has St");
                                            isLoading = true;
                                          }
                                        });
                                        print('login data');
                                        print(data1);
                                        try {
                                          data = data1["depots"];
                                        } catch (e) {
                                          print("==Login Error========$data1");
                                        }
                                        if (data != null &&
                                            (data1["role"] == "Driver")) {
                                          if (data.length == 1) {
                                            depotChosen = data[0];
                                            setState(() {
                                              isLoading = false;
                                            });
                                            chooseDepot(context, this);
                                          } else {
                                            SystemChannels.textInput
                                                .invokeMethod('TextInput.hide');
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChooseDepotPage()));
                                          }
                                        } else if (data1["role"] ==
                                            "Engineer") {
                                          if (data.length == 1) {
                                            depotChosen = data[0];
                                            setState(() {
                                              isLoading = false;
                                            });
                                            chooseDepot(context, this);
                                          }
                                          // driverEmotion(context,"Eng");

                                          //Navigator.pushNamed(context, '/dashboard');
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      }
                                    },
                                    child: Center(
                                      child: AutoSizeText("SIGN IN",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Poppins-Bold",
                                              fontSize: 18,
                                              letterSpacing: 1.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 2),
                                    child: GestureDetector(
                                        child: Text("How to use this App?",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontFamily: "Poppins-Medium",
                                              fontSize:
                                                  new ScreenUtil().setSp(30),
                                              fontWeight: FontWeight.bold,
                                            )),
                                        onTap: () => {playVideo(context)}))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 00, horizontal: 0),
                                    child: Text("Powered by",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: "Poppins-Medium",
                                          fontSize: new ScreenUtil().setSp(14),
                                          fontWeight: FontWeight.bold,
                                        )))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: Image.asset(
                                  "assets/images/image_04.png",
                                  width: new ScreenUtil().setWidth(200),
                                  height: new ScreenUtil().setHeight(100),
                                ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
