import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:law_app/screens/drawer.dart';

class OnlineForumScreen extends StatefulWidget {
  _OnlineForumScreenState createState() => _OnlineForumScreenState();
}

class _OnlineForumScreenState extends State<OnlineForumScreen> {

  Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading = true;
  Widget loadingWidget(BuildContext context, double val) {
    return Opacity(
      opacity: val,
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ONLINE FORUM'),),
      drawer: AppDrawer(),
      body: WebView(
        initialUrl: 'http://forum.parliamentsl.com/',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
          loadingWidget(context, 1.0);
        },
        onPageFinished: (finish) {
          loadingWidget(context, 0.0);
        },
      ),
    );
  }
}
