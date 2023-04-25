// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:card_settings/card_settings.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
// import 'package:vim_mobile/common/api_functions/getLatestIncidentId.dart';
// import 'package:vim_mobile/common/api_functions/postVehicleRepairsImages.dart';
// import 'package:vim_mobile/common/functions/getToken.dart';
// import 'package:vim_mobile/common/functions/getDepotId.dart';
// import 'package:dio/dio.dart';
// import 'package:vim_mobile/common/functions/getUserId.dart';
// import 'package:vim_mobile/consts/consts.dart';
// import 'package:vim_mobile/models/vehicle_repairs/CreateVehicleRepair.dart';
// import 'package:vim_mobile/ui/components/ui/colours.dart';
// import 'package:vim_mobile/ui/pages/incidents/report_page.dart';

// class VehicleRepairs extends StatefulWidget {
//   @override
//   _VehicleRepairsState createState() => _VehicleRepairsState();
// }

// class _VehicleRepairsState extends State<VehicleRepairs> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final _formKey = new GlobalKey<FormState>();

//   TextEditingController notesController = TextEditingController();
//   List<dynamic> data = List<dynamic>();
//   List<Asset> images = List<Asset>();
//   List<http.MultipartFile> files = List<http.MultipartFile>();
//   Position position;
//   String _error;
//   int depotId;
//   var userId;
//   var token;
//   bool uploading = false;
//   @override
//   initState() {
//     super.initState();
//     initialise();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   void initialise() async {
//     await getVehicles();
//   }

//   Future<String> getVehicles() async {
//     await getToken().then((result) {
//       token = result;
//     });

//     await getDepotId().then((result) {
//       setState(() {
//         depotId = int.parse(result);
//       });
//     });

//     Map<String, int> body = {
//       'depotId': depotId,
//     };

//     var dio = new Dio();

//     dio.options.headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/json-patch+json",
//       "Authorization": "Bearer $token",
//     };

//     final response =
//         await dio.post(BASE_URL + '/api/incidents/GetDepotsVehicles', data: {
//       'depotId': depotId,
//     });

//     if (response.statusCode == 200) {
//       var responseJson = response.data;
//       print(responseJson);
//       setState(() {
//         data = responseJson;
//       });
//       print(data);

//       return "Success";
//     } else {
//       return "Failed";
//     }
//   }

//   Widget buildGridView() {
//     return GridView.count(
//         crossAxisCount: 3,
//         children: List.generate(images == null ? 0 : images.length, (index) {
//           Asset asset = images[index];
//           return AssetThumb(
//             asset: asset,
//             width: 300,
//             height: 300,
//           );
//         }));
//   }

//   Future<void> loadAssets() async {
//     setState(() {
//       images = List<Asset>();
//     });

//     List<Asset> resultList;
//     String error;

