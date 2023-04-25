import 'package:flutter/material.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:auto_size_text/auto_size_text.dart';

Widget timelineWidget (BuildContext context) {
    List<TimelineModel> items = [
       TimelineModel(
        Card(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 8.0,
                ),
                AutoSizeText('First Check'),
                const SizedBox(
                  height: 8.0,
                ),
                AutoSizeText(
                  'First Check',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        icon: Icon(Icons.filter_1),
        iconBackground: Colors.white),
        TimelineModel(
        Card(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 8.0,
                ),
                AutoSizeText('Second Check'),
                const SizedBox(
                  height: 8.0,
                ),
                AutoSizeText(
                  'Second Check',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        icon: Icon(Icons.filter_2),
        iconBackground: Colors.white),
      TimelineModel(
        Card(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 8.0,
                ),
                AutoSizeText(' Third Check'),
                const SizedBox(
                  height: 8.0,
                ),
                AutoSizeText(
                  'Third Check',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        icon: Icon(Icons.filter_3),
        iconBackground: Colors.white),
        TimelineModel(
        Card(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 8.0,
                ),
                AutoSizeText('Fourth Check'),
                const SizedBox(
                  height: 8.0,
                ),
                AutoSizeText(
                  'Fourth Check',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        icon: Icon(Icons.filter_4),
        iconBackground: Colors.white),
        TimelineModel(
        Card(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 8.0,
                ),
                AutoSizeText('Fifth Check'),
                const SizedBox(
                  height: 8.0,
                ),
                AutoSizeText(
                  'Fifth Check',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        icon: Icon(Icons.filter_5),
        iconBackground: Colors.white),
    ];
    return Timeline(children: items, position: TimelinePosition.Left  );
}
