import 'package:flutter/services.dart';

/// The interface that implementations of flutter_share must implement.
abstract class FlutterSharePlatform {
  /// The method channel used to interact with the native platform.
  static const MethodChannel _channel = MethodChannel('flutter_share');

  static FlutterSharePlatform _instance = MethodChannelFlutterShare();

  /// The default instance of [FlutterSharePlatform] to use.
  static FlutterSharePlatform get instance => _instance;

  /// Share content
  Future<bool?> share({
    required String title,
    String? text,
    String? linkUrl,
    String? chooserTitle,
  }) {
    throw UnimplementedError('share() has not been implemented.');
  }

  /// Share file
  Future<bool?> shareFile({
    required String title,
    required String filePath,
    String? text,
    String? chooserTitle,
    String fileType = '*/*',
  }) {
    throw UnimplementedError('shareFile() has not been implemented.');
  }
}

/// An implementation of [FlutterSharePlatform] that uses method channels.
class MethodChannelFlutterShare extends FlutterSharePlatform {
  @override
  Future<bool?> share({
    required String title,
    String? text,
    String? linkUrl,
    String? chooserTitle,
  }) async {
    final bool? success = await FlutterSharePlatform._channel.invokeMethod('share', <String, dynamic>{
      'title': title,
      'text': text,
      'linkUrl': linkUrl,
      'chooserTitle': chooserTitle,
    });
    return success;
  }

  @override
  Future<bool?> shareFile({
    required String title,
    required String filePath,
    String? text,
    String? chooserTitle,
    String fileType = '*/*',
  }) async {
    final bool? success = await FlutterSharePlatform._channel.invokeMethod('shareFile', <String, dynamic>{
      'title': title,
      'text': text,
      'filePath': filePath,
      'fileType': fileType,
      'chooserTitle': chooserTitle,
    });
    return success;
  }
} 