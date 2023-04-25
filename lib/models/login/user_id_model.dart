class UserIdModel {
  int companyId;
  int depotId;

  UserIdModel({
    this.companyId,
    this.depotId,
  });

factory UserIdModel.fromJson(Map<String, dynamic> parsedJson){
    return UserIdModel(
      companyId: parsedJson['companyId'],
      depotId : parsedJson['depotId'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'companyId': companyId,
        'depotId': depotId,
      };
}