class LoginModel {
  String auth_token;
  String id;
  int expires_in;

  LoginModel({
    this.id,
    this.auth_token,
    this.expires_in
  });

factory LoginModel.fromJson(Map<String, dynamic> parsedJson){
    return LoginModel(
      id: parsedJson['id'],
      auth_token : parsedJson['auth_token'],
      expires_in : parsedJson ['expires_in']
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'auth_token': auth_token,
        'expires_in': expires_in
      };
}