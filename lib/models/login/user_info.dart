class UserInfoModel {
  String userId;
  String username;
  String forename;
  String surname;
  int mobileDriverChecks;
  int mobileIncidents;
  int mobileVehicleRepairs;

  UserInfoModel({
    this.userId,
    this.username,
    this.forename,
    this.surname,
    this.mobileDriverChecks,
    this.mobileIncidents,
    this.mobileVehicleRepairs
  });

factory UserInfoModel.fromJson(Map<String, dynamic> parsedJson){
    return UserInfoModel(
      userId: parsedJson['userId'],
      username: parsedJson['username'],
      forename: parsedJson['forename'],
      surname: parsedJson['surname'],
      mobileDriverChecks: parsedJson['mobileDriverChecks'],
      mobileIncidents: parsedJson['mobileIncidents'],
      mobileVehicleRepairs: parsedJson['mobileVehicleRepairs']
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'userId': userId,
        'username': username,
        'forename': forename,
        'surname': surname,
        'mobileDriverChecks': mobileDriverChecks,
        'mobileIncidents': mobileIncidents,
        'mobileVehicleRepairs': mobileVehicleRepairs
      };
}