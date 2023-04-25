import 'package:vim_mobile/models/incidents/CreateIncidentQuestions.dart';
import 'package:vim_mobile/models/incidents/CreateIncidents.dart';
class CreateIncidents {
  int Deleted;
  String Label;
  int CompanyId;
  int DepotId;
  int VehicleId;
  String CreatedTime;
  String UserId;
  double Latitude;
  double Longitude;
  String Status;
  bool IsThirdPartyInvolved;
  List<CreateIncidentsQuestions> IncidentQuestions;

  CreateIncidents(
    this.Deleted,
    this.Label,
    this.CompanyId,
    this.DepotId,
    this.VehicleId,
    this.CreatedTime,
    this.UserId,
    this.Latitude,
    this.Longitude,
    this.Status,
    this.IncidentQuestions,
      this.IsThirdPartyInvolved
  );

  CreateIncidents.fromJson(Map<dynamic, dynamic> json)
    : Deleted = json['deleted'],
      Label = json['label'],
      CompanyId = json['companyId'],
      DepotId = json['depotId'],
      VehicleId = json['vehicleId'],
      CreatedTime = json['createdTime'],
      UserId = json['userId'],
      Latitude = json['latitude'],
      Longitude = json['longitude'],
      Status = json['status'],
      IncidentQuestions = json['incidentQuestions'],
  IsThirdPartyInvolved = json['is_third_party_involved'];

      Map<dynamic, dynamic> toJson() =>
      {
        'deleted': Deleted,
        'label': Label,
        'companyId': CompanyId,
        'depotId': DepotId,
        'vehicleId': VehicleId,
        'createdTime': CreatedTime,
        'userId': UserId,
        'latitude': Latitude,
        'longitude': Longitude,
        'status': Status,
        'incidentQuestions': IncidentQuestions,
        'is_third_party_involved': IsThirdPartyInvolved
      };
}