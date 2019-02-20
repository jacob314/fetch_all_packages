package com.saltedfish.gallery.saltedfishgalleryinserter;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.provider.MediaStore;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** SaltedfishGalleryInserterPlugin */
public class SaltedfishGalleryInserterPlugin implements MethodCallHandler {
  private static  Registrar r;
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    r = registrar;
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "saltedfish_gallery_inserter");
    channel.setMethodCallHandler(new SaltedfishGalleryInserterPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("insertToGallery")) {

      byte [] bytes = (byte[]) call.arguments;
      Bitmap bitmap = BitmapFactory.decodeByteArray(bytes,0,bytes.length);
      Map<String,String> resultMap = Collections.synchronizedMap(new LinkedHashMap<String,String>());
      try {

        String path = MediaStore.Images.Media.insertImage(r.activity().getContentResolver(), bitmap, null, null);
        resultMap.put("resultCode","success");
        resultMap.put("path",path);
      }catch(Exception e){
        resultMap.put("resultCode","failed");
      }finally {
        result.success(resultMap);
      }
    }
  }
}
