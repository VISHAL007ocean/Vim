import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_settings/card_settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vim_mobile/common/api_functions/auth_login/requestUserInfo.dart';
import 'package:vim_mobile/common/api_functions/engineer/vehicle/vehiclelist.dart';
import 'package:vim_mobile/common/custom_widgets/title_icon.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/common/functions/getUserInfo.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/engineer/job_list/dummy_job_list_model.dart';
import 'package:vim_mobile/models/engineer/vehicle/vehiclelistmodel.dart';
import 'package:vim_mobile/ui/components/pageComponents/CardSettingsGenericWidget.dart';
import 'package:vim_mobile/ui/components/pageComponents/loadingSplash.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';
import 'package:vim_mobile/ui/pages/damage_report/getDamageVehicle.dart';

dynamic vehicleChosen;
bool isLoading = true;
bool isLoading2 = false;

class ChooseDamageVehiclePage extends StatefulWidget {
  final StatefulWidget nextPage;
  final int vehCheck;
  final int fltCheck;
  ChooseDamageVehiclePage(this.nextPage, this.vehCheck, this.fltCheck);

  @override
  _ChooseDamageVehicleState createState() => new _ChooseDamageVehicleState();
}

class _ChooseDamageVehicleState extends State<ChooseDamageVehiclePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  Future<bool> chooseVehicle(BuildContext context, State state) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await requestUserInfo();
    await preferences.setString(
        'CurrentVehicleId', vehicleChosen["id"].toString());

    await preferences.setString(
        'companyCode', vehicleChosen["companyCode"].toString());

    VehicleLocalModel localModel = VehicleLocalModel();
    localModel.year = vehicleChosen["year"];
    localModel.registration = vehicleChosen["registration"];
    localModel.model = vehicleChosen["model"];
    localModel.make = vehicleChosen["make"];
    localModel.colour = vehicleChosen["colour"];

    String vehInfo = jsonEncode(localModel);

    await preferences.setString('CurrentVehicleInfo', vehInfo);
    //TODO for driver

    state.setState(() {});
    return true;
  }

  Future<bool> chooseEngVehicle(BuildContext context, State state) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // await requestUserInfo();
    await preferences.setString('CurrentVehicleId', vehModel.id.toString());
    await preferences.setString('CurrentDepotId', vehModel.depotId.toString());
    await preferences.setString(
        'CurrentCompanyId', vehModel.companyId.toString());
    await preferences.setString(
        'CurrentCompanyCode', vehModel.companyCode.toString());
    print("selected vehicle code");
    print(vehModel.companyCode);

    VehicleLocalModel localModel = VehicleLocalModel();
    localModel.year = vehModel.year;
    localModel.registration = vehModel.registration;
    localModel.model = vehModel.model;
    localModel.make = vehModel.make;
    localModel.colour = vehModel.colour;

    String vehInfo = jsonEncode(localModel);

    await preferences.setString('CurrentVehicleInfo', vehInfo);

    ///api/damagevehicle/GetVehicles

    state.setState(() {});

    return true;
  }

  Future<bool> chooseEngVehicleSaved(
      BuildContext context,
      State state,
      String ID,
      String regNo,
      String compID,
      String depotID,
      VehicleLocalModel model,
      String companyCode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // await requestUserInfo();
    await preferences.setString('CurrentVehicleId', ID);
    await preferences.setString('CurrentDepotId', depotID);
    await preferences.setString('CurrentCompanyId', compID);
    await preferences.setString('CurrentCompanyCode', companyCode);
    model.registration = ID;
    String vehInfo = jsonEncode(model);

    await preferences.setString('CurrentVehicleInfo', vehInfo);
    state.setState(() {});
    return true;
  }

  Future<List<dynamic>> fList;
  List<dynamic> data = List<dynamic>();
  MediaQueryData mediaQuery;
  TextEditingController regNoController = TextEditingController();
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController dvrNoController = TextEditingController();
  TextEditingController velcamController = TextEditingController();
  TextEditingController cableNotesController = TextEditingController();

  List<JobFilterModel> vehCam = <JobFilterModel>[];
  VehList vehModel = VehList();
  int statusIdChosen;
  String vehCamChosen;
  String role = "";
  bool showFields = false;

  @override
  void initState() {
    getUser();

    vehCam = DummyJobListModel().getDummyVehCamStatus();
    statusIdChosen = vehCam[0].value;
    vehCamChosen = vehCam[0].name;
    getDamageVehicles(0).then((result) {
      setState(() {
        data = result;
        isLoading = false;
      });
    });
    super.initState();
  }

  clearVars() {
    vehicleChosen = null;
    isLoading = true;
  }

  getUser() async {
    await getRole().then((value) async {
      setState(() {
        role = value;
      });
    });
  }

  vehicleThumbs(List<dynamic> vehicleList) {
    var list = <Widget>[];
    if (data.length > 0) {
      for (int i = 0; i < data.length; i++) {
        list.add(
          ListTile(
              title: AutoSizeText(
                data[i]["registration"],
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              onTap: () async {
                print('vehCheck == 1');
                setState(() {
                  // SharedPreferences preferences = await SharedPreferences.getInstance();
                  // preferences.setString('companyCode', data[i]["companyCode"] );
                  // print(data[i]["companyCode"] );
                  print(data[i]);
                  saveCode(data[i]["companyCode"], data[i]["companyName"],
                      data[i]["depotName"]);
                  chooseVehicle(context, this).then((result) =>
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => widget.nextPage)));

                  /*chooseVehicle(context, this).then((result) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => widget.nextPage)));*/
                });

                vehicleChosen = data[i];
              }),
        );
      }
      return list;
    } else {
      return <Widget>[];
    }
  }

  saveCode(code, companyName, depotName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    print("==21-4-23======SET DEPO NAME $depotName");
    print("==21-4-23======SET companyCode $code");
    print("==21-4-23======SET companyName $companyName");

    preferences.setString('companyCode', code ?? "");
    preferences.setString('companyName', companyName);
    preferences.setString('depotName', depotName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                clearVars();
                Navigator.pop(context);
              }),
          backgroundColor: Colors.white,
          title: titleIcon(),
          centerTitle: true,
        ),
        body: isLoading2
            ? loadingSplash(
                context, "Saving Vehicle Information", "Please wait")
            : Stack(children: <Widget>[
                CardSettings(children: <CardSettingsSection>[
                  CardSettingsSection(children: [
                    CardSettingsGenericWidget(children: [
                      CardSettingsHeader(
                        color: vimPrimary,
                        label: "Please Choose A Vehicle.",
                        labelAlign: TextAlign.center,
                      ),
                      role == ""
                          ? loadingSplash(context, "Loading", "Please wait")
                          : (role.contains("Driver")
                              ? (Column(
                                  children: vehicleThumbs(data),
                                ))
                              : forEng(context)),
                      isLoading
                          ? loadingSplash(
                              context, "Getting vehicles", "Please wait")
                          : Container()
                    ])
                  ])
                ])
              ]));
  }

  Widget additionalQuestions(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    var style = theme.textTheme.subtitle1;
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardSettingsHeader(
              color: vimPrimary,
              label: "Vehicle Registration",
              labelAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5,
            ),
            CardSettingsText(
              hintText: "Enter Registration No",
              label: "Registration No",
              contentOnNewLine: true,
              controller: regNoController,
              enabled: false,
              onChanged: (val) {},
            ),
            SizedBox(
              height: 3,
            ),
            CardSettingsText(
              hintText: "Enter Make",
              label: "Make",
              contentOnNewLine: true,
              controller: makeController,
              enabled: false,
              onChanged: (val) {},
            ),
            SizedBox(
              height: 3,
            ),
            CardSettingsText(
              hintText: "Enter Model",
              label: "Model",
              contentOnNewLine: true,
              controller: modelController,
              enabled: false,
              onChanged: (val) {},
            ),
            SizedBox(
              height: 3,
            ),
            CardSettingsText(
              hintText: "Enter Colour",
              label: "Colour",
              contentOnNewLine: true,
              enabled: false,
              controller: colorController,
              onChanged: (val) {},
            ),
            SizedBox(
              height: 3,
            ),
            CardSettingsText(
              hintText: "Enter Year",
              label: "Year",
              contentOnNewLine: true,
              enabled: false,
              controller: yearController,
              onChanged: (val) {},
            ),
            SizedBox(
              height: 3,
            ),
            CardSettingsText(
              hintText: "Enter  DVR No",
              label: "DVR No",
              contentOnNewLine: true,
              controller: dvrNoController,
              onChanged: (val) {},
              validator: (value) => value == null ? 'field required' : null,
            ),
            SizedBox(
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Text(
                "Veh Cam System",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF5b5b5b)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<int>(
                items: vehCam.map((item) {
                  return DropdownMenuItem<int>(
                    child: new Text(
                      item.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    value: item.value,
                  );
                }).toList(),
                validator: (value) => value == null ? 'field required' : null,
                onChanged: (newVal) {
                  setState(() {
                    statusIdChosen = newVal;
                    vehCamChosen = vehCam[newVal].name;
                    //isLoading=true;
                  });
                },
                value: statusIdChosen,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            CardSettingsButton(
                backgroundColor: vimPrimary,
                label: ("Add Vehicle"),
                textColor: Theme.of(context).cardColor,
                onPressed: () {
                  setState(() {
                    if (formKey.currentState.validate()) {
                      //TODO Save
                      saveVehicleInfo(context);
                    }
                  });
                })
          ],
        ),
      ),
    );
  }

  Widget forEng(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5, top: 5),
            child: TypeAheadFormField(
              noItemsFoundBuilder: (value) {
                return Text(
                  " No Vehicle Found",
                );
              },
              textFieldConfiguration: TextFieldConfiguration(
                  cursorColor: vimPrimary,
                  onTap: () {},
                  controller: cableNotesController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF56122f), width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF56122f), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF56122f), width: 1.0),
                    ),
                    hintText: "Search Vehicle Here",
                    isDense: true,
                  )),
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  borderRadius: BorderRadius.circular(6), color: vimSecondary),
              suggestionsCallback: (pattern) async {
                if (pattern.length > 0) {
                  return await getVehList(pattern);
                }
                return null;
              },
              itemBuilder: (context, suggestion) {
                VehList dl = suggestion;
                return ListTile(
                  title: Text(
                    dl.registration != null
                        ? dl.registration
                        : (dl.vrm != null ? dl.vrm : " "),
                  ),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                /*scrollanimateTo(scrollposition.maxScrollExtent - SizeConfig.blockSizeVertical * 15,duration: const
                  Duration(milliseconds: 300),curve: Curves.easeOut);*/
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                VehList model = suggestion;
                if (model.registration != null) {
                  setState(() {
                    showFields = false;
                    vehModel = model;

                    if (widget.vehCheck == 1) {
                      print('check status');

                      if (widget.fltCheck == 0) {
                        checkVehicleStatus(vehModel.registration, context)
                            .then((value) {
                          if (value == true) {
                            saveCode(vehModel.companyCode, vehModel.companyName,
                                vehModel.depotName);
                            chooseEngVehicle(context, this).then((result) =>
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            widget.nextPage)));
                          }
                        });
                      } else {
                        // check flt status
                        checkFltStatus(vehModel.registration, context)
                            .then((value) {
                          if (value == true) {
                            saveCode(vehModel.companyCode, vehModel.companyName,
                                vehModel.depotName);
                            chooseEngVehicle(context, this).then((result) =>
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            widget.nextPage)));
                          }
                        });
                      }
                    } else {
                      chooseEngVehicle(context, this).then((result) =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => widget.nextPage)));
                    }
                  });
                } else {
                  setState(() {
                    showFields = true;
                    makeController.text = model.make;
                    regNoController.text = model.vrm;
                    modelController.text = model.model;
                    colorController.text = model.colour;
                    yearController.text = model.yearOfManufacture;
                  });
                }

                cableNotesController.clear();
                //TODO pass veh id to next
              },
              onSaved: (value) {
                //controller.setCity(value);

                print("bol");
              },
            ),
          ),
          SizedBox(
            height: 5,
          ),
          if (showFields) additionalQuestions(context),
        ],
      ),
    );
  }

  //TODO Save model
  saveVehicleInfo(BuildContext context) async {
    String messageTitle;
    String message;
    var url;
    var token;
    var dio = new Dio();
    //var dc = jobCheck.questionAnswer.to;
    //TODO Body

    VehicleSaveModel saveModel = VehicleSaveModel();
    VehicleLocalModel localModel = VehicleLocalModel();

    saveModel.registration = regNoController.text;
    saveModel.model = modelController.text;
    saveModel.colour = colorController.text;
    saveModel.make = makeController.text;
    saveModel.linkedDvr = dvrNoController.text;
    saveModel.year = int.parse(yearController.text);
    saveModel.vehcamSystem = vehCamChosen;

    localModel.registration = regNoController.text;
    localModel.model = modelController.text;
    localModel.colour = colorController.text;
    localModel.make = makeController.text;
    localModel.year = int.parse(yearController.text);

    var body = jsonEncode(saveModel);

    var vehID = "";
    var depotID = "";
    var compID = "";
    var compCode = "";

    setState(() {
      isLoading2 = true;
    });

    print(body);

    await getToken().then((result) {
      token = result;
    });

    dio.options.headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    List<DialogButton> buttons2 = [
      DialogButton(
        child: Text(
          "CLOSE",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ];

    List<DialogButton> buttons1 = [
      DialogButton(
        child: Text(
          "CLOSE",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            showFields = false;

            chooseEngVehicleSaved(context, this, vehID, regNoController.text,
                    compID, depotID, localModel, compCode)
                .then((result) => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => widget.nextPage)));
          });
        },
        width: 120,
      )
    ];

    try {
      //for type specific url

      url = BASE_URL + "/api/vehicles/Create";

      var response = await dio.post(url, data: body);
      print(response.data.toString());
      /* if(type=="M"){
        jobDoneId = response.data["maintenancerepairId"];
      }else if(type=="I"){
        jobDoneId = response.data["installationId"];
      }else if(type=="D"){
        jobDoneId = response.data["deinstallationId"];
      }*/

      setState(() {
        isLoading2 = false;
      });
      messageTitle = "Success";
      message = "Vehicle ID:" + response.data["vehicleId"].toString();
      setState(() {
        vehID = response.data["vehicleId"].toString();
        depotID = response.data["depot_Id"].toString();
        compID = response.data["company_Id"].toString();
        compCode = response.data["companyCode"].toString();
      });
      Alert(
              context: context,
              title: messageTitle,
              desc: message,
              buttons: buttons1)
          .show();
    } catch (e) {
      messageTitle = "Something went wrong!";
      message = e.toString();

      setState(() {
        isLoading2 = false;
      });
      Alert(
              context: context,
              title: messageTitle,
              desc: message,
              buttons: buttons2)
          .show();
      print(e.toString());
    }
  }
}
