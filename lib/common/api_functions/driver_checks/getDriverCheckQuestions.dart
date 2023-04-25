import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/consts/consts.dart';

Future<List<dynamic>> getDriverCheckQuestions(int companyId,int vehicleId) async {
  var token;
  var responseJson;
  var dio = new Dio();

  await getToken().then((result) {
    token = result;
  });

  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json-patch+json",
    "Authorization": "Bearer $token",
  };
 print("GetDriverChecksQuestions api called");
 var   queryParameters  = {
  'companyId': companyId,
  'vehicleId': vehicleId,
  };
  try {
    final response = await dio.get(
        BASE_URL + '/api/driverchecks/GetDriverChecksQuestions',
        queryParameters: {
          'companyId': companyId,
          'vehicleId': vehicleId,
        });
     print(BASE_URL + '/api/driverchecks/GetDriverChecksQuestions' );
     print(queryParameters);
    responseJson = response.data;
    print(responseJson);
  } catch (e) {
    debugPrint(e.toString());
  }

  return responseJson;
}
Future<List<dynamic>> getFltCheckQuestions(int companyId) async {
  var token;
  var responseJson;
  var dio = new Dio();

  await getToken().then((result) {
    token = result;
  });

  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json-patch+json",
    "Authorization": "Bearer $token",
  };
//new commi
  try {
    final response = await dio.get(
        BASE_URL + '/api/fltchecks/GetFltChecksQuestions',
        queryParameters: {
          'companyId': companyId,
        });

    responseJson = response.data;
    print(BASE_URL + '/api/fltchecks/GetFltChecksQuestions');
    print(companyId);
    print(responseJson);
  } catch (e) {
    debugPrint(e.toString());
  }

  return responseJson;
}

Future<List<dynamic>> getDamageReportCheckQuestions(int companyId) async {
  print("damage api called");
  print(BASE_URL + '/api/damagevehicle/GetDamagaeReportQuestions');
  var token;
  var responseJson;
  var dio = new Dio();

  await getToken().then((result) {
    token = result;
  });

  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json-patch+json",
    "Authorization": "Bearer $token",
  };

  print("======20-4 ===========$companyId");
//new commi
  try {

    final response = await dio.get(
        BASE_URL + '/api/damagevehicle/GetDamagaeReportQuestions',
        queryParameters: {
          'companyId': companyId,
        });


    responseJson = response.data;
  } catch (e) {
    debugPrint(e.toString());
  }

  return responseJson;
}
