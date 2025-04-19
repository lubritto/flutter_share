import 'dart:async';

import 'package:flutter/services.dart';
import 'flutter_share_platform_interface.dart';
export 'flutter_share_method.dart';

/// A Flutter plugin for sharing content via the platform share UI.
class FlutterShare {
  /// Shares a message or/and link url with app chooser.
  ///
  /// - Title: Is the [title] of the message. Used as email subject if sharing
  /// with mail apps. The [title] cannot be null.
  /// - Text: Is the [text] of the message.
  /// - LinkUrl: Is the [linkUrl] to include with the message.
  /// - ChooserTitle (Just for Android): Is the [chooserTitle] of the app
  /// chooser popup. If null the system default title will be used.
  static Future<bool?> share({
    required String title,
    String? text,
    String? linkUrl,
    String? chooserTitle,
  }) {
    return FlutterSharePlatform.instance.share(
      title: title,
      text: text,
      linkUrl: linkUrl,
      chooserTitle: chooserTitle,
    );
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
  static Future<bool?> shareFile({
    required String title,
    required String filePath,
    String? text,
    String? chooserTitle,
    String fileType = '*/*',
  }) {
    return FlutterSharePlatform.instance.shareFile(
      title: title,
      filePath: filePath,
      text: text,
      chooserTitle: chooserTitle,
      fileType: fileType,
    );
  }
}
