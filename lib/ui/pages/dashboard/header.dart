import 'package:flutter/material.dart';
import 'package:vim_mobile/ui/components/ui/borderside.dart';
import 'package:date_format/date_format.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HeaderWidget extends StatelessWidget {
  HeaderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: VimBorderSide(),
          ),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          AutoSizeText(
            "Hello",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w200,
              letterSpacing: 2.5,
            ),
          ),
          AutoSizeText(
            'displayName',
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
            '${formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy, ' ', hh, ':', nn, ':', am])}',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
              height: 1.75,
            ),
          ),
        ]),
    );
  }
}

Widget header() {
  return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          AutoSizeText(
            "Hello",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w200,
              letterSpacing: 2.5,
            ),
          ),
          AutoSizeText(
            'displayName',
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
            '${formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy, ' ', hh, ':', nn, ':', am])}',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
              height: 1.75,
            ),
          ),
        ]);

}
