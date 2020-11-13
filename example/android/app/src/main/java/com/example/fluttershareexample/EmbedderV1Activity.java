package com.example.fluttershareexample;

import android.os.Bundle;

import com.example.documentspicker.DocumentsPickerPlugin;
import com.example.fluttershare.FlutterSharePlugin;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.pathprovider.PathProviderPlugin;

public class EmbedderV1Activity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        PathProviderPlugin.registerWith(registrarFor("io.flutter.plugins.flutter.io/path_provider"));
        DocumentsPickerPlugin.registerWith(
                registrarFor("com.example.documentspicker.DocumentsPickerPlugin"));
        FlutterSharePlugin.registerWith(registrarFor("com.example.fluttershareexample.FlutterShare"));
    }
}