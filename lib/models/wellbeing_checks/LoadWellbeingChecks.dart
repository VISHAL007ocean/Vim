class LoadWellbeingChecks {
  int id;
  int companyId;
  String startedTime;
  String endTime;
  String depotName;
  String wellbeingCheckCode;
  String status;
  String registration;

  LoadWellbeingChecks(
      int id,
      int companyId,
      String startedTime,
      String endTime,
      String depotName,
      String wellbeingCheckCode,
      String status,
      String registration) {
    this.id = id;
    this.companyId = companyId;
    this.startedTime = startedTime;
    this.endTime = endTime;
    this.depotName = depotName;
    this.wellbeingCheckCode = wellbeingCheckCode;
    this.status = status;
    this.registration = registration;
  }

  LoadWellbeingChecks.fromJson(Map json)
      : id = json['id'],
        companyId = json['companyId'],
        startedTime = json['startedTime'],
        endTime = json['endTime'],
        depotName = json['depotName'],
        wellbeingCheckCode = json['wellbeingCheckCode'],
        status = json['status'],
        registration = json['registration'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'startedTime': startedTime,
      'endTime': endTime,
      'depotName': depotName,
      'wellbeingCheckCode': wellbeingCheckCode,
      'status': status,
      'registration': registration
    };
  }
}
