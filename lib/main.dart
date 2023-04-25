import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vim_mobile/ui/pages/contact/contact_page.dart';
import 'package:vim_mobile/ui/pages/damage_report/damage_choose_vehicle.dart';
import 'package:vim_mobile/ui/pages/damage_report/damage_report.dart';
import 'package:vim_mobile/ui/pages/dashboard/dashboard_page.dart';
import 'package:vim_mobile/ui/pages/driver_checks/driver_checks_details.dart';
import 'package:vim_mobile/ui/pages/driver_checks/start_driver_check.dart';
import 'package:vim_mobile/ui/pages/emergency_services/emergency_services.dart';
import 'package:vim_mobile/ui/pages/engineer/eng_checks/start_job_check.dart';
import 'package:vim_mobile/ui/pages/engineer/job_list/job_list.dart';
import 'package:vim_mobile/ui/pages/incidents/incident_details.dart';
import 'package:vim_mobile/ui/pages/incidents/report_page.dart';
import 'package:vim_mobile/ui/pages/lease_checks/start_lease_check.dart';
import 'package:vim_mobile/ui/pages/login/login_page.dart';
import 'package:vim_mobile/ui/pages/shared_pages/choose_Vehicle.dart';
import 'package:vim_mobile/ui/pages/splashscreen/splashscreen.dart';
import 'package:vim_mobile/ui/pages/vehicle_inspection_history/vehicle_inspection_detail.dart';
import 'package:vim_mobile/ui/pages/vehicle_inspection_history/vehicle_inspection_history.dart';
import 'package:vim_mobile/ui/pages/verification_checks/start_verification_check.dart';
import 'package:vim_mobile/ui/pages/wellbeing_checks/start_wellbeing_check.dart';

import 'PushNotificationService.dart';
import 'ui/pages/driver_checks/start_flt_check.dart';
// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PushNotificationService().setupInteractedMessage();
  /*final pushNotificationService = Push_Service(_firebaseMessaging);
  pushNotificationService.initialise();*/
  runApp(new VimApp());
  RemoteMessage initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    // App received a notification when it was killed
  }
}

class VimApp extends StatelessWidget {
  // This widget is the root of your application.
  final navigatorKey = GlobalKey<NavigatorState>();
  // ignore: close_sinks
  dynamic route;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Vim Ltd', //TODO Branding
        theme: ThemeData(
          disabledColor: Color(0xFF5b5b5b),
          accentColor: Color(0xFF56122f), // background color of card headers
          cardColor: Colors.white, // background color of fields
          backgroundColor: Colors.white, // color outside the card
          primaryColor: Color(0xFF56122f), // color of page header
          buttonColor: Color(0xFF56122f), // background color of buttons
          indicatorColor: Color(0xFF56122f),
          bottomAppBarColor: Color(0xFF097392),
          iconTheme: IconThemeData(color: Color(0xFF56122f), size: 20.0),
          textTheme: TextTheme(
              button:
                  TextStyle(color: Color(0xFF5b5b5b)), // style of button text
              subtitle1: TextStyle(color: Color(0xFF5b5b5b)),
              headline6: TextStyle(color: Colors.white) // style of input text
              ),
          primaryTextTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.white, fontSize: 15.0), // style for headers
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Color(0xFF5b5b5b)), // style for labels
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/splashscreen',
        routes: {
          '/splashscreen': (BuildContext context) => Splashscreen(),
          '/login': (BuildContext context) => LoginPage(),
          '/dashboard': (BuildContext context) => Dashboard(),
          '/incidents': (BuildContext context) => IncidentDetails(),
          '/createincident': (BuildContext context) => ReportPage(),
          '/createengincident': (BuildContext context) =>
              ChooseVehiclePage(ReportPage(), 0, 0),
          '/report': (BuildContext context) => ReportPage(),
          '/driverchecks': (BuildContext context) => DriverCheckDetails(),
          '/damageincident': (BuildContext context) =>
              ChooseDamageVehiclePage(DamageReportList(), 1, 1),
          '/startdrivercheck': (BuildContext context) =>
              ChooseVehiclePage(StartDriverCheckPage(), 1, 0),
          '/startfltcheck': (BuildContext context) =>
              ChooseVehiclePage(StartFltCheckPage(), 1, 1),
          '/startleasecheck': (BuildContext context) =>
              ChooseVehiclePage(StartLeaseCheckPage(), 0, 0),
          '/startverificationcheck': (BuildContext context) =>
              ChooseVehiclePage(StartVerificationCheckPage(), 0, 0),
          '/startwellbeingcheck': (BuildContext context) =>
              StartWellbeingCheckPage(),
          '/endreport': (BuildContext context) => EndReportPage(),
          '/joblist': (BuildContext context) => JobList(),
          '/jobcheck': (BuildContext context) => StartJoBCheckPage(),
          '/inspectionHistory': (BuildContext context) =>
              VehicleInspectionHistory(),
          '/inspectionHistoryDetail': (BuildContext context) =>
              VehicleInspectionHistoryDetail(),
          '/contact': (BuildContext context) => ContactPageWidget(),
          '/emergencyService': (BuildContext context) => EmergencyServicePage()
        },
        home: Splashscreen());
  }
}
