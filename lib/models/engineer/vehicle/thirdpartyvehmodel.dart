class ThirdPartyVehModel {
  String status;
  String statumessage;
  ThirdPartyVehDetails dataitem;

  ThirdPartyVehModel({this.status, this.statumessage, this.dataitem});

  ThirdPartyVehModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statumessage = json['statumessage'];
    dataitem = json['dataitem'] != null
        ? new ThirdPartyVehDetails.fromJson(json['dataitem'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['statumessage'] = this.statumessage;
    if (this.dataitem != null) {
      data['dataitem'] = this.dataitem.toJson();
    }
    return data;
  }
}

class ThirdPartyVehDetails {
  String dateOfLastUpdate;
  String colour;
  String vehicleClass;
  bool certificateOfDestructionIssued;
  String engineNumber;
  String engineCapacity;
  String transmissionCode;
  bool exported;
  String yearOfManufacture;
  String wheelPlan;
  Null dateExported;
  bool scrapped;
  String transmission;
  String dateFirstRegisteredUk;
  String model;
  int gearCount;
  bool importNonEu;
  Null previousVrmGb;
  int grossWeight;
  String doorPlanLiteral;
  Null mvrisModelCode;
  String vin;
  String vrm;
  String dateFirstRegistered;
  Null dateScrapped;
  String doorPlan;
  String yearMonthFirstRegistered;
  String vinLast5;
  bool vehicleUsedBeforeFirstRegistration;
  int maxPermissibleMass;
  String make;
  String makeModel;
  String transmissionType;
  int seatingCapacity;
  String fuelType;
  int co2Emissions;
  bool imported;
  Null mvrisMakeCode;
  Null previousVrmNi;
  Null vinConfirmationFlag;

  ThirdPartyVehDetails(
      {this.dateOfLastUpdate,
        this.colour,
        this.vehicleClass,
        this.certificateOfDestructionIssued,
        this.engineNumber,
        this.engineCapacity,
        this.transmissionCode,
        this.exported,
        this.yearOfManufacture,
        this.wheelPlan,
        this.dateExported,
        this.scrapped,
        this.transmission,
        this.dateFirstRegisteredUk,
        this.model,
        this.gearCount,
        this.importNonEu,
        this.previousVrmGb,
        this.grossWeight,
        this.doorPlanLiteral,
        this.mvrisModelCode,
        this.vin,
        this.vrm,
        this.dateFirstRegistered,
        this.dateScrapped,
        this.doorPlan,
        this.yearMonthFirstRegistered,
        this.vinLast5,
        this.vehicleUsedBeforeFirstRegistration,
        this.maxPermissibleMass,
        this.make,
        this.makeModel,
        this.transmissionType,
        this.seatingCapacity,
        this.fuelType,
        this.co2Emissions,
        this.imported,
        this.mvrisMakeCode,
        this.previousVrmNi,
        this.vinConfirmationFlag});

  ThirdPartyVehDetails.fromJson(Map<String, dynamic> json) {
    dateOfLastUpdate = json['dateOfLastUpdate'];
    colour = json['colour'];
    vehicleClass = json['vehicleClass'];
    certificateOfDestructionIssued = json['certificateOfDestructionIssued'];
    engineNumber = json['engineNumber'];
    engineCapacity = json['engineCapacity'];
    transmissionCode = json['transmissionCode'];
    exported = json['exported'];
    yearOfManufacture = json['yearOfManufacture'];
    wheelPlan = json['wheelPlan'];
    dateExported = json['dateExported'];
    scrapped = json['scrapped'];
    transmission = json['transmission'];
    dateFirstRegisteredUk = json['dateFirstRegisteredUk'];
    model = json['model'];
    gearCount = json['gearCount'];
    importNonEu = json['importNonEu'];
    previousVrmGb = json['previousVrmGb'];
    grossWeight = json['grossWeight'];
    doorPlanLiteral = json['doorPlanLiteral'];
    mvrisModelCode = json['mvrisModelCode'];
    vin = json['vin'];
    vrm = json['vrm'];
    dateFirstRegistered = json['dateFirstRegistered'];
    dateScrapped = json['dateScrapped'];
    doorPlan = json['doorPlan'];
    yearMonthFirstRegistered = json['yearMonthFirstRegistered'];
    vinLast5 = json['vinLast5'];
    vehicleUsedBeforeFirstRegistration =
    json['vehicleUsedBeforeFirstRegistration'];
    maxPermissibleMass = json['maxPermissibleMass'];
    make = json['make'];
    makeModel = json['makeModel'];
    transmissionType = json['transmissionType'];
    seatingCapacity = json['seatingCapacity'];
    fuelType = json['fuelType'];
    co2Emissions = json['co2Emissions'];
    imported = json['imported'];
    mvrisMakeCode = json['mvrisMakeCode'];
    previousVrmNi = json['previousVrmNi'];
    vinConfirmationFlag = json['vinConfirmationFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateOfLastUpdate'] = this.dateOfLastUpdate;
    data['colour'] = this.colour;
    data['vehicleClass'] = this.vehicleClass;
    data['certificateOfDestructionIssued'] =
        this.certificateOfDestructionIssued;
    data['engineNumber'] = this.engineNumber;
    data['engineCapacity'] = this.engineCapacity;
    data['transmissionCode'] = this.transmissionCode;
    data['exported'] = this.exported;
    data['yearOfManufacture'] = this.yearOfManufacture;
    data['wheelPlan'] = this.wheelPlan;
    data['dateExported'] = this.dateExported;
    data['scrapped'] = this.scrapped;
    data['transmission'] = this.transmission;
    data['dateFirstRegisteredUk'] = this.dateFirstRegisteredUk;
    data['model'] = this.model;
    data['gearCount'] = this.gearCount;
    data['importNonEu'] = this.importNonEu;
    data['previousVrmGb'] = this.previousVrmGb;
    data['grossWeight'] = this.grossWeight;
    data['doorPlanLiteral'] = this.doorPlanLiteral;
    data['mvrisModelCode'] = this.mvrisModelCode;
    data['vin'] = this.vin;
    data['vrm'] = this.vrm;
    data['dateFirstRegistered'] = this.dateFirstRegistered;
    data['dateScrapped'] = this.dateScrapped;
    data['doorPlan'] = this.doorPlan;
    data['yearMonthFirstRegistered'] = this.yearMonthFirstRegistered;
    data['vinLast5'] = this.vinLast5;
    data['vehicleUsedBeforeFirstRegistration'] =
        this.vehicleUsedBeforeFirstRegistration;
    data['maxPermissibleMass'] = this.maxPermissibleMass;
    data['make'] = this.make;
    data['makeModel'] = this.makeModel;
    data['transmissionType'] = this.transmissionType;
    data['seatingCapacity'] = this.seatingCapacity;
    data['fuelType'] = this.fuelType;
    data['co2Emissions'] = this.co2Emissions;
    data['imported'] = this.imported;
    data['mvrisMakeCode'] = this.mvrisMakeCode;
    data['previousVrmNi'] = this.previousVrmNi;
    data['vinConfirmationFlag'] = this.vinConfirmationFlag;
    return data;
  }
}