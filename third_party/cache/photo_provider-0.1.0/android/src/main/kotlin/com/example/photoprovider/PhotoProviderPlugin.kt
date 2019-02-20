package com.example.photoprovider

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar

class PhotoProviderPlugin private constructor(private val activity: Activity, channel: MethodChannel): MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "top.sp0cket.photo_provider")
      channel.setMethodCallHandler(PhotoProviderPlugin(registrar.activity(), channel))
    }
  }
  init {
      PhotoProvider.instance.activity = activity
  }
  override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?): Boolean {
    if (permissions == null || grantResults == null) {
      return false
    }
    if (requestCode == 1 && permissions.isNotEmpty() && grantResults.isNotEmpty()) {
      for (i in permissions.indices) {
        if (permissions[i] == Manifest.permission.READ_EXTERNAL_STORAGE) {
          if (grantResults[i] == PackageManager.PERMISSION_GRANTED) {
            PhotoProvider.instance.init()
          }
        }
      }
    }
    return false
  }
  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "init" -> PhotoProvider.instance.init()
      "hasPermission" -> result.success(PhotoProvider.instance.checkPermission())
      "imagesCount" -> result.success(PhotoProvider.instance.imageListCount)
      "getImage" -> {
        val arg = call.arguments as Map<String, Any>
        val index = arg["index"] as Int
        PhotoProvider.instance.getImage(index,
                width = arg["width"] as? Int,
                height = arg["height"] as? Int,
                compress = arg["compress"] as? Int,
                result = result)
      }
      else -> result.notImplemented()
    }
  }
}
