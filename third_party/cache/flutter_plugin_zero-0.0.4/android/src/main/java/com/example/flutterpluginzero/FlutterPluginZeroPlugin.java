package com.example.flutterpluginzero;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

import com.ihealth.communication.control.Bg1Control;

import java.util.Calendar;

import bd.com.cmed.devices_lib.comm.CMEDDevice;
import bd.com.cmed.devices_lib.comm.CMEDDeviceCallback;
import bd.com.cmed.devices_lib.comm.CMEDDeviceHandler;
import bd.com.cmed.devices_lib.comm.CMEDDeviceResponse;
import bd.com.cmed.devices_lib.comm.CMEDResponse;
import bd.com.cmed.devices_lib.error.Bg1Error;
import bd.com.cmed.devices_lib.error.CMEDDeviceError;
import es.dmoral.toasty.Toasty;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterPluginZeroPlugin */
public class FlutterPluginZeroPlugin implements MethodCallHandler, CMEDDeviceCallback {

  private final MethodChannel channel;
  private Activity activity;
  boolean isConnected = false;

  CMEDDeviceHandler cmedDeviceHandler;


  Context context;

  public FlutterPluginZeroPlugin(MethodChannel channel, Activity activity) {
    this.channel = channel;
    this.activity = activity;
    this.channel.setMethodCallHandler(this);
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_plugin_zero");
    channel.setMethodCallHandler(new FlutterPluginZeroPlugin(channel, registrar.activity()));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {

    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("showToast")){
      int msg=call.argument("msg");
      int msg1=call.argument("msg1");
      Toast.makeText(activity, "Summation: "+String.valueOf(msg+msg1), Toast.LENGTH_LONG).show();

    } else if (call.method.equals("openCamera")){
      Toasty.success(activity, "Camera Opening").show();
      new camera(activity).openCamera();

    } else if (call.method.equals("deviceConnect")){

      cmedDeviceHandler.setCallback(this);
      cmedDeviceHandler.connect(CMEDDevice.IHEALTH_BP3L);

//      if (btnConnect.getText().equals(getResources().getText(ButtonLevel.Connect.getLevel()))){
//
//        //tvResult.setText(null);
//
//      }

//      else if(btnConnect.getText().equals(getResources().getText(ButtonLevel.StartMeasure.getLevel()))){
//        if (isConnected){
//          deviceHandler.startMeasure();
//        }
//
//      } else if(btnConnect.getText().equals(getResources().getText(ButtonLevel.StopMeasure.getLevel()))){
//        deviceHandler.disconnect();
//        isConnected = false;
//        tvConnectionStatus.setText(getResources().getText(R.string.tv_disconnected));
//        btnConnect.setText(getResources().getText(ButtonLevel.Connect.getLevel()));
//        if (measurement == null)
//          measurement = new Measurement();
//        measurement.setValue1(Double.parseDouble(resultSp02));
//        measurement.setLocalType(LocalMType.SPO2);
//        measurement.setMeasuredAt(com.genericslab.droidplate.utils.DateUtils.isoStdFormat(Calendar.getInstance()));
//        mViewModel.saveMeasurement(measurement);
//      }



    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onConnected() {
    isConnected = true;
  }

  @Override
  public void onGetResponse(CMEDDeviceResponse cmedDeviceResponse) {
    try {
      if (!cmedDeviceResponse.getResponse().equals(CMEDResponse.MC_DEVICE_DETECTED)){
        Toasty.success(activity, "Response");
      }
        //tvConnectionStatus.setText(cmedDeviceResponse.getResponseMessage());
    }catch (Exception e){

    }
  }

  @Override
  public void onGetMeasurement(String s) {
//    try {
//      tvConnectionStatus.setText(getResources().getText(R.string.tv_measuring));
//      btnConnect.setText(getResources().getText(ButtonLevel.StopMeasure.getLevel()));
//      getDisplay(measure);
//    }catch (Exception e){
//
//    }
  }

  @Override
  public void onDisconnected() {
//    try {
//      isConnected = false;
//      tvConnectionStatus.setText(getResources().getText(R.string.tv_disconnected));
//      btnConnect.setText(getResources().getText(ButtonLevel.Connect.getLevel()));
//    }catch (Exception e){}
  }

  @Override
  public void onError(CMEDDeviceError cmedDeviceError) {

  }

  private void getDisplay(String raw) {
//    String splits[] = raw.split(":");
//    resultSp02 = splits[0];
//    resultPulse = splits[1];
//
//    if (resultSp02 != null && resultPulse != null) {
//      tvResult.setText(getResources().getText(R.string.label_sp02)+":    "+resultSp02+"%"+"\n"+getResources().getText(R.string.label_bp_pulse_hint)+":    "+resultPulse);
//    }
  }
}
