import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/consts/consts.dart';

Future<List<dynamic>> getVerificationCheckQuestions(int companyId) async {
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

  try {
    final response = await dio.get(
        BASE_URL + '/api/verificationchecks/GetVerificationChecksQuestions',
        queryParameters: {
          'companyId': companyId,
        });

    responseJson = response.data;
  } catch (e) {
    debugPrint(e.toString());
  }

  return responseJson;
}
