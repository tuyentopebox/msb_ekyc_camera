package com.msb.msb_ekyc_camera;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.view.LayoutInflater;
import android.Manifest;
import android.os.CountDownTimer;
import android.util.Log;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import com.karumi.dexter.Dexter;
import com.karumi.dexter.MultiplePermissionsReport;
import com.karumi.dexter.PermissionToken;
import com.karumi.dexter.listener.PermissionDeniedResponse;
import com.karumi.dexter.listener.PermissionGrantedResponse;
import com.karumi.dexter.listener.PermissionRequest;
import com.karumi.dexter.listener.multi.MultiplePermissionsListener;
import com.karumi.dexter.listener.single.PermissionListener;

import com.google.gson.Gson;
import com.lib.ekyc.core.ekyc.CameraSourcePreview;
import com.lib.ekyc.core.ekyc.EKYCManager;
import com.lib.ekyc.core.ekyc.GraphicOverlay;
import com.lib.ekyc.core.record.EKYCLogger;
import com.lib.ekyc.entity.DetectionParams;
import com.lib.ekyc.entity.Gesture;
import com.lib.ekyc.events.OnEKYCEvernts;
import com.lib.ekyc.misc.DetectionEvent;

import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

public class AndroidFaceDetectView implements PlatformView, MethodCallHandler, OnEKYCEvernts {

    private static final String TAG = "AndroidFaceDetectView";

    int viewId;
    Context context;
    Registrar registrar;
    View view;
    MethodChannel channel;

    private EKYCManager ekycManager = null;
    private DetectionParams detectionParams = null;
    @BindView(R2.id.fireFaceOverlay)
    GraphicOverlay graphicOverlay;

    @BindView(R2.id.firePreview)
    CameraSourcePreview cameraSourcePreview;
    List<Gesture> gestures = null;
    Gson gson  = new Gson();

    @Nullable private EventChannel.EventSink eventSink;

    AndroidFaceDetectView(Context context, Registrar registrar, int id) {
        this.context = context;
        this.registrar = registrar;
        this.viewId = id;
        this.view = LayoutInflater.from(registrar.activity()).inflate(R.layout.ekyc_preview, null);

        ButterKnife.bind(this, view);

        channel = new MethodChannel(registrar.messenger(), "face_detect_view_method_channel");
        channel.setMethodCallHandler(this);

        //event channel
        new EventChannel(registrar.messenger(), "face_detect_view_event_channel")
                .setStreamHandler(
                        new EventChannel.StreamHandler() {
                            @Override
                            public void onListen(Object arguments, EventChannel.EventSink sink) {
                                eventSink = sink;
                                eventSink.success("onListen");
                                EKYCLogger.print(TAG, "Create event stream success! onListen");
                            }

                            @Override
                            public void onCancel(Object arguments) {
                                eventSink = null;
                            }
                        });

        HardwarePermissionCheck();
    }

    @Override
    public View getView() {
        return view;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        Log.i(TAG, "onMethodCall " + call.method);
        switch (call.method) {
            case "startCamera":
                result.success(viewId);
                startEkycModule(detectionParams);
                break;
            case "stopCamera":
                break;
            case "resumeCameraPreview":
                break;
            case "stopCameraPreview":
                break;
            case "openFlash":
                break;
            case "closeFlash":
                break;
            case "toggleFlash":
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void dispose() {

    }

    /**
     * camera & audio permissions
     */
    private void HardwarePermissionCheck() {
        Dexter.withContext(registrar.activeContext())
                .withPermissions(Manifest.permission.CAMERA,Manifest.permission.RECORD_AUDIO)
                .withListener(new MultiplePermissionsListener() {
                    @Override
                    public void onPermissionsChecked(MultiplePermissionsReport multiplePermissionsReport) {
                        if (multiplePermissionsReport.areAllPermissionsGranted()){
                            init();
                        }
                    }

                    @Override
                    public void onPermissionRationaleShouldBeShown(List<PermissionRequest> list, PermissionToken permissionToken) {

                    }
                }).check();
    }

    /**
     * starting ekyc
     */
    private void init() {
        ekycManager = new EKYCManager(registrar.activity(),this);
        detectionParams = new DetectionParams();
        gestures = new ArrayList<>();
        long time = 30*1000;
        Gesture gesture0= new Gesture("blink_eye",time,0,0);
        Gesture gesture1= new Gesture("turn_right",time,0,0);
        Gesture gesture2 = new Gesture("turn_left",time,0,0);
        Gesture gesture3 = new Gesture("smile",time,0,0);
        gestures.add(gesture0);
        gestures.add(gesture1);
        gestures.add(gesture2);
        gestures.add(gesture3);

        detectionParams.setGestureList(gestures);

        //startEkycModule(detectionParams);
    }

    /**
     *
     * @param detectionParams
     */
    private void startEkycModule(DetectionParams detectionParams){
        ekycManager.startDetection(cameraSourcePreview,graphicOverlay,detectionParams);
        countDownTimer = detectNextGesture();
    }

    private CountDownTimer countDownTimer = null;
    @Override
    public void detectionEvents(DetectionEvent event, String gesture) {
        if(!event.equals(DetectionEvent.STARTED) && countDownTimer != null){
            countDownTimer.cancel();
            EKYCLogger.print(TAG,"Cancelled "+gesture);
        }
        if(event.equals(DetectionEvent.SUCCESS)){
            countDownTimer = handleSuccess(gesture);
        } else if(event.equals(DetectionEvent.FAILED)){
            gestures.clear();
            ekycManager.stopDetection();
        }else if(event.equals(DetectionEvent.STARTED)){

        }
        //TODO we should directly send data back to web via java script interface
        EKYCLogger.print(TAG,"Detection event "+event+ "gesture "+gesture);
        //Toast.makeText(this, "Detection event "+event+ "gesture "+gesture, Toast.LENGTH_LONG).show();
    }

    /**
     * This will handle susses
     * remove
     * include check the remaining gestures
     * invoke next gestre
     * @param gesture
     */

    private CountDownTimer handleSuccess(String gesture) {
        CountDownTimer timer = null;
        if(gestures == null)
            return timer;
        if(gestures.size() <= 0)
            return timer;
        if(gesture == null)
            return timer;
        timer =detectNextGesture();
        return timer;
    }

    /**
     *
     */
    private CountDownTimer detectNextGesture() {
        CountDownTimer timer = null;
        if(gestures.size() <= 0){
            return timer;
        }
        Gesture nextGexture = gestures.get(0);
        if(nextGexture == null)
        {
            EKYCLogger.printe(TAG,"gesture is null");
            return  timer;
        }
        timer = ekycManager.detectGesture(nextGexture);
        return  timer;
    }

    @Override
    public void onGestreDetectinCompleted(boolean b, String s) {
        EKYCLogger.print(TAG,"Detection event "+b+ "gesture "+s);
        //TODO fire event to web
        //cleaning detector
        //Toast.makeText(this, "face detection completed.", Toast.LENGTH_LONG).show();
    }
}