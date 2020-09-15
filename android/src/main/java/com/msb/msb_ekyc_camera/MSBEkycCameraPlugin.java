package com.msb.msb_ekyc_camera;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;

/** MSBEkycCameraPlugin */
public class MSBEkycCameraPlugin implements FlutterPlugin {
    public static void registerWith(Registrar registrar) {
        registrar
                .platformViewRegistry()
                .registerViewFactory(
                        "face_detect_view", new AndroidFaceDetectViewFactory(registrar));
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {

    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }
}
