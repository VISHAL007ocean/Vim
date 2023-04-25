class EmergencyServiceModel {
  int id;
  String serviceName;
  bool isSelected;

  EmergencyServiceModel({this.id, this.serviceName, this.isSelected});

  EmergencyServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['serviceName'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serviceName'] = this.serviceName;
    data['isSelected'] = this.isSelected;
    return data;
  }
}

