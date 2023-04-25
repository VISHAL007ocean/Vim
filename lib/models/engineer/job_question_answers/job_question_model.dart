class JobQuestionsModel {
  int questionId;
  int order;
  String groupName;
  String question;
  int questionType;
  bool required;

  JobQuestionsModel(
      {this.questionId,
        this.order,
        this.groupName,
        this.question,
        this.questionType,
        this.required});

  JobQuestionsModel.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    order = json['order'];
    groupName = json['groupName'];
    question = json['question'];
    questionType = json['questionType'];
    required = json['required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionId'] = this.questionId;
    data['order'] = this.order;
    data['groupName'] = this.groupName;
    data['question'] = this.question;
    data['questionType'] = this.questionType;
    data['required'] = this.required;
    return data;
  }
}