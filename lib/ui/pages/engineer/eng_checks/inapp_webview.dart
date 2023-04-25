import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:vim_mobile/ui/components/ui/colours.dart';


class HeadlessInAppWebViewExampleScreen extends StatefulWidget {
  final String url;
  final String title;
  HeadlessInAppWebViewExampleScreen({this.url,this.title});

  @override
  _HeadlessInAppWebViewExampleScreenState createState() =>
      new _HeadlessInAppWebViewExampleScreenState(url: url,title: title);
}

class _HeadlessInAppWebViewExampleScreenState
    extends State<HeadlessInAppWebViewExampleScreen> {

   String url;
  final String title;
  _HeadlessInAppWebViewExampleScreenState({this.url,this.title});
  double progress = 0;
  bool showLoader = true;
   InAppWebViewController webView;

   @override
  void initState() {
    super.initState();


  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: vimPrimary,
            title: Text(
              title,
            )),

        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(url)),
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                  )
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart: (controller,url) {
                setState(() {
                  showLoader=true;
                  this.url = url.toString();
                });
              },
              onLoadStop: ( controller, url) async {
                setState(() {
                  showLoader=false;
                  this.url = url.toString();
                });
              },
              onProgressChanged: (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),
            if(showLoader)Center(child: CircularProgressIndicator(color: vimPrimary,))
          ],
        ));
  }
}