package com.plugin.nativetimezone

import android.app.Activity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.TimeZone

class NativeTimezonePlugin(val activity: Activity): MethodCallHandler {
  var placeResult: Result? = null
  val REQUEST_GOOGLE_PLAY_SERVICES = 1000
  var PLACE_PICKER_REQUEST: Int = 42
  companion object {
    lateinit var channel: MethodChannel
    @JvmStatic
    fun registerWith(registrar: Registrar) : Unit {
      channel = MethodChannel(registrar.messenger(), "native_timezone")
      val plugin = NativeTimezonePlugin(activity = registrar.activity())
      channel.setMethodCallHandler(plugin)
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when{
      call.method == "getLocalTimezone" -> {
        result.success(TimeZone.getDefault().getID())
        return
      }
      else -> result.notImplemented()
    }
  }
}
