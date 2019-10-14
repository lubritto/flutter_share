package com.example.fluttershare;

import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import org.apache.commons.io.FileUtils;


/** FlutterSharePlugin */
public class FlutterSharePlugin implements MethodCallHandler {

    private Registrar mRegistrar;

    private FlutterSharePlugin(Registrar mRegistrar) {
        this.mRegistrar = mRegistrar;
    }

    /** Plugin registration. */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_share");
        FlutterSharePlugin plugin = new FlutterSharePlugin(registrar);
        channel.setMethodCallHandler(plugin);
    }


    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("shareFile")) {
            result.success(shareFile(call));
        } else if (call.method.equals("share")) {
            result.success(share(call));
        } else {
            result.notImplemented();
        }
    }

    private boolean share(MethodCall call) {
        try
        {
            String title = call.argument("title");
            String text = call.argument("text");
            String linkUrl = call.argument("linkUrl");
            String chooserTitle = call.argument("chooserTitle");

            if (title == null || title.isEmpty())
            {
                Log.println(Log.ERROR, "", "FlutterShare Error: Title null or empty");
                return false;
            }

            ArrayList<String> extraTextList = new ArrayList<>();

            if (text != null && !text.isEmpty()) {
                extraTextList.add(text);
            }
            if (linkUrl != null && !linkUrl.isEmpty()) {
                extraTextList.add(linkUrl);
            }

            String extraText = "";

            if (!extraTextList.isEmpty()) {
                extraText = TextUtils.join("\n\n", extraTextList);
            }

            Intent intent = new Intent();
            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent.setAction(Intent.ACTION_SEND);
            intent.setType("text/plain");
            intent.putExtra(Intent.EXTRA_SUBJECT, title);
            intent.putExtra(Intent.EXTRA_TEXT, extraText);

            Intent chooserIntent = Intent.createChooser(intent, chooserTitle);
            chooserIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            chooserIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            mRegistrar.context().startActivity(chooserIntent);

            return true;
        }
        catch (Exception ex)
        {
            Log.println(Log.ERROR, "", "FlutterShare: Error");
        }

        return false;
    }

    private boolean shareFile(MethodCall call) {
        File file = null;

        String title = call.argument("title");
        String text = call.argument("text");
        String filePath = call.argument("filePath");
        String chooserTitle = call.argument("chooserTitle");

        try
        {
            if (filePath == null || filePath.isEmpty())
            {
                Log.println(Log.ERROR, "", "FlutterShare: ShareLocalFile Error: filePath null or empty");
                return false;
            }

            String fileName = Uri.parse(filePath).getLastPathSegment();

            File oldFile = new File(filePath);

            byte[] bArray = FileUtils.readFileToByteArray(oldFile);

            String tempDirPath = mRegistrar.context().getExternalCacheDir()
                    + File.separator + "TempFiles" + File.separator;
            String path = tempDirPath + fileName;

            File tempDir = new File(tempDirPath);

            file = new File(path);

            if (!tempDir.exists())
                tempDir.mkdirs();
            else {
                DeleteAllTempFiles();
            }

            file.createNewFile();

            FileOutputStream fo = new FileOutputStream(file);
            fo.write(bArray);
            fo.close();

            Uri fileUri = Uri.parse(file.getPath());

            Intent intent = new Intent();
            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent.setAction(Intent.ACTION_SEND);
            intent.setType("*/*");
            intent.putExtra(Intent.EXTRA_SUBJECT, title);
            intent.putExtra(Intent.EXTRA_TEXT, text);
            intent.putExtra(Intent.EXTRA_STREAM, fileUri);
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

            Intent chooserIntent = Intent.createChooser(intent, chooserTitle);
            chooserIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            chooserIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            mRegistrar.context().startActivity(chooserIntent);

            return true;
        }
        catch (IOException ex) {
            ex.printStackTrace();
            Log.println(Log.ERROR, "", "FlutterShare: IOException");
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
            Log.println(Log.ERROR, "", "FlutterShare: Error");
        }
        finally {
            if (file != null)
                file.deleteOnExit();
        }

        return false;
    }


    public void DeleteAllTempFiles(){
        String tempDirPath = mRegistrar.context().getExternalCacheDir()
                + File.separator + "TempFiles" + File.separator;

        File tempDir = new File(tempDirPath);

        if (tempDir.exists()) {

            String[] children = tempDir.list();
            for (int i = 0; i < children.length; i++)
            {
                new File(tempDir, children[i]).delete();
            }
        }
    }
}
