package com.example.flutterfolioreader

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.*

class FlutterFolioViewPagerFactory(val messager: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
  override fun create(p0: Context, p1: Int, p2: Any?): PlatformView {
    return FlutterFolioViewPager(p0, messager, p1, p2 as String)
  }
}