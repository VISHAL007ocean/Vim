import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vim_mobile/consts/consts.dart';

class FormCard extends StatelessWidget {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController companyCodeController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  int depotChoosen;

  List<dynamic> data = List<dynamic>();
  bool depotListReady = false;

  FormCard(
      {Key key,
      @required this.usernameController,
      this.passwordController,
      this.companyCodeController,
      this.depotChoosen})
      : super(key: key);

  Future<String> getDepots() async {
    var dio = new Dio();

    dio.options.headers = {
      "Accept": "application/json",
      "Content-Type": "application/json-patch+json",
    };

    final response =
        await dio.post(BASE_URL + '/api/GetDepotsFromCompanyCode', data: {
      'companyCode': companyCodeController.text,
    });

    if (response.statusCode == 200) {
      var responseJson = response.data;
      print(responseJson);
      data = responseJson;
      print(data);
      depotListReady = true;

      return "Success";
    } else {
      return "Failed";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: new ScreenUtil().setHeight(650),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 15.0),
                  blurRadius: 15.0),
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, -10.0),
                  blurRadius: 10.0),
            ]),
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Login",
                  style: TextStyle(
                      fontSize: new ScreenUtil().setSp(45),
                      fontFamily: "Poppins-Bold",
                      letterSpacing: .6)),
              Text("Username",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: new ScreenUtil().setSp(26))),
              TextField(
                decoration: InputDecoration(
                    hintText: "username",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                controller: usernameController,
              ),
              Text("Password",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: new ScreenUtil().setSp(26))),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                controller: passwordController,
              ),
              SizedBox(
                height: new ScreenUtil().setHeight(15),
              ),
              Text("Company Code",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: new ScreenUtil().setSp(26))),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Company Code",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                controller: companyCodeController,
              ),
              SizedBox(
                height: new ScreenUtil().setHeight(15),
              ),
              Row(children: <Widget>[
                Text("Depots",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: new ScreenUtil().setSp(26))),
                DropdownButton(
                  items: data.map((item) {
                    return DropdownMenuItem(
                      child: new Text(item['name']),
                      value: item['id'],
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    depotChoosen = newVal;
                  },
                  value: depotChoosen,
                )
              ]),
              ElevatedButton(
                child: AutoSizeText("Get depots...",
                    style: TextStyle(color: Colors.white)),
                onPressed: () => getDepots(),
              ),
              SizedBox(
                height: new ScreenUtil().setHeight(15),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: Colors.blue,
                        fontFamily: "Poppins-Medium",
                        fontSize: new ScreenUtil().setSp(28)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
