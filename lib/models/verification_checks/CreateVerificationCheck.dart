import 'package:vim_mobile/models/verification_checks/CreateVerificationCheckQuestions.dart';

class CreateVerificationChecks {
  int vehicleId;
  String startedTime;
  String userId;
  String driverName;
  double latitude;
  double longitude;
  List<CreateVerificationCheckAnswers> verificationChecksAnswers;
  String currLocation;
  String acLocation;

  CreateVerificationChecks(
      this.vehicleId,
      this.startedTime,
      this.userId,
      this.driverName,
      this.latitude,
      this.longitude,
      this.verificationChecksAnswers,this.currLocation,this.acLocation);

  CreateVerificationChecks.fromJson(Map<dynamic, dynamic> json)
      : vehicleId = json['vehicleId'],
        startedTime = json['startedTime'],
        userId = json['userId'],
        driverName = json['driverName'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        verificationChecksAnswers = json['verificationChecksAnswers'],
        currLocation = json['CurrentLocation'],
        acLocation = json['ActualLocation'];

  Map<dynamic, dynamic> toJson() => {
        'vehicleId': vehicleId,
        'startedTime': startedTime,
        'userId': userId,
        'drivername': driverName,
        'latitude': latitude,
        'longitude': longitude,
        'verificationChecksAnswers': verificationChecksAnswers,
        'CurrentLocation': currLocation,
        'ActualLocation': acLocation
      };
}
