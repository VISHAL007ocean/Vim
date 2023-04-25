import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vim_mobile/common/custom_widgets/title_icon.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/lease_checks/LoadLeaseChecks.dart';
import 'package:vim_mobile/common/functions/getUserId.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';

class LeaseCheckDetails extends StatefulWidget {
  @override
  _LeaseChecksDetailsState createState() => _LeaseChecksDetailsState();
}

class _LeaseChecksDetailsState extends State<LeaseCheckDetails> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<List<LoadLeaseChecks>> leaseChecks;

  initState() {
    super.initState();
    leaseChecks = _getLeaseChecks();
  }

  dispose() {
    super.dispose();
  }

  Future<List<LoadLeaseChecks>> _getLeaseChecks() async {
    var list;
    var userId;
    var token;

    await getToken().then((result) {
      token = result;
    });

    await getUserId().then((result) {
      userId = result;
    });

    final response = await http
        .get(Uri.parse(BASE_URL + '/api/leasechecks/GetUserLeaseChecks'), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    var jsonData = json.decode(response.body);

    List<LoadLeaseChecks> leaseChecks = [];

    for (var i in jsonData) {
      LoadLeaseChecks leaseCheck = LoadLeaseChecks(
          i["id"],
          i["companyId"],
          i["startedTime"],
          i["endTime"],
          i["depotName"],
          i["leaseCheckCode"],
          i["status"],
          i["registration"]);

      leaseChecks.add(leaseCheck);
    }

    print(jsonData.length);

    return leaseChecks;
  }

  Future<Null> _refresh() async {
    setState(() {
      leaseChecks = _getLeaseChecks();
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
            future: _getLeaseChecks(),
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
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            elevation: 10,
                            child: ListTile(
                              title: AutoSizeText(
                                'Reference: ' +
                                    '${snapshot.data[index].leaseCheckCode}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: AutoSizeText(
                                'Depot: ' + '${snapshot.data[index].depotName}',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              leading:
                                  snapshot.data[index].status == "Authorised"
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 50,
                                        )
                                      : Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AutoSizeText(
                                      'Started at: '
                                      '${snapshot.data[index].startedTime}',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.end),
                                  AutoSizeText(
                                      'Ended at: '
                                      '${snapshot.data[index].endTime}',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.end),
                                  AutoSizeText(
                                      'Registration: '
                                      '${snapshot.data[index].registration}',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.end),
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
