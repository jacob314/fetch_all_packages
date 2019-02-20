package com.ly.office

import android.renderscript.Sampler
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar
import jxl.Workbook
import jxl.write.Label
import jxl.write.WritableSheet
import jxl.write.WritableWorkbook
import java.io.File
import java.security.Key

class OfficePlugin() : MethodCallHandler {
    private var book: WritableWorkbook? = null
    private var sheet: WritableSheet? = null

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "plugins.ly.com/office")
            channel.setMethodCallHandler(OfficePlugin())
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        when (call.method) {
            "createWorkbook" -> {
                val path = call.argument("path") as String
                book = Workbook.createWorkbook(File(path))
            }
            "createSheet" -> {
                val name = call.argument("name") as Map<*, *>
                val aa = name["aa"] as Map<*, *>

                val which = call.argument("which") as Int
                sheet = book!!.createSheet(aa[0].toString(), which)
            }
            "addCell" -> {
                val column = call.argument("column") as Int
                val row = call.argument("row") as Int
                val content = call.argument("content") as String
                sheet!!.addCell(Label(column, row, content))
            }
            "setColumnView" -> {
                val column = call.argument("column") as Int
                val width = call.argument("width") as Int
                sheet!!.setColumnView(column, width)
            }
            "write" -> {
                book!!.write()
            }
            "close" -> {
                book!!.close()
            }
        }
    }
}
