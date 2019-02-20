package org.golang.todo.libvia

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import via.Via

class LibviaPlugin: MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "libvia")
      channel.setMethodCallHandler(LibviaPlugin())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      //result.success("Android ${android.os.Build.VERSION.RELEASE}")
      result.success(Via.hello())
    } else {
      result.notImplemented()
    }
  }
}
