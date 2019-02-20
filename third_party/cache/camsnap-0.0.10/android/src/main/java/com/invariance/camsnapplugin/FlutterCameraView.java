package com.invariance.camsnapplugin;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Rect;
import android.hardware.Camera;
import android.os.Build;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import static io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;

public class FlutterCameraView implements PlatformView, MethodChannel.MethodCallHandler
{
    private final CameraPreview camPreview;
    private final Camera camera;
    private final MethodChannel methodChannel;
    public static final String TAG = "camsnap";
    public static final int FOCUS_AREA_SIZE = 300;

    @SuppressLint("ClickableViewAccessibility")
    FlutterCameraView(Context context, BinaryMessenger messenger, int id) {
        if (!checkCameraHardware(context)) {
            Log.d(TAG,"Camera not found.");
        }
        camera = getCameraInstance();

        camPreview = new CameraPreview(context, camera);
        methodChannel = new MethodChannel(messenger, "com.invariance.camsnapplugin/cameraview_" + id);
        methodChannel.setMethodCallHandler(this);
        camPreview.setOnTouchListener(new View.OnTouchListener() {
            @TargetApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (event.getAction() == MotionEvent.ACTION_DOWN) {
                    focusOnTouch(event);
                }
                return true;
            }
        });
    }

    @Override
    public View getView() {
        return camPreview;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "captureImage":
                captureImage(methodCall, result);
                break;
            case "enablePreview":
                enablePreview();
                break;
            case "disablePreview":
                disablePreview();
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void dispose() {
        Log.d(TAG, "=============== DISPOSE CALLED");
        if (camera != null) {
            camera.stopPreview();
            camera.release();
        }
    }

    @TargetApi(Build.VERSION_CODES.ECLAIR)
    private void captureImage(MethodCall methodCall, Result result) {
        ArrayList args = (ArrayList) methodCall.arguments;
        String pictureFile = args.get(0) + File.separator + args.get(1);
        try {
            TakePictureCallback picCallback = new TakePictureCallback(pictureFile, result);
            camera.takePicture(null, null, picCallback);
        } catch (Exception e) {
            result.error("0", "Error", null);
        }
    }

    private void enablePreview() {
        camera.startPreview();
    }

    private void disablePreview() {
        camera.stopPreview();
        camera.release();
    }

    /** Check if this device has a camera */
    @TargetApi(Build.VERSION_CODES.ECLAIR)
    private boolean checkCameraHardware(Context context) {
        if (context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA)){
            // this device has a camera
            return true;
        } else {
            // no camera on this device
            return false;
        }
    }

    private static Camera getCameraInstance(){
        Camera c = null;
        try {
            c = Camera.open(); // attempt to get a Camera instance
        }
        catch (Exception e){
            Log.e(TAG, e.getMessage());
        }
        return c; // returns null if camera is unavailable
    }

    private Camera.AutoFocusCallback mAutoFocusTakePictureCallback = new Camera.AutoFocusCallback() {
        @Override
        public void onAutoFocus(boolean success, Camera camera) {
            if (success) {
                // do something...
                Log.i("tap_to_focus","success!");
            } else {
                // do something...
                Log.i("tap_to_focus","fail!");
            }
        }
    };

    @TargetApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    private void focusOnTouch(MotionEvent event) {
        if (camera != null ) {
            Camera.Parameters parameters = camera.getParameters();
            if (parameters.getMaxNumMeteringAreas() > 0){
                Log.i(TAG,"fancy !");
                Rect rect = calculateFocusArea(event.getX(), event.getY());

                parameters.setFocusMode(Camera.Parameters.FOCUS_MODE_AUTO);
                List<Camera.Area> meteringAreas = new ArrayList<Camera.Area>();
                meteringAreas.add(new Camera.Area(rect, 800));
                parameters.setFocusAreas(meteringAreas);

                camera.setParameters(parameters);
                camera.autoFocus(mAutoFocusTakePictureCallback);
            }else {
                camera.autoFocus(mAutoFocusTakePictureCallback);
            }
        }
    }

    private Rect calculateFocusArea(float x, float y) {
        int left = clamp(Float.valueOf((x / camPreview.getWidth()) * 2000 - 1000).intValue(), FOCUS_AREA_SIZE);
        int top = clamp(Float.valueOf((y / camPreview.getHeight()) * 2000 - 1000).intValue(), FOCUS_AREA_SIZE);

        return new Rect(left, top, left + FOCUS_AREA_SIZE, top + FOCUS_AREA_SIZE);
    }

    private int clamp(int touchCoordinateInCameraReper, int focusAreaSize) {
        int result;
        if (Math.abs(touchCoordinateInCameraReper)+focusAreaSize/2>1000){
            if (touchCoordinateInCameraReper>0){
                result = 1000 - focusAreaSize/2;
            } else {
                result = -1000 + focusAreaSize/2;
            }
        } else{
            result = touchCoordinateInCameraReper - focusAreaSize/2;
        }
        return result;
    }
}