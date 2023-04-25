import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:http/http.dart' as http;
import 'package:vim_mobile/consts/consts.dart';

Future postIncidentVideo(
  var id,
  File video,
) async {
  var dio = new Dio();

  var token;
  var incidentId = id.toString();

  await getToken().then((result) {
    token = result;
  });

  dio.options.headers = {
    "Accept": "application/json",
    "Authorization": "Bearer $token",
    "Content-Type": "multipart/form-data",
  };

  try {
    FormData formData = new FormData.fromMap(
        {"Id": incidentId, "File": processFile(video, "Drivers_Evidence")});

    var response = await dio.post(
      BASE_URL + "/api/incidents/PostIncidentVideo",
      data: formData,
    );
    print(response.data.toString());
  } catch (e) {
    print(e);
  }
}

processFile(File file, String filename) {
  return new http.MultipartFile(
      'picture', file.readAsBytes().asStream(), file.lengthSync(),
      filename: filename);
}
