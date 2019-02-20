package com.example.flutterplugin

import android.util.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterPlugin() : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "flutter_plugin")
            channel.setMethodCallHandler(FlutterPlugin())
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method.equals("printLog")) {

            val msg: String = call.argument("msg")
            val tag: String = call.argument("tag")
            val logType: String = call.argument("logType")

            if (logType.equals("warning")) {
                Log.w(tag, msg)
            } else if (logType.equals("error")) {
                Log.e(tag, msg)
            } else {
                Log.d(tag, msg)
            }

            result.success("Logged Successfully!")

        } else {
            result.notImplemented()
        }
    }
}
