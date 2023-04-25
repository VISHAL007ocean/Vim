import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vim_mobile/common/functions/getToken.dart';
import 'package:vim_mobile/common/functions/getUserId.dart';
import 'package:vim_mobile/consts/consts.dart';

Future postEmotionCheck(UserEmotions emotionChosen) async {
  var token;
  var userId;

  await getToken().then((result) {
    token = result;
  });

  await getUserId().then((result) {
    userId = result;
  });

  String dateString = DateTime.now().toString();

  SharedPreferences preferences = await SharedPreferences.getInstance();

  preferences.setString("LastEmotionCheck", dateString);

  Map<String, dynamic> body = {
    'userId': userId,
    'emotion': emotionChosen.index,
    'startedTime': dateString
  };

  final response =
      await http.post(Uri.parse(BASE_URL + '/api/wellbeingchecks/SendDriverEmotion'),
          headers: {
            "Content-Type": "application/json-patch+json",
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
          body: json.encode(body));

  if (response.statusCode == 200) {
    print("Success!");
  } else {
    print(response.body);
  }
}
