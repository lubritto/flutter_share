import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:documents_picker/documents_picker.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    bool teste;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {

      List<dynamic> docs = await DocumentsPicker.pickDocuments;
      teste = await FlutterShare.share(title: 'teste', fileUrl: docs[0] as String);

    } on PlatformException {

    }

    if (!mounted) return;

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: new Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
