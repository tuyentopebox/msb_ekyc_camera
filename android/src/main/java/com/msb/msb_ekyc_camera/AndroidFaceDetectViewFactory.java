package com.msb.msb_ekyc_camera;

import android.content.Context;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import static io.flutter.plugin.common.PluginRegistry.Registrar;


public class AndroidFaceDetectViewFactory extends PlatformViewFactory {

    private final Registrar mPluginRegistrar;

    public AndroidFaceDetectViewFactory(Registrar registrar) {
        super(StandardMessageCodec.INSTANCE);
        mPluginRegistrar = registrar;
    }

    @Override
    public PlatformView create(Context context, int i, Object o) {
        return new AndroidFaceDetectView(context, mPluginRegistrar, i);
    }
}