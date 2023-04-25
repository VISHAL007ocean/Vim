import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logoImageString = "";
titleIcon() {
//
  _getLogo();
  return Padding(
    padding: EdgeInsets.all(70),
    child: Container(),
    // child: Image.asset(
    //   logoImageString,/*"assets/images/image_04.png",*/
    //    // width: 75,
    //     height: 75,
    //  // fit: BoxFit.contain,
    // )
  );

/*
   return FutureBuilder<String>(
     future: _getLogo(),
     builder: (context, snapshot) {
       if (snapshot.hasData) {
         Padding(
             padding: EdgeInsets.all(70),
             child: Image.network(
               snapshot.data,//"assets/images/image_04.png",
               // width: 75,
               height: 75,
               // fit: BoxFit.contain,
             ));
       }
       return CircularProgressIndicator();
     },
   );
*/
}

/*Future<String>  _getLogo() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  logoImageString = preferences.getString("logoImageUrl");
  return logoImageString;
 }*/

_getLogo() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  logoImageString = preferences.getString("logoImageUrl");
}
