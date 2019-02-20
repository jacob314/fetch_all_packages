package com.det.fluttershareimage

import android.content.Intent
import android.net.Uri

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import java.io.File
import java.io.IOException

class FlutterShareImagePlugin(private var mRegistrar: Registrar) : MethodCallHandler {

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flutter_share_image")
      channel.setMethodCallHandler(FlutterShareImagePlugin(registrar))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "shareImage") {

      val title: String? = call.argument("title")
      val fileUrl: String? = call.argument("fileUrl")

      if (fileUrl == null || fileUrl === "") {
        print("FileUrl null or empty")
        return
      }

      shareImage(title, fileUrl)
      result.success(true)
    }
    else {
      result.notImplemented()
    }
  }

  private fun shareImage(title: String?, path: String) {
    try {
      val imageFile = File(path)
      val contentUri = Uri.fromFile(imageFile)

      val shareIntent = Intent()
      shareIntent.action = Intent.ACTION_SEND
      shareIntent.type = "image/*"
      shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri)
      mRegistrar.context().startActivity(Intent.createChooser(shareIntent, title))
    }
    catch (e: IOException) {
      print(e.message)
    }
  }
}
