class CreateVehicleRepair {
  int VehicleId;
  String CreatedTime;
  String UserId;
  double Latitude;
  double Longitude;
  String Notes;

  CreateVehicleRepair(
    this.VehicleId,
    this.CreatedTime,
    this.UserId,
    this.Latitude,
    this.Longitude,
    this.Notes
  );

  CreateVehicleRepair.fromJson(Map<dynamic, dynamic> json)
    : VehicleId = json['vehicleId'],
      CreatedTime = json['createdTime'],
      UserId = json['userId'],
      Latitude = json['latitude'],
      Longitude = json['longitude'],
      Notes = json['notes'];

      Map<dynamic, dynamic> toJson() =>
      {
        'vehicleId': VehicleId,
        'createdTime': CreatedTime,
        'userId': UserId,
        'latitude': Latitude,
        'longitude': Longitude,
        'notes': Notes,
      };
}