import 'dart:async';

import 'package:flutter/services.dart';

class FlutterShare {
  static const MethodChannel _channel =
  const MethodChannel('flutter_share');

  //True if the operation was successful, false otherwise
  static Future<bool> share({String title, String fileUrl}) async {

    final bool sucess = await _channel.invokeMethod('share', <String, dynamic>{
      'title': title,
      //'message': message,
      'fileUrl': fileUrl,
    });


    return sucess;
  }
}
