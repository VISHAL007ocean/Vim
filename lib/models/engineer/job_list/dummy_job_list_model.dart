class DummyJobListModel {
  String jobName;
  int jobId;
  String jobType;

  DummyJobListModel({this.jobName, this.jobId, this.jobType});

  DummyJobListModel.fromJson(Map<String, dynamic> json) {
    jobName = json['job_name'];
    jobId = json['job_id'];
    jobType = json['job_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_name'] = this.jobName;
    data['job_id'] = this.jobId;
    data['job_type'] = this.jobType;
    return data;
  }

  List<DummyJobListModel> getDummyJobList() {
    List<DummyJobListModel> list = <DummyJobListModel>[];

    DummyJobListModel model = DummyJobListModel();

    model.jobId = 2;
    model.jobName = "Maintenance/Repair";
    model.jobType = "M";

    list.add(model);

    model = DummyJobListModel();

    model.jobId = 2;
    model.jobName = "Installation";
    model.jobType = "I";

    list.add(model);

    model = DummyJobListModel();

    model.jobId = 2;
    model.jobName = "DeInstallation";
    model.jobType = "D";

    list.add(model);

    return list;
  }

  List<JobFilterModel> getDummyJobStatus() {
    List<JobFilterModel> list = <JobFilterModel>[];

    JobFilterModel model = JobFilterModel();

    model.value = 0;
    model.name = "acceptallocate";

    list.add(model);

    model = JobFilterModel();

    model.value = 1;
    model.name = "Completed";

    list.add(model);

    model = JobFilterModel();

    model.value = 2;
    model.name = "Decline";

    list.add(model);

    return list;
  }

  List<JobFilterModel> getDummyVehCamStatus() {
    List<JobFilterModel> list = <JobFilterModel>[];

    JobFilterModel model = JobFilterModel();

    model.value = 0;
    model.name = "No";

    list.add(model);

    model = JobFilterModel();

    model.value = 1;
    model.name = "MCY";

    list.add(model);

    model = JobFilterModel();

    model.value = 2;
    model.name = "Recoda";

    list.add(model);

    return list;
  }
}

class JobFilterModel {
  String name;
  int value;

  JobFilterModel({this.name, this.value});

  JobFilterModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
