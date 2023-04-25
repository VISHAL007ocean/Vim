import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vim_mobile/common/functions/getPermissions.dart';
import 'package:vim_mobile/common/functions/getUserId.dart';
import 'package:vim_mobile/models/login/users_permissions.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';

class TopRowWidget extends StatefulWidget {
  TopRowWidget({
    Key key,
  }) : super(key: key);

  @override
  _TopRowWidgetState createState() => _TopRowWidgetState();
}

class _TopRowWidgetState extends State<TopRowWidget> {
  UserPermissionsModel permission;

  var featureIncidents;
  var featureDriverChecks;
  var featureVehicleRepairs;
  var featureLeaseChecks;
  var featureVerificationChecks;
  var featurePropertyRepairs;
  var featureVehicleRentals;
  var featureDriverHealth;
  var role;
  var featureFltChecks;
  var featureDamageVehicle;
  var featureEmergencyService;
  var featureYourJob;
  var logoImageString;

  @override
  initState() {
    super.initState();
    getUserRole();
  }

  getUserRole() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    logoImageString = preferences.getString("logoImageUrl");

    await getRole().then((result) {
      role = result;
      if (role == "Driver") {
        getPermissions();
      } else if (role == "Engineer") {
        getPermissions();
      }
    });
  }

  getPermissions() async {
    await getFeaturePermission("FeatureIncidents").then((result) {
      setState(() {
        featureIncidents = result;
      });
    });
    await getFeaturePermission("FeatureDriverChecks").then((result) {
      setState(() {
        featureDriverChecks = result;
      });
    });
    await getFeaturePermission("FeatureVehicleRepairs").then((result) {
      setState(() {
        featureVehicleRepairs = result;
      });
    });
    await getFeaturePermission("FeatureLeaseChecks").then((result) {
      setState(() {
        featureLeaseChecks = result;
      });
    });
    await getFeaturePermission("FeatureVerificationChecks").then((result) {
      setState(() {
        featureVerificationChecks = result;
      });
    });
    await getFeaturePermission("FeaturePropertyRepairs").then((result) {
      setState(() {
        featurePropertyRepairs = result;
      });
    });
    await getFeaturePermission("FeatureVehicleRentals").then((result) {
      setState(() {
        featureVehicleRentals = result;
      });
    });
    await getFeaturePermission("FeatureDriverHealth").then((result) {
      setState(() {
        featureDriverHealth = result;
      });
    });
    await getFeaturePermission("FeatureFltChecks").then((result) {
      setState(() {
        featureFltChecks = result;
      });
    });

    await getFeaturePermission("FeatureDamageChecks").then((result) {
      setState(() {
        featureDamageVehicle = result;
      });
    });
    await getFeaturePermission("FeatureEmergencyButton").then((result) {
      setState(() {
        featureEmergencyService = result;
      });
    });
    await getFeaturePermission("FeatureJob").then((result) {
      setState(() {
        featureYourJob = result;
      });
    });
  }

  Widget createIncident(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          title: Text('Report an incident',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(
            FontAwesomeIcons.exclamationTriangle,
            color: vimPrimary,
            size: 25,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/report');
          }),
    );
  }

  Widget createIncidentForEng(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          title: Text('Report an Incident',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(
            FontAwesomeIcons.exclamationTriangle,
            color: vimPrimary,
            size: 25,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/createengincident');
          }),
    );
  }

  //new enhacment
  //demage report
  Widget createDamageReport(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          title: Text('Damage Report',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(
            FontAwesomeIcons.exclamationTriangle,
            color: vimPrimary,
            size: 25,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/damageincident');
          }),
    );
  }

  Widget yourIncidents(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          title: Text('Incidents History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(
            FontAwesomeIcons.list,
            color: vimPrimary,
            size: 25,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/incidents');
          }),
    );
  }

  Widget yourInspectionHistory(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          title: Text('Vehicle Check History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(
            FontAwesomeIcons.list,
            color: vimPrimary,
            size: 25,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/inspectionHistory');
          }),
    );
  }

  Widget createDriverCheck(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          title: Text('Vehicle Check',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(
            FontAwesomeIcons.tachometerAlt,
            color: vimPrimary,
            size: 25,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/startdrivercheck');
          }),
    );
  }

  Widget createFLTCheck(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          title: Text('FLT Check',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(
            FontAwesomeIcons.tachometerAlt,
            color: vimPrimary,
            size: 25,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/startfltcheck',
                arguments: "FltCheck");
          }),
    );
  }

  Widget createLeaseCheck(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          title: Text('Lease Check',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(
            FontAwesomeIcons.solidCheckSquare,
            color: vimPrimary,
            size: 25,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/startleasecheck');
          }),
    );
  }

  Widget createVerificationCheck(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          title: Text('Verification Check',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(
            FontAwesomeIcons.calendarCheck,
            color: vimPrimary,
            size: 25,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/startverificationcheck');
          }),
    );
  }

  Widget createWellbeingCheck(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          title: Text('Wellbeing Check',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(
            FontAwesomeIcons.heartbeat,
            color: vimPrimary,
            size: 25,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/startwellbeingcheck');
          }),
    );
  }

  Widget yourDriverChecks(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          title: Text('Your Driver Checks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(
            FontAwesomeIcons.dashcube,
            color: vimPrimary,
            size: 25,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/driverchecks');
          }),
    );
  }

  Widget createVehicleRepair(BuildContext context) {
    return Card(
        elevation: 10,
        child: ListTile(
            title: Text('Create a Vehicle Repair',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            leading: Icon(
              FontAwesomeIcons.wrench,
              color: vimPrimary,
              size: 25,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/createvehiclerepair');
            }));
  }

  Widget yourVehicleRepairs(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          title: Text('Your Vehicle Repair',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(
            FontAwesomeIcons.car,
            color: vimPrimary,
            size: 25,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/incidents');
          }),
    );
  }

  //for Engineer
  Widget yourJobs(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          title: Text('Your Jobs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(
            FontAwesomeIcons.solidCheckSquare,
            color: vimPrimary,
            size: 25,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/joblist');
          }),
    );
  }

  Widget emergencyService(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          title: Text('Emergency Service',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(
            FontAwesomeIcons.phone,
            color: vimPrimary,
            size: 25,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/emergencyService');
          }),
    );
  }

  Widget contact(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          title: Text('Contact Vim',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(
            FontAwesomeIcons.phone,
            color: vimPrimary,
            size: 25,
          ),
          onTap: () {
            Navigator.pushNamed(context, '/contact');
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height * 0.95,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        children: <Widget>[
          role == "Driver"
              ? Column(
                  children: [
                    featureIncidents == "true"
                        ? createIncident(context)
                        : Container(),
                    featureDamageVehicle == "true"
                        ? createDamageReport(context)
                        : Container(),
                    featureIncidents == "true"
                        ? yourIncidents(context)
                        : Container(),
                    featureFltChecks == "true"
                        ? createFLTCheck(context)
                        : Container(),
                    featureDriverChecks == "true"
                        ? createDriverCheck(context)
                        : Container(),
                    featureLeaseChecks == "true"
                        ? createLeaseCheck(context)
                        : Container(),
                    featureVerificationChecks == "true"
                        ? createVerificationCheck(context)
                        : Container(),
                    featureDriverHealth == "true"
                        ? createWellbeingCheck(context)
                        : Container(),
                    featureDriverChecks == "true"
                        ? yourInspectionHistory(context)
                        : Container(),
                    featureEmergencyService == "true"
                        ? emergencyService(context)
                        : Container(),
                    // this is for test  after test remove
                    // featureYourJob == "true"
                    //     ? yourJobs(context)
                    //     : Container(),
                  ],
                )
              : Column(
                  children: [
                    featureIncidents == "true"
                        ? createIncident(context)
                        : Container(),
                    featureDamageVehicle == "true"
                        ? createDamageReport(context)
                        : Container(),
                    featureIncidents == "true"
                        ? yourIncidents(context)
                        : Container(),
                    featureFltChecks == "true"
                        ? createFLTCheck(context)
                        : Container(),
                    featureDriverChecks == "true"
                        ? createDriverCheck(context)
                        : Container(),
                    featureLeaseChecks == "true"
                        ? createLeaseCheck(context)
                        : Container(),
                    featureVerificationChecks == "true"
                        ? createVerificationCheck(context)
                        : Container(),
                    featureDriverHealth == "true"
                        ? createWellbeingCheck(context)
                        : Container(),
                    featureDriverChecks == "true"
                        ? yourInspectionHistory(context)
                        : Container(),
                    featureEmergencyService == "true"
                        ? emergencyService(context)
                        : Container(),
                    featureYourJob == "true" ? yourJobs(context) : Container(),
                    //createIncidentForEng(context),
                    //createDamageReport(context),
                    //yourIncidents(context),
                    //createFLTCheck(context),
                    //createDriverCheck(context),
                    //createLeaseCheck(context),
                    //createVerificationCheck(context),
                    // yourJobs(context),
                  ],
                ),

          //emergency services
          //TODO comment for prod
          contact(context),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child: Text("Powered by",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: "Poppins-Medium",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Image.asset(
                "assets/images/image_04.png",
                width: 50,
                height: 25,
              ))
            ],
          ),
        ],
      ),
    );
  }
}
