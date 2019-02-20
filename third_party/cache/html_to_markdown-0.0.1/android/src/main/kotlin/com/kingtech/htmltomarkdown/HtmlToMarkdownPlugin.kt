package com.kingtech.htmltomarkdown

import android.content.Context
import com.overzealous.remark.Options
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import  com.overzealous.remark.Remark


class HtmlToMarkdownPlugin {

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "html_to_markdown")
      channel.setMethodCallHandler(MarkdownPlugin(registrar))

    }
  }

}

class MarkdownPlugin(registrar: Registrar): MethodCallHandler{

    private fun parse(t:String, option:Int) : String {

        val opt: Options = when (option) {
            1 -> Options.markdown()
            2 -> Options.github()
            3 -> Options.markdownExtra()
            4 -> Options.multiMarkdown();
            else -> Options.markdown()
        }

        val htmlParser = Remark(opt)
        return htmlParser.convert(t)

    }

    override fun onMethodCall(call: MethodCall?, result: Result?) {
        if (call!!.method == "convert") {
            val text : String = call.argument<String>("html")!!;
            val option: Int = call.argument<Int>("markdown_type")!!;
            result!!.success(parse(text, option))
        } else {
            result!!.notImplemented()
        }
    }


}