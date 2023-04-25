import 'package:flutter/material.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';

class VimListTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onPressed;

  VimListTile({
    Key key,
    this.icon,
    this.color,
    this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        circleIcon(icon: icon, color: color, small: true),
        textTile(title: title, small: true),
      ],
    );
  }
}

class VimGridTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subTitle;
  final VoidCallback onPressed;
  VimGridTile(
      {this.icon, this.color, this.title, this.subTitle, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      // padding: EdgeInsets.only(left: 10.0),
      // splashColor: color.withOpacity(.25),
      child: Row(
        children: <Widget>[
          circleIcon(icon: icon, color: color, small: true),
          textTile(title: title, subTitle: subTitle, small: true),
        ],
      ),
      onPressed: onPressed,
    );
  }
}

Widget circleIcon({IconData icon, Color color: vimAccent, bool small: false}) {
  return Align(
    child: Padding(
      child: CircleAvatar(
        backgroundColor: color,
        radius: small == true ? 14.0 : 20.0,
        child: Icon(
          icon,
          size: small == true ? 14.0 : 20.0,
          color: Colors.white,
        ),
      ),
      padding: EdgeInsets.only(right: (small == true ? 8.0 : 10.0)),
    ),
    alignment: Alignment.center,
  );
}

Widget textTile({String title, String subTitle, bool small: false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.black, fontSize: small == true ? 14.0 : 16.0),
      ),
      subTitle != null
          ? Text(
              subTitle,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300),
            )
          : Container(),
    ],
  );
}
