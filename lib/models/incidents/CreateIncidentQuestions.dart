class CreateIncidentsQuestions {
  int QuestionId;
  String Answer;

  CreateIncidentsQuestions(
    this.QuestionId,
    this.Answer
  );

  CreateIncidentsQuestions.fromJson(Map<dynamic, dynamic> json)
    : QuestionId = json['questionId'],
      Answer = json['answer'];

      Map<dynamic, dynamic> toJson() =>
      {
        'questionId': QuestionId,
        'answer': Answer,
      };
}