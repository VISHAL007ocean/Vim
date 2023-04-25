import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vim_mobile/common/custom_widgets/title_icon.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/common/functions/getUserId.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/incidents/incidents.dart';

class VehicleInspectionHistory extends StatefulWidget {
  @override
  _VehicleInspectionHistoryState createState() =>
      _VehicleInspectionHistoryState();
}

class _VehicleInspectionHistoryState extends State<VehicleInspectionHistory> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<List<Incidents>> incidents;
  Future<List<vehicleInspection>> vehicleInspectionList;

  initState() {
    super.initState();
    vehicleInspectionList = _getVehicleInspectionList();
  }

  dispose() {
    super.dispose();
  }

  Future<List<vehicleInspection>> _getVehicleInspectionList() async {
    var list;
    var userId;
    var token;

    await getToken().then((result) {
      token = result;
    });

    await getUserId().then((result) {
      userId = result;
    });

    final response = await http.get(
        Uri.parse(BASE_URL + '/api/vehicles/GetVehicleCheckHistory'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });
    print("======== 20-4 =========responce body==== ${response.body}");

    if (response.body != "null") {
      var jsonData = json.decode(response.body);
      print("sdfsdfsd");
      var jsonMailList = jsonData["data"];
      List<vehicleInspection> vehicleInspectionList = [];

      for (var i in jsonMailList) {
        vehicleInspection vehicleList = vehicleInspection(
            i["id"],
            i["reference"],
            i["createdTime"],
            i["depotName"],
            i["registration"],
            i['createdBy'],
            i['createdOn']);

        vehicleInspectionList.add(vehicleList);
      }
      return vehicleInspectionList;
    } else {
      return null;
    }
    // print(jsonData.length);
    // print(jsonData);
    // print("Bearer $token");
  }

  Future<Null> _refresh() async {
    setState(() {
      vehicleInspectionList = _getVehicleInspectionList();
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
            future: _getVehicleInspectionList(), //_getIncidents(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print("snapshot Status : ${snapshot.hasData}");
              print("snapshot data : ${snapshot.data}");
              if (snapshot.data == null) {
                print("BBBBBBBBBBB");
                return Center(
                  child: Text("Data Not Found"),
                );
              } else {
                print("AAAAAAAAAAAA");
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
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    AutoSizeText(
                                        'Date: '
                                        '${snapshot.data[index].createdOn}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start),
                                    AutoSizeText(
                                        'By: '
                                        '${snapshot.data[index].createdBy}',
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                                onTap: () {
                                  saveSelected('${snapshot.data[index].id}');
                                },
                              ),
                            );
                          },
                        ));
                }
              }
            },
          ),
        ));
  }

  Future<void> saveSelected(selectedId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('historyId', selectedId.toString());
    Navigator.pushNamed(context, '/inspectionHistoryDetail');
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
