package com.msb.msb_ekyc_camera_example;

import android.os.Bundle;
import com.msb.msb_ekyc_camera.MSBEkycCameraPlugin;
import com.baseflow.permissionhandler.PermissionHandlerPlugin;
import io.flutter.app.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        MSBEkycCameraPlugin.registerWith(registrarFor("com.msb.msb_ekyc_camera.MSBEkycCameraPlugin"));
        PermissionHandlerPlugin.registerWith(registrarFor("com.baseflow.permissionhandler.PermissionHandlerPlugin"));
    }
}
