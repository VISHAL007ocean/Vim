import 'dart:io';

class JobQuestionAnswersModel {
  List<QuestionAnswer> questionAnswer;

  JobQuestionAnswersModel({this.questionAnswer});

  JobQuestionAnswersModel.fromJson(Map<String, dynamic> json) {
    if (json['question_answer'] != null) {
      questionAnswer = <QuestionAnswer>[];
      json['question_answer'].forEach((v) {
        questionAnswer.add(new QuestionAnswer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.questionAnswer != null) {
      data['question_answer'] =
          this.questionAnswer.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionAnswer {
  int questionId;
  int jobId;
  String notes;
  String answer;
  String serialNumber;
  double qty;
  String imgdisable;
  List<File> images;
  List<ImageFiles> imageData=<ImageFiles>[];


  QuestionAnswer(
      {this.questionId,
        this.jobId,
        this.notes,
        this.answer,
        this.qty,
        this.serialNumber,
        this.imgdisable});

  QuestionAnswer.fromJson(Map<String, dynamic> json) {
    questionId = json['QuestionId'];
    jobId = json['JobId'];
    notes = json['Notes'];
    answer = json['Answer'];
    serialNumber = json['SerialNumber'];
    qty = json['Qty'];
    imgdisable = json['imgdisable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QuestionId'] = this.questionId;
    data['JobId'] = this.jobId;
    data['Notes'] = this.notes;
    data['Answer'] = this.answer;
    data['SerialNumber'] = this.serialNumber;
    data['Qty'] = this.qty;
    data['imgdisable'] = this.imgdisable;
    return data;
  }
}
class CableQuestionAnswer {
  int questionId;
  int jobId;
  String notes;
  String answer;
  String qty;
  List<File> images;
  List<ImageFiles> imageData;


  CableQuestionAnswer(
      {this.questionId,
        this.jobId,
        this.notes,
        this.answer,
        this.qty});

  CableQuestionAnswer.fromJson(Map<String, dynamic> json) {
    questionId = json['QuestionId'];
    jobId = json['JobId'];
    notes = json['Notes'];
    answer = json['Answer'];
    qty = json['Qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QuestionId'] = this.questionId;
    data['JobId'] = this.jobId;
    data['Notes'] = this.notes;
    data['Answer'] = this.answer;
    data['Qty'] = this.qty;
    return data;
  }
}
class ImageFiles{
  String imgType;
  File image;
  ImageFiles({this.imgType,this.image});

}