//     try {
//       resultList = await MultiImagePicker.pickImages(maxImages: 20);
//     } on Exception catch (e) {
//       error = e.toString();
//       print(e.toString());
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       images = resultList;
//       if (error == null) _error = 'No Error Dectected';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: Colors.white,
//         resizeToAvoidBottomPadding: false,
//         appBar: AppBar(
//           leading: IconButton(
//               icon: Icon(Icons.arrow_back_ios, color: Colors.black),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/dashboard');
//               }),
//           backgroundColor: Colors.white,
//           title: Image.asset(
//             "assets/images/image_04.png",
//             width: new ScreenUtil().setWidth(500),
//             height: new ScreenUtil().setHeight(350),
//           ),
//           centerTitle: true,
//         ),
//         body: Card(
//             margin: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 25.0),
//             child: Container(
//               margin: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: <Widget>[
//                     AutoSizeText(
//                       'Select your registration then attach your images to the form. After you have finished submit to create a new vehicle repair.',
//                       style: TextStyle(
//                           fontSize: 18.0, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 20.0),
//                     DropdownButton(
//                       isExpanded: true,
//                       items: data.map((item) {
//                         return DropdownMenuItem(
//                           child: new Text(item['registration']),
//                           value: item['id'],
//                         );
//                       }).toList(),
//                       onChanged: (newVal) {
//                         setState(() {
//                           vehicleIdChosen = newVal;
//                         });
//                       },
//                       value: vehicleIdChosen,
//                     ),
//                     SizedBox(
//                       width: new ScreenUtil().screenWidth,
//                       height: 50,
//                       child: RaisedButton(
//                           child: AutoSizeText('Pick Images...',
//                               style: TextStyle(
//                                   color: Colors.white, fontSize: 18.0)),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0)),
//                           onPressed: loadAssets),
//                     ),
//                     Expanded(child: buildGridView()),
//                     TextField(
//                       decoration: InputDecoration(
//                         hintText: 'Write your notes here.',
//                         filled: true,
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                           borderSide: BorderSide(color: Colors.grey),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                           borderSide: BorderSide(color: Colors.grey),
//                         ),
//                       ),
//                       controller: notesController,
//                       keyboardType: TextInputType.multiline,
//                       maxLines: 5,
//                     ),
//                     Container(
//                       margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
//                     ),
//                     uploading == true
//                         ? Center(
//                             child: CircularProgressIndicator(
//                                 backgroundColor: vimPrimary))
//                         : SizedBox(
//                             width: new ScreenUtil().screenWidth,
//                             height: 50,
//                             child: RaisedButton(
//                                 child: AutoSizeText('Send',
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 18.0)),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0)),
//                                 onPressed: () => _sendVehicleRepair()),
//                           )
//                   ],
//                 ),
//               ),
//             )));
//   }

//   _sendVehicleRepair() async {
//     setState(() {
//       uploading = true;
//     });

//     //Convert List<Asset> to List<Files>
//     for (var asset in images) {
//       ByteData byteData = await asset.getByteData();
//       List<int> imageData = byteData.buffer.asUint8List();
//       var filename = asset.name;

//       //var uploadFile = MultipartFile.fromBytes(imageData, filename);

//       http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
//         'photo',
//         imageData,
//         filename: 'vehicle-repair-$filename.jpg',
//         contentType: MediaType("image", "jpg"),
//       );

//       files.add(multipartFile);
//     }

//     //Create time of vehicle repair
//     var dateTime = DateTime.now();
//     var formatter = new DateFormat('yyyy/MM/dd HH:mm:ss');
//     String formatted = formatter.format(dateTime).toString();

//     //Get userid
//     await getUserId().then((result) {
//       userId = result;
//     });

//     //Get current location
//     position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

//     var vehicleRepair = new CreateVehicleRepair(vehicleIdChosen, formatted,
//             userId, position.latitude, position.longitude, notesController.text)
//         .toJson();

//     var body = json.encode(vehicleRepair);
//     print("Begin creating vehicle repair");
//     var dio = Dio();
//     //Http post the vehicle repair to the backend
//     var response =
//         await dio.post(BASE_URL + "/api/vehiclerepairs/Create", data: body);

//     print(response.data.toString());

//     //Get latest incident id
//     var incidentId = await getLatestIncidentId(context);

//     //Post images to vehicle repair
//     var incidentIdString = incidentId.toString();

//     await getToken().then((result) {
//       token = result;
//     });

//     dio.options.headers = {
//       "Accept": "application/json",
//       "Content-Type": "multipart/form-data",
//       "Authorization": "Bearer $token",
//     };

//     try {
//       FormData formData =
//           new FormData.fromMap({"Id": incidentId, "Files": files});

//       var response = await dio.post(
//         BASE_URL + "/api/vehiclerepairs/PostImages",
//         data: formData,
//       );
//       print(response.data.toString());
//     } catch (e) {
//       print("PostVehicleRepairsImages Error" + e);
//     }

//     setState(() {
//       uploading = false;
//     });
//   }

//   MediaType(String s, String t) {}
// }
