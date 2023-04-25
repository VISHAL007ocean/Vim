import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vim_mobile/common/api_functions/engineer/job_list/job_list.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/consts/consts.dart';
import 'package:vim_mobile/models/engineer/job_list/dummy_job_list_model.dart';
import 'package:vim_mobile/models/engineer/job_list/job_list_model.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';
import 'package:vim_mobile/ui/pages/engineer/eng_checks/start_job_check.dart';

class JobList extends StatefulWidget {
  const JobList({Key key}) : super(key: key);

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<JobListModel> jobList = <JobListModel>[];

  int vehicleId;
  int companyId;
  String userId;
  SharedPreferences _preferences;
  TextEditingController reasonController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  int statusIdChosen;
  bool isLoading = true;

  List<JobFilterModel> jobStatus = <JobFilterModel>[];

  String backTitle = "Are you sure?";
  String backMessage =
      "Leaving this page will result in you losing all progress of your current driver check.";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    jobStatus = DummyJobListModel().getDummyJobStatus();
    statusIdChosen = jobStatus[0].value;
    getJobData(jobStatus[0].name);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  getJobData(String status) async {
    jobList = await getJobList(status);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                //goHome(context, backTitle, backMessage, () => {});
                Navigator.pop(context);
              }),
          backgroundColor: Colors.white,
          // title: titleIcon(),
          title: Text("Hello"),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<int>(
                  items: jobStatus.map((item) {
                    return DropdownMenuItem<int>(
                      child: new Text(
                        item.value == 0
                            ? "Accepted/Allocated/Pending"
                            : item.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      value: item.value,
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'field required' : null,
                  onChanged: (newVal) {
                    setState(() {
                      statusIdChosen = newVal;
                      isLoading = true;

                      getJobData(jobStatus[newVal].name);
                    });
                  },
                  value: statusIdChosen,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              isLoading
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF56122f),
                        ),
                      ),
                    )
                  : (jobList.isNotEmpty)
                      ? Expanded(
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: jobList.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              var model = jobList[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 2.0, bottom: 5.0),
                                child: InkWell(
                                  child: Card(
                                    shadowColor: Colors.black,
                                    elevation: 5.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Container(
                                        color: model.status == "Completed"
                                            ? Colors.lightGreen.shade200
                                            : model.status == "Accepted"
                                                ? Colors.yellow.shade200
                                                : model.status == "Pending"
                                                    ? Colors.pink.shade50
                                                    : Colors.white,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        AutoSizeText(
                                                            'Reference:',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                height: 1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign:
                                                                TextAlign.end),
                                                        AutoSizeText(
                                                            " " +
                                                                model.reference
                                                                    .toString()
                                                                    .replaceAll(
                                                                        "Job :",
                                                                        ""),
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              height: 1,
                                                            ),
                                                            textAlign:
                                                                TextAlign.end),
                                                        Spacer(),
                                                        AutoSizeText(
                                                            'Job Date:',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign:
                                                                TextAlign.end),
                                                        AutoSizeText(
                                                            '${model.jobCreatedTime}',
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                            textAlign:
                                                                TextAlign.end),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        AutoSizeText(
                                                            'Job Type:',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                height: 1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign:
                                                                TextAlign.end),
                                                        AutoSizeText(
                                                            model.jobType
                                                                    .contains(
                                                                        "Main")
                                                                ? " Maintenance/Repair"
                                                                : ' ${model.jobType}',
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              height: 1,
                                                            ),
                                                            textAlign:
                                                                TextAlign.end),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('Location:',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              height: 1,
                                                            ),
                                                            textAlign:
                                                                TextAlign.end),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 2.0),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.5,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              model.location !=
                                                                      null
                                                                  ? '  ${model.location}'
                                                                  : " -",
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                height: 1,
                                                              ),
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        AutoSizeText(
                                                            'Vehicle No:',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              height: 1,
                                                            ),
                                                            textAlign:
                                                                TextAlign.end),
                                                        AutoSizeText(
                                                            ' ${model.vehicle}',
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              height: 1,
                                                            ),
                                                            textAlign:
                                                                TextAlign.end),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    model.make != null
                                                        ? Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  AutoSizeText(
                                                                      '${model.make != null ? model.make : ""} ${model.model != null ? model.model : ""} ${model.colour != null ? model.colour : ""}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        height:
                                                                            1,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .end),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                            ],
                                                          )
                                                        : Container(),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        AutoSizeText(
                                                            model.status ==
                                                                    "Allocate"
                                                                ? "New Job"
                                                                : '${model.status}',
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              height: 1,
                                                            ),
                                                            textAlign:
                                                                TextAlign.end),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (model.status == "Allocate")
                                              Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: InkWell(
                                                          child: Container(
                                                            height: 35,
                                                            color: Colors.red,
                                                            child: Center(
                                                              child: Text(
                                                                "Decline",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    height: 1,
                                                                    fontSize:
                                                                        13),
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            _showDialog(model);
                                                          },
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 2,
                                                        color: Colors.white,
                                                      ),
                                                      Expanded(
                                                          child: InkWell(
                                                        child: Container(
                                                          height: 35,
                                                          color: Colors.green,
                                                          child: Center(
                                                            child: Text(
                                                              "Accept",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height: 1,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          /* */
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          sendJobChecks(model,
                                                              "", "Accepted");
                                                        },
                                                      )),
                                                    ],
                                                  )
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (model.status == "Accepted" ||
                                        model.status == "Pending") {
                                      // if (model.status == "Completed") {

                                      print(
                                          "========22/2=23 =========${model.id}");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StartJoBCheckPage(
                                            type: model.jobType
                                                .toString()
                                                .substring(0, 1),
                                            jobID: model.id,
                                            compID: model.compId,
                                            jobListModel: model,
                                            isPending: model.status == "Pending"
                                                ? true
                                                : false,
                                          ),
                                        ),
                                      );
                                    } else {
                                      _showSummary(model, context);
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      : Expanded(child: Center(child: Text("No Data Found"))),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }

  _showDialog(JobListModel model) async {
    var reason;

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: Form(
                key: formKey,
                child: new TextFormField(
                  autofocus: true,
                  controller: reasonController,
                  cursorColor: Colors.black,
                  maxLines: 2,
                  //###
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                  decoration: new InputDecoration(
                      focusedBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black)),
                      hoverColor: Colors.black,
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 20),
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      labelText: 'Add Reason',
                      hintText: 'eg. not available'),
                  onChanged: (val) {
                    reason = val;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please enter reason for decline';
                    }
                    return null;
                  },
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new TextButton(
              child: const Text('CANCEL',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  )),
              onPressed: () {
                Navigator.pop(context);
              }),
          new TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: () {
                if (formKey.currentState.validate()) {
                  Navigator.pop(context);
                  sendJobChecks(model, reasonController.text, "Decline");
                  //TODO API for reason
                }
              })
        ],
      ),
    );
  }

  _showSummary(JobListModel model, BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        // scrollable: true,
        contentPadding: const EdgeInsets.all(0.0),

        content: Container(
          height: 450,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: vimPrimary,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Job Summary",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                height: 350,
                // width: MediaQuery.of(context).size.width * 0.7,
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'Reference:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              " " +
                                  model.reference
                                      .toString()
                                      .replaceAll("Job :", ""),
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AutoSizeText('Job Type:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end),
                          Expanded(
                            child: AutoSizeText(
                              model.jobType.contains("Main")
                                  ? " Maintenance/Repair"
                                  : ' ${model.jobType}',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location:',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 4.0),
                              width: MediaQuery.of(context).size.width / 1.9,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  model.location != null
                                      ? ' ${model.location}'
                                      : " -",
                                  maxLines: 2,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          AutoSizeText('Job Date:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end),
                          Expanded(
                            child: AutoSizeText(
                              ' ${model.jobCreatedTime}',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          AutoSizeText('Status:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end),
                          Expanded(
                            child: AutoSizeText(
                              ' ${model.status}',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          AutoSizeText('Vehicle No:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end),
                          Expanded(
                            child: AutoSizeText(
                              ' ${model.vehicle}',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          AutoSizeText('Site Contact:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end),
                          Expanded(
                            child: AutoSizeText(
                              ' ${model.siteContact}',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          AutoSizeText('Company:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end),
                          Expanded(
                            child: Expanded(
                              child: AutoSizeText(
                                ' ${model.company}',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          AutoSizeText('Depot:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end),
                          Expanded(
                            child: AutoSizeText(
                              ' ${model.depotName}',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          AutoSizeText('Site Contact Email:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end),
                          Expanded(
                            child: AutoSizeText(
                              ' ${model.siteContactEmail}',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          AutoSizeText('Site Contact Phone:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end),
                          Expanded(
                            child: AutoSizeText(
                              ' ${model.siteContactPhone}',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          AutoSizeText('Job Request:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end),
                          Expanded(
                            child: AutoSizeText(
                              ' ${model.jobRequest}',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          AutoSizeText('Defect Reference Number:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end),
                          Expanded(
                            child: AutoSizeText(
                              ' ${model.defectReferenceNumber}',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          AutoSizeText('Work Order Number:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end),
                          Expanded(
                            child: AutoSizeText(
                              ' ${model.workOrderNumber}',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      /* SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          AutoSizeText(
                              'Job Raised:',
                              style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end),
                          AutoSizeText(
                              model.jobRaised!=null?' ${model.jobRaised}':" -",
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.end),
                        ],
                      ),*/
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'Notes:',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              model.notes != null ? ' ${model.notes}' : " -",
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    color: vimPrimary,
                    child: new TextButton(
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //for save TODO change pending
  sendJobChecks(JobListModel model, String reason, String status) async {
    var url;
    var token;
    var dio = new Dio();
    String messageTitle;
    String message;
    //var dc = jobCheck.questionAnswer.to;
    var body = {'JobId': model.id, 'status': status, 'Notes': reason};

    List<DialogButton> buttons = [
      DialogButton(
        child: Text(
          "CLOSE",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            isLoading = true;
          });

          getJobData(jobStatus[statusIdChosen].name);
        },
        width: 120,
      )
    ];

    await getToken().then((result) {
      token = result;
    });

    dio.options.headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      int jobDoneId;

      //for type specific url

      url = BASE_URL + "/api/job/UpdateJobStatus";

      var response = await dio.post(url, queryParameters: body);

      print(response.data.toString());
      messageTitle = "Success";
      message = response.data;

      setState(() {
        isLoading = false;
      });
      Alert(
              context: context,
              title: messageTitle,
              desc: message,
              buttons: buttons)
          .show();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      messageTitle = "Something went wrong!";
      message = e.response.data;
      Alert(
              context: context,
              title: messageTitle,
              desc: message,
              buttons: buttons)
          .show();
      print(e.toString());
    }
  }
}
