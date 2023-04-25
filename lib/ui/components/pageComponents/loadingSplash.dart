import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';

loadingSplash(BuildContext context, String title, String message) {
  return AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
      decoration: BoxDecoration(
          color: vimSecondary,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20.0)]),
      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          AutoSizeText(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: vimAccent,
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
          SpinKitDoubleBounce(color: vimAccent, size: 80.0),
          AutoSizeText(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: vimAccent,
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    ),
  );
}
