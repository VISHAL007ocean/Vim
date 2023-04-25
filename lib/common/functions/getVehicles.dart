import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vim_mobile/common/functions/getDepotId.dart';
import 'package:dio/dio.dart';
import 'package:vim_mobile/consts/consts.dart';

List<dynamic> data = List<dynamic>();
int depotId;
var token;

Future<List<dynamic>> getVehicles(int check) async {

  print("Gett -----vehicle");
  await getToken().then((result) {
    token = result;
  });

  if(check==0){
    await getDepotId().then((result) {
      depotId = int.parse(result) != null ? int.parse(result) : null;
    });
  }else {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    depotId=int.parse(preferences.getString("CurrentDepotId"));
  }


  var dio = new Dio();

  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json-patch+json",
    "Authorization": "Bearer $token",
  };

  final response =
      await dio.post(BASE_URL + '/api/incidents/GetDepotsVehicles', data: {
    'depotId': depotId,
  });
  print('/api/incidents/GetDepotsVehicles');
  print('depotId: $depotId');
  print(data);
  var responseJson = response.data;
  data = responseJson;

  return data;
}

Future<int> getDefaultVehicleId(List<dynamic> data) async {
  int vehicleIdChosen;

  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (preferences.getString("DefaultVehicleId") != null) {
    try {
      var vehicle = data.firstWhere((element) =>
          element["id"].toString() ==
          preferences.getString("DefaultVehicleId"));
      vehicleIdChosen = vehicle["id"];
    } catch (e) {
      print(e);
    }
  }

  return vehicleIdChosen;
}

Future<int> getDefaultVehicleIdForEng(List<dynamic> data) async {
  int vehicleIdChosen;

  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (preferences.getString("CurrentVehicleId") != null) {
    try {

      data.forEach((element) {

        if(element["id"].toString() ==preferences.getString("CurrentVehicleId")){
          vehicleIdChosen = element["id"];
        }
      });


    } catch (e) {
      print(e);
    }
  }

  return vehicleIdChosen;
}
