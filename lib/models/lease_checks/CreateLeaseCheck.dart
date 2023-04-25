import 'package:vim_mobile/models/lease_checks/CreateLeaseCheckQuestions.dart';

class CreateLeaseChecks {
  int vehicleId;
  String startedTime;
  String userId;
  String driverName;
  double latitude;
  double longitude;
  List<CreateLeaseCheckAnswers> leaseChecksAnswers;
  String currLocation;
  String acLocation;

  CreateLeaseChecks(this.vehicleId, this.startedTime, this.userId,
      this.driverName, this.latitude, this.longitude, this.leaseChecksAnswers,this.currLocation,this.acLocation);

  CreateLeaseChecks.fromJson(Map<dynamic, dynamic> json)
      : vehicleId = json['vehicleId'],
        startedTime = json['startedTime'],
        userId = json['userId'],
        driverName = json['driverName'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        leaseChecksAnswers = json['leaseChecksAnswers'],
        currLocation = json['CurrentLocation'],
        acLocation = json['ActualLocation'];

  Map<dynamic, dynamic> toJson() => {
        'vehicleId': vehicleId,
        'startedTime': startedTime,
        'userId': userId,
        'driverName': driverName,
        'latitude': latitude,
        'longitude': longitude,
        'leaseChecksAnswers': leaseChecksAnswers,
        'CurrentLocation': currLocation,
        'ActualLocation': acLocation

      };
}
