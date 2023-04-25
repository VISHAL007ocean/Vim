import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:card_settings/card_settings.dart';
import 'package:card_settings/widgets/card_settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vim_mobile/common/custom_widgets/divider.dart';
import 'package:vim_mobile/common/custom_widgets/title_icon.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/incidents/incidents.dart';
import 'package:vim_mobile/common/functions/getUserId.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:vim_mobile/ui/components/pageComponents/CardSettingsGenericWidget.dart';
import 'package:vim_mobile/ui/components/pageComponents/VimCardSettingsHeader.dart';
import 'package:vim_mobile/ui/components/pageComponents/VimCardSettingsInt.dart';
import 'package:vim_mobile/ui/components/pageComponents/VimCardSettingsText.dart';
import 'package:vim_mobile/ui/components/pageComponents/goHome.dart';
import 'package:vim_mobile/ui/components/pageComponents/loadingSplash.dart';
 import 'package:vim_mobile/ui/components/ui/colours.dart';
import 'package:vim_mobile/ui/pages/dashboard/dashboard_page.dart';
import 'package:vim_mobile/ui/components/pageComponents/SwitchWidget.dart'
as VimSwitch;
import 'package:vim_mobile/ui/pages/engineer/incidents/eng_report_page.dart';

import '../damage_report/damage_choose_vehicle.dart';

class VehicleInspectionHistoryDetail extends StatefulWidget {

  @override
  _VehicleInspectionHistoryDetailState createState() => _VehicleInspectionHistoryDetailState();
}

