import 'package:flutter/material.dart';
import 'package:vim_mobile/ui/components/ui/animatedtext.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';

class MainDrawer extends StatelessWidget {
  MainDrawer({this.key, this.text}) : super(key: key);
  final Key key;
  final String text;
  final int notifications = 2;

  Widget build(BuildContext context) {
    Icon _icon = Icon(Icons.notifications, color: Colors.white, size: 30.0);

    if (notifications > 0) {
      _icon =
          Icon(Icons.notification_important, color: Colors.white, size: 30.0);
    }
    return Drawer(
        child: Stack(children: <Widget>[
      Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(60.0),
            decoration: BoxDecoration(
              color: vimPrimary,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.1), BlendMode.dstATop),
                image: AssetImage('assets/images/home-background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AnimatedTitleText(
                  title: 'Marsh',
                  fontSize: 30.0,
                  fontFamily: 'Serif',
                  color: vimAccent,
                  duration: 100,
                ),
                AnimatedTitleText(
                  title: 'Underwriting',
                  fontSize: 25.0,
                  fontFamily: 'Serif',
                  color: vimAccent,
                  duration: 100,
                ),
                Image.asset(
                  'assets/images/marsh_logo.png',
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height / 8,
                ),
                AnimatedTitleText(
                  title: 'Welcome Kieron Moorcroft',
                  fontSize: 14.0,
                  fontFamily: 'Serif',
                  color: vimAccent,
                  duration: 64,
                ),
              ],
            ),
          ),
          ListTile(
              leading: Icon(Icons.event),
              title: Text('Report'),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard');
              }),
          Divider(height: 16.0),
          ListTile(
              leading: Icon(Icons.forum),
              title: Text('Forums'),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard');
              }),
          Divider(height: 16.0),
        ],
      ),
      Align(
        alignment: Alignment.topRight,
        child: Container(
          padding: EdgeInsets.fromLTRB(0.0, 25.0, 15.0, 0.0),
          // child: Badge(
          //   child: _icon,
          //   badgeContent: Text('$notifications'),
          // )
        ),
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 15,
              child: TextButton(
                  style: TextButton.styleFrom(
                      textStyle: TextStyle(color: Colors.white)),
                  child: Text('Logout'),
                  onPressed: () {})))
    ]));
  }
}
