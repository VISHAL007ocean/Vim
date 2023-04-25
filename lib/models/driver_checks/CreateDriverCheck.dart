import 'package:vim_mobile/models/driver_checks/CreateDriverCheckQuestions.dart';

class CreateDriverChecks {
  int vehicleId;
  String startedTime;
  String userId;
  String driverName;
  double latitude;
  double longitude;
  List<CreateDriverCheckAnswers> driverChecksAnswers;
  String currLocation;
  String acLocation;

  CreateDriverChecks(this.vehicleId, this.startedTime, this.userId,
      this.driverName, this.latitude, this.longitude, this.driverChecksAnswers,this.currLocation,this.acLocation);

  CreateDriverChecks.fromJson(Map<dynamic, dynamic> json)
      : vehicleId = json['vehicleId'],
        startedTime = json['startedTime'],
        userId = json['userId'],
        driverName = json['driverName'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        driverChecksAnswers = json['driverChecksAnswers'],
        currLocation = json['CurrentLocation'],
        acLocation = json['ActualLocation'];

  Map<dynamic, dynamic> toJson() => {
        'vehicleId': vehicleId,
        'startedTime': startedTime,
        'userId': userId,
        'driverName': driverName,
        'latitude': latitude,
        'longitude': longitude,
        'driverChecksAnswers': driverChecksAnswers,
        'CurrentLocation': currLocation,
        'ActualLocation': acLocation
      };
}
class CreateFltChecks {
  int vehicleId;
  String startedTime;
  String userId;
  String driverName;
  double latitude;
  double longitude;
  List<CreateDriverCheckAnswers> driverChecksAnswers;
  String currLocation;
  String acLocation;

  CreateFltChecks(this.vehicleId, this.startedTime, this.userId,
      this.driverName, this.latitude, this.longitude, this.driverChecksAnswers,this.currLocation,this.acLocation);

  CreateFltChecks.fromJson(Map<dynamic, dynamic> json)
      : vehicleId = json['vehicleId'],
        startedTime = json['startedTime'],
        userId = json['userId'],
        driverName = json['driverName'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        driverChecksAnswers = json['driverChecksAnswers'],
        currLocation = json['CurrentLocation'],
        acLocation = json['ActualLocation'];

  Map<dynamic, dynamic> toJson() => {
    'vehicleId': vehicleId,
    'startedTime': startedTime,
    'userId': userId,
    'driverName': driverName,
    'latitude': latitude,
    'longitude': longitude,
    'FLTChecksAnswers': driverChecksAnswers,
    'CurrentLocation': currLocation,
    'ActualLocation': acLocation
  };
}
class CreateDamageChecks {
  int vehicleId;
  String damageVehicleCheckCode;
  String userId;
  String driverName;
  double latitude;
  double longitude;
   List<CreateDriverCheckAnswers> driverChecksAnswers;
  String currLocation;
  String acLocation;
  int depotId;
  int companyId;
  String registration;

  // CreateDamageChecks(this.vehicleId, this.DamageVehicleCheckCode, this.userId,
  //     this.driverName, this.latitude, this.longitude, this.driverChecksAnswers,this.currLocation,this.acLocation,this.depotId,this.companyId);
  CreateDamageChecks(this.vehicleId, this.damageVehicleCheckCode, this.userId,
      this.driverName, this.latitude, this.longitude,this.currLocation,this.acLocation,this.depotId,this.companyId,this.registration,this.driverChecksAnswers);

  CreateDamageChecks.fromJson(Map<dynamic, dynamic> json)
      : vehicleId = json['VehicleId '],
        damageVehicleCheckCode = json['DamageVehicleCheckCode'],
        userId = json['UserId'],
        driverName = json['DriverName'],
        latitude = json['Latitude'],
        longitude = json['Longitude'],
        //driverChecksAnswers = json['driverChecksAnswers'],
       // currLocation = json['CurrentLocation'],

        acLocation = json['IncidentLocation'],
        depotId = json['DepotId'],
        companyId = json['CompanyId'],
        registration = json['Registration'],
        driverChecksAnswers = json['driverChecksAnswers'];

  Map<dynamic, dynamic> toJson() => {
    'VehicleId': vehicleId,
    'DamageVehicleCheckCode': damageVehicleCheckCode,
    'UserId': userId,
    'DriverName': driverName,
    'Latitude': latitude,
    'Longitude': longitude,
    //'DemageChecksAnswers': driverChecksAnswers,
    'CurrentLocation': currLocation,
    'IncidentLocation': acLocation,
    'DepotId': depotId,
    'CompanyId': companyId,
    'Registration': registration,
    'DemageChecksAnswers': driverChecksAnswers,
  };
}

