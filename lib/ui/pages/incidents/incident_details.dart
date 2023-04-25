import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vim_mobile/common/custom_widgets/title_icon.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/incidents/incidents.dart';
import 'package:vim_mobile/common/functions/getUserId.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:vim_mobile/ui/pages/dashboard/dashboard_page.dart';

class IncidentDetails extends StatefulWidget {
  @override
  _IncidentDetailsState createState() => _IncidentDetailsState();
}

class _IncidentDetailsState extends State<IncidentDetails> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<List<Incidents>> incidents;

  initState() {
    super.initState();
    incidents = _getIncidents();
  }

  dispose() {
    super.dispose();
  }

  Future<List<Incidents>> _getIncidents() async {
    var list;
    var userId;
    var token;

    await getToken().then((result) {
      token = result;
    });

    await getUserId().then((result) {
      userId = result;
    });

    final response =
        await http.get(Uri.parse(BASE_URL + '/api/incidents/GetUserIncidents'), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    var jsonData = json.decode(response.body);

    List<Incidents> incidents = [];

    for (var i in jsonData) {
      Incidents incident = Incidents(i["id"], i["reference"], i["createdTime"],
          i["depotName"], i["registration"]);

      incidents.add(incident);
    }

    print(jsonData.length);

    return incidents;
  }

  Future<Null> _refresh() async {
    setState(() {
      incidents = _getIncidents();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard');
              }),
          backgroundColor: Colors.white,
          title: titleIcon(),
          centerTitle: true,
        ),
        body: Container(
          child: FutureBuilder(
            future: _getIncidents(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  return RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: _refresh,
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              leading: Image.asset(
                                'assets/images/logo.png',
                                width: 40.0,
                                height: 40.0,
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AutoSizeText(
                                      'Reference: '
                                      '${snapshot.data[index].reference}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.end),
                                  AutoSizeText(
                                      'Created At: '
                                      '${snapshot.data[index].createdTime}',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.end),
                                  AutoSizeText(
                                      'Registration: '
                                      '${snapshot.data[index].registration}',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.end)
                                ],
                              ),
                            ),
                          );
                        },
                      ));
              }
            },
          ),
        ));
  }

  // Widget createIncidentList(BuildContext context, AsyncSnapshot snapshot)
  // {
  //   return ListView.builder(
  //     itemCount: incidents.length,
  //     itemBuilder: (BuildContext context, int index) {
  //       return Column(
  //         children: <Widget>[
  //           ListTile(
  //             title: AutoSizeText(incidents[index].reference),
  //           ),
  //           Divider(height: 2.0)
  //         ],
  //       );
  //     },
  //   );
  // }
}
