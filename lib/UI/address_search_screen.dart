import 'dart:convert';

import 'package:commute/data/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AddressSearchScreen extends StatelessWidget {

  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl: ,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: Set.from([
          JavascriptChannel(
              name: 'onComplete',
              onMessageReceived: (JavascriptMessage message) {
                //This is where you receive message from
                //javascript code and handle in Flutter/Dart
                //like here, the message is just being printed
                //in Run/LogCat window of android studio
                Navigator.pop(
                    context, AddressModel.fromJson(jsonDecode(message.message)));
              }),
        ]),
        onWebViewCreated: (WebViewController controller) async {
          _controller = controller;
          // await loadHtmlFromAssets('assets/search_address.html', _controller);
        },
      ),
    );
  }
  // Future<void> loadHtmlFromAssets(String filename, controller) async {
  //   String fileText = await rootBundle.loadString(filename);
  //   controller.loadUrl(Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  // }
}
////t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js