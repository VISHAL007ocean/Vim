import 'dart:io';
import 'colours.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final _picker = ImagePicker();

class ImagePickerDialog extends StatefulWidget {
  final File image;

  ImagePickerDialog({Key key, this.image}) : super(key: key);

  @override
  _ImagePickerDialogState createState() =>
      _ImagePickerDialogState(image: image);
}

class _ImagePickerDialogState extends State<ImagePickerDialog> {
  File image;

  _ImagePickerDialogState({this.image});

  Widget build(BuildContext context) {
    return Container(
      child: dialog(),
    );
  }

  Widget dialog() {
    return SimpleDialog(
      title: Text(
        'Give Evidence',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: <Widget>[
        SimpleDialogOption(
            child: Row(children: <Widget>[
              Icon(
                FontAwesomeIcons.camera,
                color: vimButtonColor,
              ),
              const SizedBox(width: 10.0),
              Text('Take a photo', style: TextStyle(fontSize: 16.0))
            ]),
            onPressed: () async {
              Navigator.pop(context);
              PickedFile imageFile = await _picker.getImage(
                  source: ImageSource.camera, imageQuality: 50);
              setState(() {
                image = File(imageFile.path);
              });
            }),
        SimpleDialogOption(
            child: Row(children: <Widget>[
              Icon(FontAwesomeIcons.image, color: vimButtonColor),
              const SizedBox(width: 10.0),
              Text('Choose from Gallery', style: TextStyle(fontSize: 16.0))
            ]),
            onPressed: () async {
              Navigator.pop(context);
              PickedFile imageFile = await _picker.getImage(
                  source: ImageSource.gallery, imageQuality: 50);
              setState(() {
                image = File(imageFile.path);
              });
            }),
        SimpleDialogOption(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
