package com.example.flutterfolioreader

import android.content.Intent
import android.util.Log
import com.folioreader.Config
import com.folioreader.Constants
import com.folioreader.FolioReader
import com.folioreader.model.ReadPosition
import com.folioreader.model.ReadPositionImpl
import com.folioreader.ui.folio.activity.FolioActivity
import com.folioreader.util.AppUtil
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.content.Context.ACTIVITY_SERVICE
import android.support.v4.content.ContextCompat.getSystemService
import android.app.ActivityManager
import android.content.Context
import android.graphics.Rect
import com.folioreader.model.HighLight
import com.folioreader.util.OnHighlightListener


class FlutterFolioreaderPlugin(val registrar: Registrar, val chanel: MethodChannel): MethodCallHandler {
  val onHighlightListener = object : OnHighlightListener() {
    override fun onHighlight(highlight: HighLight?, type: HighLight.HighLightAction?) {
      val data: HashMap<String, Any> = HashMap()
      data["rangy"] = highlight!!.rangy
      data["bookId"] = highlight.bookId
      data["content"] = highlight.content
      data["type"] = highlight.type
      data["pageNumber"] = highlight.pageNumber
      data["pageId"] = highlight.pageId
      data["uuid"] = highlight.uuid
      if (highlight.note != null) data["note"] = highlight.note
      chanel.invokeMethod("highlight", data)
    }

    override fun onTriggerHighlight(rect: Rect?, highlightId: String?) {
      Log.d("FolioReader", "777777777777777")
    }
  }

  val folioReader = FolioReader.get()
//      .setOnHighlightListener(onHighlightListener)
      .setReadPositionListener { readPosition ->
//        Log.i(LOG_TAG, "-> ReadPosition = " + readPosition.toJson())
      }
      .setOnClosedListener { chanel.invokeMethod("closed", null) }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flutter_folioreader")
      channel.setMethodCallHandler(FlutterFolioreaderPlugin(registrar, channel))

      registrar
          .platformViewRegistry()
          .registerViewFactory(
              "plugins.flutterfolioreader/FlutterFolioViewPager", FlutterFolioViewPagerFactory(registrar.messenger()))
    }
  }

//  private fun getLastReadPosition(): ReadPosition {
//    val jsonString = loadAssetTextAsString("read_positions/read_position.json")
//    return ReadPositionImpl.createInstance(jsonString)
//  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "openbook" -> {
        var config = AppUtil.getSavedConfig(registrar.activity().getApplicationContext())
        if (config == null)
          config = Config()
        config.allowedDirection = Config.AllowedDirection.VERTICAL_AND_HORIZONTAL

        val intent = Intent(registrar.context(), FolioActivity::class.java)
        intent.putExtra(Config.INTENT_CONFIG, config)
        intent.putExtra(Config.EXTRA_OVERRIDE_CONFIG, config)

        intent.putExtra(FolioActivity.INTENT_EPUB_SOURCE_PATH, call.argument<String>("path"))
        intent.putExtra(FolioActivity.INTENT_EPUB_SOURCE_TYPE,
            FolioActivity.EpubSourceType.SD_CARD)
        registrar.activity().startActivity(intent)

        folioReader.setConfig(config, true)
            .openBook(call.argument<String>("path"))
      }
      "back" -> {
        val activityManager = registrar.activity().getApplicationContext()
            .getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        activityManager.moveTaskToFront(registrar.activity().taskId, 0)
      }
      "open" -> {
        val intent = Intent(registrar.activeContext(), FolioActivity::class.java)
        registrar.activity().startActivity(intent)
      }
    }
  }
}
