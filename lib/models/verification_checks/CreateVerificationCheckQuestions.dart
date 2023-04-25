import 'dart:io';

class CreateVerificationCheckAnswers {
  int questionId;
  int type;
  String answer;
  String notes;
  List<File> images;

  CreateVerificationCheckAnswers(
      this.questionId, this.type, this.answer, this.notes);

  CreateVerificationCheckAnswers.fromJson(Map<dynamic, dynamic> json)
      : questionId = json['questionId'],
        answer = json['answer'],
        notes = json['notes'];

  Map<dynamic, dynamic> toJson() =>
      {'questionId': questionId, 'answer': answer, 'notes': notes};
}
