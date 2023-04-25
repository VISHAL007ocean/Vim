class UsernameModel {
  String username;

  UsernameModel({
    this.username,
  });

factory UsernameModel.fromJson(Map<String, dynamic> parsedJson){
    return UsernameModel(
      username: parsedJson['username'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'username': username,
      };
}