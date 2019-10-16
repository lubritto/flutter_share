import 'dart:async';
import 'dart:io';

import 'package:documents_picker/documents_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final _controller = ScreenshotController();

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }

  Future<void> shareFile() async {
    List<dynamic> docs = await DocumentsPicker.pickDocuments;
    if (docs == null || docs.isEmpty) return null;

    await FlutterShare.shareFile(
      title: 'Example share',
      text: 'Example share text',
      filePath: docs[0] as String,
    );
  }

  Future<void> shareScreenShot() async {
    Directory directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    final String localPath =
        '${directory.path}/${DateTime.now().toIso8601String()}.png';

    await _controller.capture(path: localPath);

    await Future.delayed(Duration(seconds: 1));

    await FlutterShare.shareFile(
      title: 'Compartilhar comprovante',
      filePath: localPath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Screenshot(
            controller: _controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text('Share text and link'),
                  onPressed: share,
                ),
                FlatButton(
                  child: Text('Share local file'),
                  onPressed: shareFile,
                ),
                FlatButton(
                  child: Text('Share screenshot'),
                  onPressed: shareScreenShot,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
