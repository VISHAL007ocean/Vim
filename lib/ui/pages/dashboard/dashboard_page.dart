import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:vim_mobile/common/functions/getUserInfo.dart';
import 'package:vim_mobile/common/functions/saveLogout.dart';
import 'package:vim_mobile/models/login/users_permissions.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';
import 'package:vim_mobile/ui/pages/dashboard/top_row.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<UserPermissionsModel>> permissions;

  var fullname;
  var companyId;
  var logoImageString;

  initState() {
    super.initState();
    _getUser();
    _getLogo();
    Future.delayed(Duration.zero, () {
      checkUpgrade(context);
    });
  }

  _getLogo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    logoImageString = preferences.getString("logoImageUrl");
    print("----login $logoImageString");
  }

  _getUser() async {
    await getRole().then((value) async {
      if (value == "Driver") {
        await getFullName().then((result) {
          setState(() {
            if (result != null) {
              fullname = result;
            } else {
              fullname = "";
            }
          });
        });
      } else if (value == "Engineer") {
        await getName().then((result) {
          setState(() {
            if (result != null) {
              fullname = result;
            } else {
              fullname = "";
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return fullname != null
        ? Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                leading:
                    Container() /*SizedBox.fromSize(
            size: Size.square(56.0),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(1.5),
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: vimButtonColor.withOpacity(.6), width: 2.5),
              ),
              child: GestureDetector(
                onTap: () => {},
                child: Icon(
                  Icons.menu,
                  color: vimButtonColor,
                ),
              ),
            ),
          )*/
                ,
                actions: <Widget>[
                  SizedBox.fromSize(
                    size: Size.square(56.0),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(1.5),
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: vimButtonColor.withOpacity(.6), width: 2.5),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          await saveLogout();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login', (Route<dynamic> route) => false);
                        },
                        child: Icon(
                          Icons.exit_to_app,
                          color: vimButtonColor,
                        ),
                      ),
                    ),
                  ),
                ]),
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  color: Colors.white,
                ),
                SingleChildScrollView(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            AutoSizeText(
                              "Hello",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 2.5,
                              ),
                            ),
                            AutoSizeText(
                              '$fullname',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 35.0,
                                fontWeight: FontWeight.w300,
                                height: 1.15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                            AutoSizeText(
                              '${formatDate(DateTime.now(), [
                                    dd,
                                    '-',
                                    mm,
                                    '-',
                                    yyyy,
                                    ' ',
                                    hh,
                                    ':',
                                    nn,
                                    ':',
                                    am
                                  ])}',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                                height: 1.75,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.all(5.0), //TODO brandiing
                              // child: Image.asset(
                              //   "assets/images/image_01.png",
                              //   width: MediaQuery.of(context).size.width,
                              //   height: 200,
                              // ),
                              child: Image.network(
                                logoImageString,
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.5),
                              child: AutoSizeText(
                                "Vehicle Incident Management",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 2.5,
                                ),
                              ),
                            ), //TODO Branding
                          ],
                        ),
                      ),
                      TopRowWidget(),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                color: vimPrimary,
              ),
            ),
          );
  }

  Widget dashboardTile(String title, String subtitle) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(bottom: 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              offset: Offset(0, 0),
              blurRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            child: InkWell(
              highlightColor: Colors.white.withAlpha(50),
              onTap: () {
                Navigator.pushNamed(context, '/incidents');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/logo.png',
                              width: 60.0,
                              height: 60.0,
                            ),
                            AutoSizeText(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        AutoSizeText(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(
                          color: Colors.grey[300],
                          height: 25,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  checkUpgrade(BuildContext context) async {
    Upgrader upgrader = Upgrader();
    await upgrader.initialize();

//-- Check if update available
    if (upgrader.isUpdateAvailable()) {
      upgrader.showIgnore = false;
      upgrader.debugLogging = true;
      upgrader.showLater = false;
      upgrader.canDismissDialog = false;
      upgrader.dialogStyle = UpgradeDialogStyle.cupertino;
      upgrader.onLater = () {
        exit(0);
      };

      // -- Show Update Dialog
      upgrader.checkVersion(context: context);
    }
  }
}
