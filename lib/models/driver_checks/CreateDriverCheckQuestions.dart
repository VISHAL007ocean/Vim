import 'dart:io';

class CreateDriverCheckAnswers {
  int questionId;
  int type;
  String answer;
  String notes;
  List<File> images;

  CreateDriverCheckAnswers(this.questionId, this.type, this.answer, this.notes);

  CreateDriverCheckAnswers.fromJson(Map<dynamic, dynamic> json)
      : questionId = json['questionId'],
        answer = json['answer'],
        notes = json['notes'];

  Map<dynamic, dynamic> toJson() =>
      {'questionId': questionId, 'answer': answer, 'notes': notes};
}

class CreateDriverCheckSaveAnswers {
  int questionId;
  int type;
  String answer;
  String notes;
  List<File> images;

  CreateDriverCheckSaveAnswers(this.questionId, this.type, this.answer, this.notes);

  CreateDriverCheckSaveAnswers.fromJson(Map<dynamic, dynamic> json)
      : questionId = json['questionId'],
        answer = json['answer'],
        notes = json['notes'];

  Map<dynamic, dynamic> toJson() =>
      {'questionId': questionId, 'answer': answer, 'notes': notes};
}