class _VehicleInspectionHistoryDetailState extends State<VehicleInspectionHistoryDetail> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  Future<List<Incidents>> incidents;
  Future<List<vehicleInspection>> vehicleInspectionList;
  List<dynamic> answers;
  dynamic userdata;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Uint8List _bytesImage;

  initState()  {
    super.initState();
    //incidents = _getIncidents();
   // vehicleInspectionList = _getVehicleInspectionList();
   //userdata =  _getVehicleInspectionDetail();

  }

  dispose() {
    super.dispose();
  }



  Future<dynamic> _getVehicleInspectionDetail() async {
    var list;
    var userId;
    var token;

    await getToken().then((result) {
      token = result;
    });

    await getUserId().then((result) {
      userId = result;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
     var getId = preferences.getString(
        'historyId');


    final response =
    await http.get(Uri.parse(BASE_URL + '/api/vehicles/GetVehicleCheckDetails?id=$getId'), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    var jsonData = json.decode(response.body);

    // List<vehicleInspection> vehicleInspectionList = [];
    //
    // for (var i in jsonMailList) {
    //   vehicleInspection vehicleList = vehicleInspection(i["id"], i["reference"], i["createdTime"],
    //       i["depotName"], i["registration"],i['createdBy'],i['createdOn']);
    //
    //   vehicleInspectionList.add(vehicleList);
    // }

    // print(jsonData.length);
    // print(jsonData);
    userdata = jsonData;
    print("userdata");
    print(userdata["company"]);
    answers = userdata["answers"];
    print(answers);
    _bytesImage = Base64Decoder().convert(userdata["signature"]);
    for (var i = 0; i < answers.length ; i++) {
    if (i==0 || answers[i]["group"] != answers[i-1]["group"]) {
       print(answers[i]["group"]);
     }

    }
    return jsonData;
  }

  Future<Null> _refresh() async {
    setState(() {
    //  vehicleInspectionList = _getVehicleInspectionList();
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
            future: _getVehicleInspectionDetail(),//_getIncidents(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                   return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  return ListView(children: [
                    CardSettings(showMaterialonIOS: true, children: [
                      CardSettingsSection(children: [
                        CardSettingsGenericWidget(children: [


                          VimCardSettingsHeader(
                            label: "General Information",
                            labelAlign: TextAlign.center,
                            color: vimPrimary,
                          ),
                          SizedBox(height: 10,),


                          CardSettingsGenericWidget(children: [
                            Row(children: <Widget>[

                              SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                //question text
                                "Driver Check Reference:",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                maxLines: 1,
                              ),
                            ]),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: AutoSizeText(
                                      '${userdata['reference']??''}',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.start),
                                ),
                              ],
                            ),
                            //text form
                           ]),
                          CardSettingsGenericWidget(children: [
                            Row(children: <Widget>[

                              SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                //question text
                                "Company Name:",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                maxLines: 1,
                              ),
                            ]),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: AutoSizeText(
                                      '${userdata['company']??''}',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.start),
                                ),
                              ],
                            ),
                            //text form
                          ]),
                          CardSettingsGenericWidget(children: [
                            Row(children: <Widget>[

                              SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                //question text
                                "Depot Name:",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                maxLines: 1,
                              ),
                            ]),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: AutoSizeText(
                                      '${userdata['depot']??''}',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.start),
                                ),
                              ],
                            ),
                            //text form
                          ]),
                          CardSettingsGenericWidget(children: [
                            Row(children: <Widget>[

                              SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                //question text
                                "Registration:",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                maxLines: 1,
                              ),
                            ]),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: AutoSizeText(
                                      '${userdata['registration']??''}',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.start),
                                ),
                              ],
                            ),
                            //text form
                          ]),
                          CardSettingsGenericWidget(children: [
                            Row(children: <Widget>[

                              SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                //question text
                                "Driver Name:",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                maxLines: 1,
                              ),
                            ]),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: AutoSizeText(
                                      '${userdata['driver']??''}',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.start),
                                ),
                              ],
                            ),
                            //text form
                          ]),
                          CardSettingsGenericWidget(children: [
                            Row(children: <Widget>[

                              SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                //question text
                                "User Location:",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                maxLines: 1,
                              ),
                            ]),
                            SizedBox(
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: AutoSizeText(
                                  '${userdata['actualLocation']??''}',
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.start,maxLines: 5,overflow: TextOverflow.ellipsis,),
                              ),
                            ),
                            //text form
                          ]),
                          CardSettingsGenericWidget(children: [
                            Row(children: <Widget>[

                              SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                //question text
                                "Actual Location:",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                maxLines: 1,
                              ),
                            ]),
                            SizedBox(
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: AutoSizeText(
                                    '${userdata['currentLocation']??''}',
                                    style: TextStyle(fontSize: 14),
                                    textAlign: TextAlign.start,maxLines: 5,overflow: TextOverflow.ellipsis,),
                              ),
                            ),
                            //text form
                          ]),
                          ...getGroups(),

                          VimCardSettingsHeader(
                            label: "Signature",
                            labelAlign: TextAlign.center,
                            color: vimPrimary,
                          ),
                          SizedBox(height: 10,),
                          Image.memory(_bytesImage)

                        ])
                      ])
                    ])
                  ]);
              }
            },
          ),
        ));
  }

  // @override
  // Widget build(BuildContext context){
  //   return WillPopScope(
  //       onWillPop: () => goHome(context, backTitle, backMessage, () => {}),
  //       child: Scaffold(
  //           key: _scaffoldKey,
  //           appBar: AppBar(
  //             leading: IconButton(
  //                 icon: Icon(Icons.arrow_back_ios, color: Colors.black),
  //                 onPressed: () {
  //                   goHome(context, backTitle, backMessage, () => {});
  //                 }),
  //             backgroundColor: Colors.white,
  //             title: titleIcon(),
  //             centerTitle: true,
  //           ),
  //           body: isLoading
  //               ? loadingSplash(
  //               context, "Getting damage report check questions", "Please wait")
  //               :
  //                 ListView(children: [
  //             CardSettings(showMaterialonIOS: true, children: [
  //               CardSettingsSection(children: [
  //                 CardSettingsGenericWidget(children: [
  //                   VimCardSettingsHeader(
  //                     label: "Vehicle Information",
  //                     labelAlign: TextAlign.center,
  //                     color: vimPrimary,
  //                   ),
  //
  //                   VimCardSettingsHeader(
  //                     label: "General Information",
  //                     labelAlign: TextAlign.center,
  //                     color: vimPrimary,
  //                   ),
  //                   SizedBox(height: 10,),
  //                   // CardSettingsText(
  //                   //   hintText: "Text",
  //                   //   // decoration: InputDecoration(
  //                   //   //   contentPadding: EdgeInsets.all(15.0),
  //                   //   //   border: OutlineInputBorder(
  //                   //   //     borderSide: BorderSide(color: Color(0xFF56122f), width: 1.0),
  //                   //   //   ),
  //                   //   //   focusedBorder: OutlineInputBorder(
  //                   //   //     borderSide: BorderSide(color: Color(0xFF56122f), width: 1.0),
  //                   //   //   ),
  //                   //   //   enabledBorder: OutlineInputBorder(
  //                   //   //     borderSide: BorderSide(color: Color(0xFF56122f), width: 1.0),
  //                   //   //   ),
  //                   //   //
  //                   //   //   hintText: "location",
  //                   //   //   isDense: true,
  //                   //   // ),
  //                   //   label: "Driver Name",
  //                   //   contentOnNewLine: true,
  //                   //   controller: driverNameController,
  //                   //   onChanged: (val) =>
  //                   //   {damageCheck.driverName = val},
  //                   // ),
  //                   CardSettingsGenericWidget(children: [
  //                     Row(children: <Widget>[
  //
  //                       SizedBox(
  //                         width: 10,
  //                       ),
  //                       AutoSizeText(
  //                         //question text
  //                         "Driver Name",
  //                         style: TextStyle(
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 16),
  //                         maxLines: 1,
  //                       ),
  //                     ]),
  //                     //text form
  //                     Padding(
  //                       padding: const EdgeInsets.only(left:12.0,right: 12,top: 5,bottom: 10),
  //                       child: TextFormField(
  //                         //internal padding in form
  //                         decoration: InputDecoration(
  //                           contentPadding: EdgeInsets.all(15.0),
  //                           border: OutlineInputBorder(
  //                             borderSide: BorderSide(color: Color(0xFF56122f), width: 1.0),
  //                           ),
  //                           focusedBorder: OutlineInputBorder(
  //                             borderSide: BorderSide(color: Color(0xFF56122f), width: 1.0),
  //                           ),
  //                           enabledBorder: OutlineInputBorder(
  //                             borderSide: BorderSide(color: Color(0xFF56122f), width: 1.0),
  //                           ),
  //
  //                           hintText: "Driver Name",
  //                           isDense: true,
  //                         ),
  //                         autocorrect: true,
  //                         enableSuggestions: true,
  //
  //                         controller: driverNameController,
  //                         onChanged: (val) =>
  //                         { },
  //                       ),
  //                     )
  //                   ]),
  //                   CardSettingsGenericWidget(children: [
  //                     Row(children: <Widget>[
  //                       SizedBox(
  //                         width: 10,
  //                       ),
  //                       //adds icon
  //                       Icon(
  //                         FontAwesomeIcons.globe,
  //                         color: Colors.black,
  //                         size: 30.0,
  //                       ),
  //                       SizedBox(
  //                         width: 10,
  //                       ),
  //                       AutoSizeText(
  //                         //question text
  //                         "Location:",
  //                         style: TextStyle(
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 16),
  //                         maxLines: 1,
  //                       ),
  //                     ]),
  //                     //text form
  //                     Padding(
  //                       padding: const EdgeInsets.only(left:12.0,right: 12,top: 5,bottom: 10),
  //                       child: TextFormField(
  //                         //internal padding in form
  //                         decoration: InputDecoration(
  //                           contentPadding: EdgeInsets.all(15.0),
  //                           border: OutlineInputBorder(
  //                             borderSide: BorderSide(color: Color(0xFF56122f), width: 1.0),
  //                           ),
  //                           focusedBorder: OutlineInputBorder(
  //                             borderSide: BorderSide(color: Color(0xFF56122f), width: 1.0),
  //                           ),
  //                           enabledBorder: OutlineInputBorder(
  //                             borderSide: BorderSide(color: Color(0xFF56122f), width: 1.0),
  //                           ),
  //
  //                           hintText: "location",
  //                           isDense: true,
  //                         ),
  //                         autocorrect: true,
  //                         enableSuggestions: true,
  //                         readOnly: true,
  //                         enabled: false,
  //                         controller: locationController,
  //                       ),
  //                     )
  //                   ]),
  //                   ...getGroups(),
  //
  //
  //                 ])
  //               ])
  //             ])
  //           ])
  //       )
  //   ) ;
  // }


  List<Widget> getGroups() {
    List<Widget> list = [];
   // List<CreateDriverCheckAnswers> answers = damageCheck.driverChecksAnswers;

    if (answers != null) {
      for (var i = 0; i < answers.length; i++) {
        //Instantiate and populate answers
        if (answers.length < answers.length) {
          //   print("groups print");
          // print(questions[i]);
          // CreateDriverCheckAnswers answer = new CreateDriverCheckAnswers(
          //     questions[i]["questionId"], questions[i]["questionType"], "",
          //     "");

        }

        //Display the group header if the group name is different to the previous question
        if (list.length == 0 ||
            answers[i]["group"] != answers[i - 1]["group"]) {
          list.add(new VimCardSettingsHeader(
            label: answers[i]["group"],
            labelAlign: TextAlign.center,
            color: vimPrimary,
          ));
        }

       // QuestionTypes type =  answers[i]["type"];
        QuestionTypes type = QuestionTypes.values[1];
     /*    if(answers[i]["type"] == "passFail")
           {
               type =  QuestionTypes.values[0];
           }
        if(answers[i]["type"] == "freeText")
        {
            type =  QuestionTypes.values[1];
        }
        if(answers[i]["type"] == "longText")
        {
          type =  QuestionTypes.values[2];
        }
        if(answers[i]["type"] == "number")
        {
          type =  QuestionTypes.values[3];
        }
        if(answers[i]["type"] == "date")
        {
          type =  QuestionTypes.values[4];
        }
        if(answers[i]["type"] == "datetime")
        {
          type =  QuestionTypes.values[5];
        }
        if(answers[i]["type"] == "image")
        {
          type =  QuestionTypes.values[6];
        }
        if(answers[i]["type"] == "yesNo")
        {
          type =  QuestionTypes.values[7];
        }*/



        //Question body
        list.add(
            processQuestionType(answers[i]["question"], type, answers[i]["answer"]));

        list.add(questionDivider());
      }
    }
    print(list);
    return list;
  }

  CardSettingsWidget processQuestionType(String title, QuestionTypes type,
     String answer) {
    var theme = Theme.of(context);
    var style = theme.textTheme.subtitle1;
    style = style.copyWith(color: theme.disabledColor);

    switch (type) {
      case QuestionTypes.date:

        return CardSettingsGenericWidget(children: [
          VimCardSettingsText(
            labelAlign: TextAlign.center,
            contentOnNewLine: true,
            enabled: false,
            label: title,
          ),
          CardSettingsDatePicker(
            label: "Date",
            dateFormat: DateFormat("dd-MM-yyyy"),

            onChanged: (input) => {
              answer = DateFormat("yyyy-MM-dd").format(input)
            },
          )
        ]);

      case QuestionTypes.datetime:
        if (answer  == null || answer == "") {
          answer =
              DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
        }
        return CardSettingsGenericWidget(
          children: [
            // VimCardSettingsText(
            //   labelAlign: TextAlign.center,
            //   contentOnNewLine: true,
            //   enabled: false,
            //   label: title,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10,),
                AutoSizeText(
                  //question text
                  title,
                  style: TextStyle(
                      color: theme.disabledColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  maxLines: 1,
                ),
              ],
            ),
            CardSettingsDatePicker(
              initialValue: DateTime.now(),
              label: "Date",
              dateFormat: DateFormat("dd-MM-yyyy"),
              onChanged: (input) => {
                // answerController.answer = dateTimeBuilder(
                //     input.toString().split(" ")[0], answerController.answer)
              },
            ),
            CardSettingsTimePicker(
                initialValue: TimeOfDay.now(),
                label: "Time",
                onChanged: (input) => {

                })
          ],
        );

      case QuestionTypes.freeText:

        return VimCardSettingsText(
          hintText: "Text",
          maxLength: 255,
          contentOnNewLine: true,
          label: title,
          initialValue: answer,
          enabled: false,
          onChanged: (input) => {answer = input},
          //  onChanged: (input) => {answerController.answer = input},
        );

      case QuestionTypes.image:
        return CardSettingsGenericWidget(
          children: [
            // VimCardSettingsText(
            //   labelAlign: TextAlign.center,
            //   enabled: true,
            //   contentOnNewLine: true,
            //   label: title,
            //   onChanged:(input) => {answerController.answer = input},
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10,),
                AutoSizeText(
                  //question text
                  title,
                  style: TextStyle(
                      color: theme.disabledColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  maxLines: 1,
                ),
              ],
            ),
            SizedBox(height:10),
            //...imageWidget(answerController),
            SizedBox(height:10),
          ],
        );

      case QuestionTypes.longText:
        return CardSettingsParagraph(
          hintText: "Text",
          maxLength: 255,
          label: title,

          contentOnNewLine: true,
          onChanged: (input) => {answer = input},
        );

      case QuestionTypes.number:
        return VimCardSettingsInt(
          contentOnNewLine: true,
          label: title,
          hintText: "Text",
          onChanged: (input) => {answer = input.toString()},
        );
      case QuestionTypes.passFail:
        if (answer == "" || answer == null) {
         answer = "Fail";
        }
        return new CardSettingsGenericWidget(children: [
          VimSwitch.CreateDriverSwitch(
            //controller: answer,
            questionLabel: title,
            trueLabel: "Pass",
            falseLabel: "Fail",
            notesLabel: "Notes",
            hintText: "Required if question has failed.",
            numLines: 4,
            stateFunction: setState,
           // imagesFunction: imageWidget,
            hideOnFail: true,

          )
        ]);
      case QuestionTypes.YesNoUnsure:

        String _yesNoValue = "Yes";
        return   CardSettingsGenericWidget(children: [
          Row(children: <Widget>[
            SizedBox(
              width: 10,
            ),

            AutoSizeText(
              title,
              style: TextStyle(
                  color: theme.disabledColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ]),
          SizedBox(height: 10,),
          buildCardWidget(DropdownButtonFormField<String>(
            //underline: const SizedBox(),
            focusColor: Colors.white,
            isExpanded: true,
            items: <String>['Yes', 'No', 'Unsure'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text(_yesNoValue),
            value: _yesNoValue,
            decoration: InputDecoration(border: InputBorder.none),
            onChanged: (newValue) {
              setState(
                    () {
                  _yesNoValue = newValue;
                  print("value changed");
                   answer = _yesNoValue;
                },
              );
            },

          ),
          ),
          SizedBox(height: 10,),
        ]);

      case QuestionTypes.ThirdPartyMySelfUnsure:

        return VimSwitch.CreateDriverDropdown(
        //  controller: answerController,
          questionLabel: title,
          trueLabel: "",
          falseLabel: "",
          notesLabel: "",
          hintText: "",
          numLines: 4,
          stateFunction: setState,
          //imagesFunction: imageWidget,
          hideOnFail: false,
        );
    //  String _dropValue = "Third-Party";
    //
    //  return   CardSettingsGenericWidget(children: [
    //    Row(children: <Widget>[
    //      SizedBox(
    //        width: 10,
    //      ),
    //
    //      AutoSizeText(
    //        title,
    //        style: TextStyle(
    //            color: theme.disabledColor,
    //            fontWeight: FontWeight.bold,
    //            fontSize: 16),
    //
    //      ),
    //    ]),
    //    SizedBox(height: 10,),
    //    buildCardWidget(DropdownButton<String>(
    //      underline: const SizedBox(),
    //      focusColor: Colors.white,
    //      isExpanded: true,
    //      items: <String>['Third-Party', 'My-Self', 'Unsure'].map((String value) {
    //        return DropdownMenuItem<String>(
    //          value: value,
    //          child: Text(value),
    //        );
    //      }).toList(),
    //      hint: Text(_dropValue),
    //      onChanged: (value) {
    //        setState(
    //              () {
    //                _dropValue = value;
    //            answerController.answer = _dropValue;
    //            //  widget?.onChanged(_dropDownValue);
    //          },
    //        );
    //      },
    //
    //    )
    //    ),
    //    SizedBox(height: 10,),
    //
    //  ]);
      default:
        return VimSwitch.CreateDamageSwitch(
      //    controller: answerController,
          questionLabel: title,
          trueLabel: "Yes",
          falseLabel: "No",
          notesLabel: "Notes",
          hintText: "Text",
          numLines: 4,
          stateFunction: setState,
         // imagesFunction: imageWidget,
          hideOnFail: false,
        );
    }
  }
  buildCardWidget(Widget child) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.black, width: 1),
          borderRadius:
          BorderRadius.all(Radius.circular(4))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
        child: child,
      ),
    );
  }

// List<Widget> imageWidget() {
  //   List<Widget> list = [];
  //   bool multiples =
  //       answerController.images != null && answerController.images.length > 0;
  //
  //   if (answerController.images != null) {
  //     answerController.images.forEach((image) => {
  //       list.add(ListTile(
  //         leading: Image(image: FileImage(image)),
  //         title: AutoSizeText(
  //           'Tap to enlarge',
  //           textAlign: TextAlign.left,
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
  //         ),
  //         trailing: GestureDetector(
  //           child: Icon(Icons.delete),
  //           onTap: () {
  //             setState(() {
  //               answerController.images.remove(image);
  //             });
  //           },
  //         ),
  //         onTap: () =>
  //         largeImage(Image(image: FileImage(image)), context).show,
  //       ))
  //     });
  //   }
  //
  //   list.add(CardSettingsButton(
  //       label: multiples ? "Add Another Image" : "Add Image",
  //       textColor: Theme.of(context).cardColor,
  //       onPressed: () => onImagePressed(answerController)));
  //
  //   return list;
  // }
}
