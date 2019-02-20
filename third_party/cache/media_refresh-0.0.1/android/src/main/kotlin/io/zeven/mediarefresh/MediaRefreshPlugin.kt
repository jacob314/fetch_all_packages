package io.zeven.mediarefresh

import android.media.MediaScannerConnection
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar

class MediaRefreshPlugin() : MethodCallHandler {
	companion object {
		@JvmStatic
		fun registerWith(registrar: Registrar): Unit {
			val channel = MethodChannel(registrar.messenger(), "media_refresh")
			channel.setMethodCallHandler(MediaRefreshPlugin())
		}
	}

	override fun onMethodCall(call: MethodCall, result: Result): Unit {
		if (call.method.equals("scanFile")) {
			String url = call . argument ("url")
			MediaScannerConnection.scanFile(url)
			result.success(true)
		} else {
			result.notImplemented()
		}

		/*
		if (call.method.equals("getPlatformVersion")) {
			result.success("Android ${android.os.Build.VERSION.RELEASE}")
		} else {
			result.notImplemented()
		}
		*/
	}
}
