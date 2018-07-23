package com.example.fluttershare;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterSharePlugin */
public class FlutterSharePlugin implements MethodCallHandler {

  private Activity activity;

  private FlutterSharePlugin(Activity activity) {
    this.activity = activity;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_share");
    FlutterSharePlugin plugin = new FlutterSharePlugin(registrar.activity());
    channel.setMethodCallHandler(plugin);
    channel.setMethodCallHandler(plugin);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("share")) {

      String title = call.argument("title");
      //String message = call.argument("message");
      String fileUrl = call.argument("fileUrl");

      try
      {
        if (fileUrl == null || fileUrl == "")
        {
          Log.println(Log.INFO, "", "FlutterShare: ShareLocalFile Warning: fileUrl null or empty");
          return;
        }

        if (!fileUrl.startsWith("file://"))
          fileUrl = "file://" + fileUrl;

        Uri fileUri = Uri.parse(fileUrl);

        Intent intent = new Intent();
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.setAction(Intent.ACTION_SEND);
        intent.setType("*/*");
        intent.putExtra(Intent.EXTRA_STREAM, fileUri);
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

        Intent chooserIntent = Intent.createChooser(intent, title);
        chooserIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        chooserIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        activity.startActivity(chooserIntent);

        result.success(true);
      }
      catch (Exception ex)
      {
        if (ex != null)
          Log.println(Log.INFO, "", "FlutterShare: Error");

      }

      result.success(false);
    } else {
      result.notImplemented();
    }
  }
}
