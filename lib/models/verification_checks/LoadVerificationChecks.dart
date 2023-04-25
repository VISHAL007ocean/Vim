class LoadVerificationChecks {
  int id;
  int companyId;
  String startedTime;
  String endTime;
  String depotName;
  String verificationCheckCode;
  String status;
  String registration;

  LoadVerificationChecks(
      int id,
      int companyId,
      String startedTime,
      String endTime,
      String depotName,
      String verificationCheckCode,
      String status,
      String registration) {
    this.id = id;
    this.companyId = companyId;
    this.startedTime = startedTime;
    this.endTime = endTime;
    this.depotName = depotName;
    this.verificationCheckCode = verificationCheckCode;
    this.status = status;
    this.registration = registration;
  }

  LoadVerificationChecks.fromJson(Map json)
      : id = json['id'],
        companyId = json['companyId'],
        startedTime = json['startedTime'],
        endTime = json['endTime'],
        depotName = json['depotName'],
        verificationCheckCode = json['verificationCheckCode'],
        status = json['status'],
        registration = json['registration'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'startedTime': startedTime,
      'endTime': endTime,
      'depotName': depotName,
      'verificationCheckCode': verificationCheckCode,
      'status': status,
      'registration': registration
    };
  }
}
