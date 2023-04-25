import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

errorMessage(BuildContext context, List<String> list, String title) {
  String s = "";
  list.forEach((errorMessage) {
    s += (errorMessage + "\n");
  });

  showDialog(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(s),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: DialogButton(
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Close",
                                style: TextStyle(color: Colors.white))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )),
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[],
      );
    },
  );
}
