class Questions {
  String questionId;
  String question;

  Questions(String questionId, String question) {
    this.questionId = questionId;
    this.question = question;
  }

  Questions.fromJson(Map json)
    : questionId = json['questionId'],
      question = json['question'];

  Map<String, dynamic> toJson() {
    return {'questionId': questionId, 'question':question };
  }
}
