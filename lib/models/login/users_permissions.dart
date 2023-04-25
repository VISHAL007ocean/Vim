class UserPermissionsModel {
  String userId;
  int mobileDriverChecks;
  int mobileIncidents;
  int mobileVehicleRepairs;

  UserPermissionsModel({
    this.userId,
    this.mobileDriverChecks,
    this.mobileIncidents,
    this.mobileVehicleRepairs
  });

factory UserPermissionsModel.fromJson(Map<String, dynamic> parsedJson){
    return UserPermissionsModel(
      userId: parsedJson['userId'],
      mobileDriverChecks: parsedJson['mobileDriverChecks'],
      mobileIncidents: parsedJson['mobileIncidents'],
      mobileVehicleRepairs: parsedJson['mobileVehicleRepairs']
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'userId': userId,
        'mobileDriverChecks': mobileDriverChecks,
        'mobileIncidents': mobileIncidents,
        'mobileVehicleRepairs': mobileVehicleRepairs
      };
}