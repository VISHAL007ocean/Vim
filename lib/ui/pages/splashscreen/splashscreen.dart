import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';
import 'package:vim_mobile/ui/pages/login/login_page.dart';
import 'package:vim_mobile/ui/pages/dashboard/dashboard_page.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:http/http.dart' as http;

class Splashscreen extends StatefulWidget {
  Splashscreen();

  @override
  _SplashscreenState createState() => new _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  dynamic route;
  _SplashscreenState();
  @override
  void initState() {
    checkTokenExpiration();

    super.initState();
  }



  Future checkTokenExpiration() async {
    var token;
    var session;


    await getToken().then((result) {
      token = result;
    });

    await getSession().then((result) {
      session = result;



    });

    DateTime sessionDT=DateTime.parse(session);
    Duration diff= DateTime.now().difference(sessionDT);
    if(diff.inHours>12){
      setState(() {
        resetPrefs();
        route = LoginPage();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      });
    }else{
      final response = await http.get(
          Uri.parse(BASE_URL + '/api/incidents/GetUserInfo'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        setState(() {

          route = Dashboard();
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/dashboard', (Route<dynamic> route) => false);
        });
      } else {
        setState(() {
          route = LoginPage();
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: route,
      title: Text('Welcome to Vim Ltd',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
      image: Image.asset("assets/images/image_04.png"),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 100.0,
      onClick: () => print("Vim Ltd"),
      loaderColor: vimButtonColor,
    );
  }
}
