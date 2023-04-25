class LoadLeaseChecks {
  int id;
  int companyId;
  String startedTime;
  String endTime;
  String depotName;
  String leaseCheckCode;
  String status;
  String registration;

  LoadLeaseChecks(
      int id,
      int companyId,
      String startedTime,
      String endTime,
      String depotName,
      String leaseCheckCode,
      String status,
      String registration) {
    this.id = id;
    this.companyId = companyId;
    this.startedTime = startedTime;
    this.endTime = endTime;
    this.depotName = depotName;
    this.leaseCheckCode = leaseCheckCode;
    this.status = status;
    this.registration = registration;
  }

  LoadLeaseChecks.fromJson(Map json)
      : id = json['id'],
        companyId = json['companyId'],
        startedTime = json['startedTime'],
        endTime = json['endTime'],
        depotName = json['depotName'],
        leaseCheckCode = json['leaseCheckCode'],
        status = json['status'],
        registration = json['registration'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'startedTime': startedTime,
      'endTime': endTime,
      'depotName': depotName,
      'leaseCheckCode': leaseCheckCode,
      'status': status,
      'registration': registration
    };
  }
}
