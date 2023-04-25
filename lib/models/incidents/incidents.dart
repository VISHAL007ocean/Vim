class Incidents {
  int id;
  String reference;
  String createdTime;
  String depotName;
  String registration;

  Incidents(int id, String reference, String createdTime, String depotName, String registration) {
    this.id = id;
    this.reference = reference;
    this.createdTime = createdTime;
    this.depotName = depotName;
    this.registration = registration;
  }

  Incidents.fromJson(Map json)
    : id = json['id'],
      reference = json['reference'],
      createdTime = json['createdTime'],
      depotName = json['depotName'],
      registration = json['registration'];

  Map<String, dynamic> toJson() {
    return {'id':id,'reference':reference,'createdTime':createdTime,'depotName':depotName,'registration':registration};
  }
}

class vehicleInspection {
  int id;
  String reference;
  String createdTime;
  String depotName;
  String registration;
  String createdBy;
  String createdOn;

  vehicleInspection(int id, String reference, String createdTime, String depotName, String registration,String createdBy,String createdOn) {
    this.id = id;
    this.reference = reference;
    this.createdTime = createdTime;
    this.depotName = depotName;
    this.registration = registration;
    this.createdBy = createdBy;
    this.createdOn = createdOn;
  }

  vehicleInspection.fromJson(Map json)
      : id = json['id'],
        reference = json['reference'],
        createdTime = json['createdTime'],
        depotName = json['depotName'],
        registration = json['registration'],
        createdBy = json['createdBy'],
        createdOn = json['createdOn'];


  Map<String, dynamic> toJson() {
    return {'id':id,'reference':reference,'createdTime':createdTime,'depotName':depotName,'registration':registration,'createdBy':createdBy,'createdOn':createdOn};
  }
}