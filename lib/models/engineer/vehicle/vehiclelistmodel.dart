class VehicleListModel {
  int status;
  List<VehList> list;

  VehicleListModel({this.status, this.list});

  VehicleListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['list'] != null) {
      list = <VehList>[];
      json['list'].forEach((v) {
        list.add(new VehList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VehList {
  int id;
  String companyName;
  String depotName;
  String make;
  String model;
  int year;
  String registration;
  String linkedDvr;
  String vehcamSystem;
  String createdOn;
  String yearOfManufacture;
  Null deleted;
  String vrm;
  String colour;
  int companyId;
  int depotId;
  String companyCode;

  VehList(
      {this.id,
        this.companyName,
        this.depotName,
        this.make,
        this.model,
        this.year,
        this.colour,
        this.registration,
        this.linkedDvr,
        this.vehcamSystem,
        this.createdOn,
        this.vrm,
        this.yearOfManufacture,
        this.companyId,
        this.depotId,
        this.deleted,this.companyCode});

  VehList.fromJson(Map<String, dynamic> json) {
    if(json['id']!=null){
      id = json['id'];
    }
    if(json['vrm']!=null){
      vrm = json['vrm'];
    }
    if(json['colour']!=null){
      colour = json['colour'];
    }
    if(json['companyName']!=null){
      companyName = json['companyName'];
    }
    if(json['depotName']!=null){
      depotName = json['depotName'];
    }
    if(json['make']!=null){
      make = json['make'];
    }

    if(json['model']!=null){
      model = json['model'];
    }
    if(json['year']!=null){
      year = json['year'];
    }
    if(json['yearOfManufacture']!=null){
      yearOfManufacture = json['yearOfManufacture'];
    }
    if(json['registration']!=null){
      registration = json['registration'];
    }
    if(json['linkedDvr']!=null){
      linkedDvr = json['linkedDvr'];
    }
    if(json['vehcamSystem']!=null){
      vehcamSystem = json['vehcamSystem'];
    }
    if(json['createdOn']!=null){
      createdOn = json['createdOn'];
    }

    if(json['deleted']!=null){
      deleted = json['createdOn'];
    }
    if(json['company_Id']!=null){
      companyId = json['company_Id'];
    }
    if(json['depot_Id']!=null){
      depotId = json['depot_Id'];
    }
    if(json['companyCode']!=null){
      companyCode = json['companyCode'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['companyName'] = this.companyName;
    data['depotName'] = this.depotName;
    data['make'] = this.make;
    data['model'] = this.model;
    data['year'] = this.year;
    data['registration'] = this.registration;
    data['linkedDvr'] = this.linkedDvr;
    data['vehcamSystem'] = this.vehcamSystem;
    data['createdOn'] = this.createdOn;
    data['deleted'] = this.deleted;
    data['vrm'] = this.vrm;
    data['companyCode'] = this.companyCode;
    return data;
  }
}

class VehicleSaveModel {
  String make;
  String model;
  int year;
  String registration;
  String colour;
  String linkedDvr;
  String vehcamSystem;

  VehicleSaveModel(
      {this.make,
        this.model,
        this.year,
        this.registration,
        this.colour,
        this.linkedDvr,
        this.vehcamSystem});

  VehicleSaveModel.fromJson(Map<String, dynamic> json) {
    make = json['Make'];
    model = json['Model'];
    year = json['Year'];
    registration = json['Registration'];
    colour = json['Colour'];
    linkedDvr = json['Linked_Dvr'];
    vehcamSystem = json['Vehcam_System'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Make'] = this.make;
    data['Model'] = this.model;
    data['Year'] = this.year;
    data['Registration'] = this.registration;
    data['Colour'] = this.colour;
    data['Linked_Dvr'] = this.linkedDvr;
    data['Vehcam_System'] = this.vehcamSystem;
    return data;
  }
}

class VehicleLocalModel {
  String make;
  String model;
  int year;
  String registration;
  String colour;
  String companyCode;

  VehicleLocalModel(
      {this.make,
        this.model,
        this.year,
        this.registration,
        this.colour,
        this.companyCode,
        });

  VehicleLocalModel.fromJson(Map<String, dynamic> json) {
    make = json['Make'];
    model = json['Model'];
    year = json['Year'];
    registration = json['Registration'];
    colour = json['Colour'];
    companyCode = json['companyCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Make'] = this.make;
    data['Model'] = this.model;
    data['Year'] = this.year;
    data['Registration'] = this.registration;
    data['Colour'] = this.colour;
    data['companyCode'] = this.companyCode;
    return data;
  }
}