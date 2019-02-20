package com.ly.wifiinfoexample
import android.os.Bundle

import android.content.Context
import io.flutter.app.FlutterActivity
import android.net.wifi.WifiManager
import io.flutter.plugin.common.MethodChannel

class MainActivity(): FlutterActivity() {
  private val CHANNEL = "samples.ly.com/wifiinfo"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "getWiFiName") {
        val wifiName = getWifiName()
        if (!wifiName.isEmpty()) {
          result.success(wifiName)
        } else {
          result.error("UNAVAILABLE", "Wifi name not available.", null)
        }
      } else {
        result.notImplemented()
      }
    }
  }

  private fun getWifiName(): String {
    val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
    return wifiManager.connectionInfo.ssid.replace("\"", "")
  }
}
