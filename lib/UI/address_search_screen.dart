import 'dart:convert';

import 'package:commute/data/models/model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AddressSearchScreen extends StatelessWidget {

  // WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl: "https://jungeunhong1129.github.io/commute.github.io/search_address",
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
          // _controller = controller;
          // await loadHtmlFromAssets('assets/search_address.html', _controller);
        },
      ),
    );
  }
}