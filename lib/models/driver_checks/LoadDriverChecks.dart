class LoadDriverChecks {
  int id;
  int companyId;
  String startedTime;
  String endTime;
  String depotName;
  String driverCheckCode;
  String status;
  String registration;

  LoadDriverChecks(int id, int companyId, String startedTime, String endTime, String depotName, String driverCheckCode, String status, String registration) {
    this.id = id;
    this.companyId = companyId;
    this.startedTime = startedTime;
    this.endTime = endTime;
    this.depotName = depotName;
    this.driverCheckCode = driverCheckCode;
    this.status = status;
    this.registration = registration;
  }

  LoadDriverChecks.fromJson(Map json)
    : id = json['id'],
      companyId = json['companyId'],
      startedTime = json['startedTime'],
      endTime = json['endTime'],
      depotName = json['depotName'],
      driverCheckCode = json['driverCheckCode'],
      status = json['status'],
      registration = json['registration'];

  Map<String, dynamic> toJson() {
    return {'id':id,'companyId':companyId,'startedTime':startedTime, 'endTime': endTime, 'depotName':depotName,'driverCheckCode': driverCheckCode, 'status': status, 'registration':registration};
  }
}
