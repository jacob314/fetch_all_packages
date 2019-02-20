package com.paudio.flutterpaudio;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import android.media.MediaPlayer;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.File;
import android.app.Activity;


/** FlutterPaudioPlugin */
public class FlutterPaudioPlugin implements MethodCallHandler {

  private final Activity activity;

  private static MediaPlayer mp;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_paudio");
    channel.setMethodCallHandler(new FlutterPaudioPlugin(registrar.activity()));
    mp = new MediaPlayer();
  }

  private FlutterPaudioPlugin(Activity activity) {
    this.activity = activity;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("playAudio")) {
      double duration = playAudio((byte[])(call.arguments()));
      System.out.println("duration " + duration);
      result.success(duration);
    } else if (call.method.equals("stopAudio")) {
      stopAudio();
      result.success("success");
    } else {
      result.notImplemented();
    }
  }

  double playAudio(byte[] audioBytes) {
    try {
      mp.reset();
      System.out.println(audioBytes.length);
      // System.out.println(Arrays.toString(audioBytes));
      // create temp file that will hold byte array
      File tempAudio = File.createTempFile("temp", "wav", activity.getCacheDir());
      tempAudio.deleteOnExit();
      FileOutputStream fos = new FileOutputStream(tempAudio);
      fos.write(audioBytes);
      fos.close();
      // Tried passing path directly, but kept getting 
      // "Prepare failed.: status=0x1"
      // so using file descriptor instead
      FileInputStream fis = new FileInputStream(tempAudio);
      mp.setDataSource(fis.getFD());

      mp.prepare();
      mp.start();
      return mp.getDuration();
    } catch (Exception ex) {
      // result.success(ex.toString());
      // String s = ex.toString();
      ex.printStackTrace();
    }

    return 0;
  }

  void stopAudio() {
    mp.stop();
  }
}
