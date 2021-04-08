import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterShare {
  static const MethodChannel _channel = MethodChannel('flutter_share');

  /// Shares a message or/and link url with app chooser.
  ///
  /// - Title: Is the [title] of the message. Used as email subject if sharing
  /// with mail apps. The [title] cannot be null.
  /// - Text: Is the [text] of the message.
  /// - LinkUrl: Is the [linkUrl] to include with the message.
  /// - ChooserTitle (Just for Android): Is the [chooserTitle] of the app
  /// chooser popup. If null the system default title will be used.
  static Future<bool?> share(
      {required String title,
      String? text,
      String? linkUrl,
      String? chooserTitle}) async {
    assert(title.isNotEmpty);

    if (title.isEmpty) {
      throw FlutterError('Title cannot be null');
    }

    final success = await _channel.invokeMethod('share', <String, dynamic>{
      'title': title,
      'text': text,
      'linkUrl': linkUrl,
      'chooserTitle': chooserTitle,
    });

    return success;
  }

  /// Shares a local file with the app chooser.
  ///
  /// - Title: It's the [title] of the message. Used as email subject if sharing
  /// with mail apps. The [title] cannot be null.
  /// - Text: It's the [text] of the message.
  /// - FilePath: It's the [filePath] to include with the message.
  /// - ChooserTitle (Just for Android): It's the [chooserTitle] of the app
  /// chooser popup. If null, the system default title will be used.
  /// - FileType (Just for Android): It's the [fileType] that will be sent in the 
  /// chooser popup. If null, the system default title will be used.
  static Future<bool?> shareFile(
      {required String title,
      required String filePath,
      String? text,
      String? chooserTitle,
      String fileType = '*/*'}) async {
    assert(title.isNotEmpty);
    assert(filePath.isNotEmpty);

    if (title.isEmpty) {
      throw FlutterError('Title cannot be null');
    } else if (filePath.isEmpty) {
      throw FlutterError('FilePath cannot be null');
    }

    final success =
        await _channel.invokeMethod('shareFile', <String, dynamic>{
      'title': title,
      'text': text,
      'filePath': filePath,
      'fileType': fileType,
      'chooserTitle': chooserTitle,
    });

    return success;
  }
}
