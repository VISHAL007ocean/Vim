import 'package:vim_mobile/models/wellbeing_checks/CreateWellbeingCheckQuestions.dart';

class CreateWellbeingChecks {
  int vehicleId;
  int depotID;
  int companyID;
  String startedTime;
  String userId;
  String driverName;
  double latitude;
  double longitude;
  List<CreateWellbeingCheckAnswers> wellbeingChecksAnswers;
  String currLocation;
  String acLocation;

  CreateWellbeingChecks(
      this.vehicleId,
      this.depotID,
      this.companyID,
      this.startedTime,
      this.userId,
      this.driverName,
      this.latitude,
      this.longitude,
      this.wellbeingChecksAnswers,
  this.currLocation,this.acLocation);

  CreateWellbeingChecks.fromJson(Map<dynamic, dynamic> json)
      : vehicleId = json['vehicleId'],
        depotID = json['DepotId'],
        companyID = json['CompanyId'],
        startedTime = json['startedTime'],
        userId = json['userId'],
        driverName = json['driverName'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        wellbeingChecksAnswers = json['wellbeingChecksAnswers'],
        currLocation = json['CurrentLocation'],
        acLocation = json['ActualLocation'];

  Map<dynamic, dynamic> toJson() => {
        'vehicleId': vehicleId,
        'DepotId': depotID,
        'CompanyId': companyID,
        'startedTime': startedTime,
        'userId': userId,
        'driverName': driverName,
        'latitude': latitude,
        'longitude': longitude,
        'wellbeingChecksAnswers': wellbeingChecksAnswers,
    'CurrentLocation': currLocation,
    'ActualLocation': acLocation
      };
}
