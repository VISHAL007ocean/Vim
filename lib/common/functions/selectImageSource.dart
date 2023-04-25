import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';

selectImageSource(context, Function galleryFunc, Function cameraFunc) {
  Alert(
    context: context,
    type: AlertType.none,
    title: "GIVE EVIDENCE",
    desc: "Select from your gallery or take a picture to give as evidence.",
    buttons: [
      DialogButton(
        height: 50,
        width: 20,
        child: AutoSizeText(
          "GALLERY",
          style: TextStyle(color: Colors.white),
          maxLines: 2,
        ),
        onPressed: () async {
          galleryFunc();
        },
        color: vimPrimary,
      ),
      DialogButton(
        height: 50,
        width: 20,
        child: AutoSizeText("CAMERA",
            style: TextStyle(color: Colors.white), maxLines: 2),
        color: vimPrimary,
        onPressed: () async {
          cameraFunc();
        },
      ),
    ],
  ).show();
}
