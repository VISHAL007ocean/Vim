import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vim_mobile/common/functions/showDialogSingleButton.dart';
import 'package:vim_mobile/consts/consts.dart';

Future requestRegister(
  BuildContext context,
  String username,
  String email,
  String phonenumber,
  String password,
) async {
  var dio = new Dio();
  dio.options.headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  var response = await dio.post(
    BASE_URL + "/api/register",
    data: {
      'email': email,
      'userName': username,
      'password': password,
      'phoneNumber': phonenumber,
    },
  );

  if (response.statusCode == 200) {
    showDialogSingleButton(context, "Success your account has been created",
        "Go to your email to confirm your account", "OK");
    return null;
  } else {
    showDialogSingleButton(
        context,
        "Unable to create account",
        "You may have supplied the wrong information or the account information has already been taken. Please try again or contact your support representative.",
        "OK");
    return null;
  }
}
