class JobListModel {
  int id;
  String reference;
  String createdDate;
  String createdTime;
  String jobCreatedTime;
  String depotName;
  String registration;
  String engineer;
  String status;
  String jobType;
  String location;
  int compId;
  String vehicle;
  String siteContact;
  String company;
  String siteContactEmail;
  String siteContactPhone;
  String jobRequest;
  String defectReferenceNumber;
  String workOrderNumber;
  String jobRaised;
  String notes;
  int previousJob;
  String previousJobUrl;
  int previousIncident;
  String previousIncidentUrl;
  String make;
  String model;
  String colour;
  var engineerSign;
  var customerSign;

  JobListModel(
      {this.id,
      this.reference,
      this.createdDate,
      this.createdTime,
      this.jobCreatedTime,
      this.depotName,
      this.registration,
      this.engineer,
      this.status,
      this.jobType,
      this.location,
      this.compId,
      this.vehicle,
      this.siteContact,
      this.company,
      this.siteContactEmail,
      this.siteContactPhone,
      this.jobRequest,
      this.defectReferenceNumber,
      this.workOrderNumber,
      this.jobRaised,
      this.notes,
      this.previousJob,
      this.previousJobUrl,
      this.previousIncident,
      this.previousIncidentUrl,
      this.make,
      this.model,
      this.colour,
      this.engineerSign,
      this.customerSign});

  JobListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reference = json['reference'];
    createdDate = json['createdDate'];
    createdTime = json['createdTime'];
    jobCreatedTime = json['jobCreatedTime'];
    depotName = json['depotName'];
    registration = json['registration'];
    engineer = json['engineer'];
    status = json['status'];
    jobType = json['jobType'];
    location = json['location'];
    compId = json['companyId'];
    vehicle = json['vehicle'];
    siteContact = json['siteContact'];
    company = json['company'];
    siteContactEmail = json['siteContactEmail'];
    siteContactPhone = json['siteContactPhone'];
    jobRequest = json['jobRequest'];
    defectReferenceNumber = json['defectReferenceNumber'];
    workOrderNumber = json['workOrderNumber'];
    jobRaised = json['jobRaised'];
    notes = json['notes'];
    previousJob = json['previousJob'];
    previousJobUrl = json['previousJobUrl'];
    previousIncident = json['previousIncident'];
    previousIncidentUrl = json['previousIncidentUrl'];
    make = json['make'];
    model = json['model'];
    colour = json['colour'];
    engineerSign = json['engineerSign'];
    customerSign = json['customerSign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reference'] = this.reference;
    data['createdDate'] = this.createdDate;
    data['createdTime'] = this.createdTime;
    data['jobCreatedTime'] = this.jobCreatedTime;
    data['depotName'] = this.depotName;
    data['registration'] = this.registration;
    data['engineer'] = this.engineer;
    data['status'] = this.status;
    data['jobType'] = this.jobType;
    data['location'] = this.location;
    data['companyId'] = this.compId;
    data['vehicle'] = this.vehicle;
    data['siteContact'] = this.siteContact;
    data['company'] = this.company;
    data['siteContactEmail'] = this.siteContactEmail;
    data['siteContactPhone'] = this.siteContactPhone;
    data['jobRequest'] = this.jobRequest;
    data['defectReferenceNumber'] = this.defectReferenceNumber;
    data['workOrderNumber'] = this.workOrderNumber;
    data['jobRaised'] = this.jobRaised;
    data['notes'] = this.notes;
    data['previousJob'] = this.previousJob;
    data['previousJobUrl'] = this.previousJobUrl;
    data['previousIncident'] = this.previousIncident;
    data['previousIncidentUrl'] = this.previousIncidentUrl;
    data['make'] = this.make;
    data['model'] = this.model;
    data['colour'] = this.colour;
    data['engineerSign'] = this.engineerSign;
    data['customerSign'] = this.customerSign;
    return data;
  }
}
