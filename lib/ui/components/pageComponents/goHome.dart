import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<bool> goHome(
    BuildContext context, String title, String message, Function() f) async {
  Function() g = f;
  return showDialog(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.button.color)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message),
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
                              Navigator.of(context).pop(false);
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: DialogButton(
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    'Go Home',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              onPressed: () {
                                g();
                                // Navigator.of(context).pop(false);
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/dashboard', (route) => false);
                                return true;
                              })),
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[],
          );
        },
      ) ??
      false;
}

Future<bool> goList(
    BuildContext context, String title, String message, Function() f) async {
  Function() g = f;
  return showDialog(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.button.color)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(2),
                          child: DialogButton(
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text("Close",
                                    style: TextStyle(color: Colors.white))),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: DialogButton(
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    'Go to Job List',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              onPressed: () {
                                g();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                return true;
                              })),
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[],
          );
        },
      ) ??
      false;
}
