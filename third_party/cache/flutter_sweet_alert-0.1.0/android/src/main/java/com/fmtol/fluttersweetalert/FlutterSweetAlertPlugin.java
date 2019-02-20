package com.fmtol.fluttersweetalert;

import android.app.Activity;

import java.util.Timer;
import java.util.TimerTask;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import cn.pedant.SweetAlert.SweetAlertDialog;
/** FlutterToastPlugin */
public class FlutterSweetAlertPlugin implements MethodCallHandler {
  private static SweetAlertDialog swal;
  private static SweetAlertDialog openDialog;
  private final MethodChannel channel;
  private Activity activity;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_sweet_alert");
    channel.setMethodCallHandler(new FlutterSweetAlertPlugin(registrar.activity(),channel));
  }

  private FlutterSweetAlertPlugin(Activity activity, MethodChannel channel){
    this.activity = activity;
    this.channel = channel;
    this.channel.setMethodCallHandler(this);
  }


  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if(call.method.equals("showDialog")){
      showSweetAlertDialog(call,result,false);
    }
    else if(call.method.equals("updateDialog")){
      showSweetAlertDialog(call,result,true);
    }

    else if(call.method.equals("close")){
      boolean closeWithAnimation=call.argument("closeWithAnimation");
      dismiss();
    }
    else {
      result.notImplemented();
    }
  }
  private void showSweetAlertDialog(MethodCall call, final Result result,boolean update) {
    final int type =call.argument("type");
    final String title=call.argument("title");
    final String content=call.argument("content");
    final String confirmText=call.argument("confirmButtonText");
    final boolean showCancelButton=call.argument("showCancelButton");
    final String cancelText=call.argument("cancelButtonText");
    final boolean cancelable=call.argument("cancelable");
    final int autoClose=call.argument("autoClose");
    final boolean closeOnConfirm=call.argument("closeOnConfirm");
    final boolean closeOnCancel=call.argument("closeOnCancel");
    if(update){
      if(openDialog==null){
        result.success(false);
        return;
      }
      swal=openDialog;
    }else{
      swal = new SweetAlertDialog(activity,type);
    }
    swal.setTitleText(title);
    swal.setContentText(content);
    swal.setConfirmText(confirmText);
    swal.setCancelable(cancelable);
    swal.setConfirmClickListener(new SweetAlertDialog.OnSweetClickListener() {
      @Override
      public void onClick(SweetAlertDialog sDialog) {
        if(closeOnConfirm){
          dismiss();
        }else{
          openDialog=sDialog;
        }
        result.success(true);
      }
    });
    if(showCancelButton){
      swal.setCancelButton(cancelText, new SweetAlertDialog.OnSweetClickListener() {
        @Override
        public void onClick(SweetAlertDialog sDialog) {
          if(closeOnCancel){
            dismiss();
          }else{
            openDialog=sDialog;
          }
          result.success(false);

        }
      });
      swal.showCancelButton(showCancelButton);
    }else{
      swal.setCancelText(null);
      swal.showCancelButton(showCancelButton);
    }
    if(update){
      swal.changeAlertType(type);
    }else{
      swal.show();
    }
    openDialog=swal;

    if(autoClose>0){
      Timer timer=new Timer();//实例化Timer类
      timer.schedule(new TimerTask(){
        public void run(){
          dismiss();
        }},autoClose);
    }

  }
  private void dismiss(){
    if(openDialog!=null){
        openDialog.dismissWithAnimation();

      openDialog=null;
    }
  }
}