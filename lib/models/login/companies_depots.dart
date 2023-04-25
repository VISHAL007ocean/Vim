class CompanyDepotsModel {
  int id;
  String name ;

  CompanyDepotsModel({
    this.id,
    this.name,
  });

factory CompanyDepotsModel.fromJson(Map<String, dynamic> parsedJson){
    return CompanyDepotsModel(
      id: parsedJson['id'],
      name : parsedJson['name'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
      };
}