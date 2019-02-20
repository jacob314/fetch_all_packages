package dev.codeplex.nativealertdialogplugin

import android.app.Activity
import android.content.DialogInterface
import android.graphics.Color
import android.support.v7.app.AlertDialog
import android.widget.Button
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar

class NativeAlertDialogPlugin(private val activity: Activity) : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "native_alert_dialog_plugin")
            channel.setMethodCallHandler(NativeAlertDialogPlugin(registrar.activity()))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "showNativeDialog" -> showDialog(call, result)

            else -> result.notImplemented()
        }
    }

    private fun showDialog(call: MethodCall, result: Result) {
        val title: String = call.argument("title")
        val body: String = call.argument("body")
        val positiveButtonText: String = call.argument("positiveButtonText")
        val negativeButtonText: String = call.argument("negativeButtonText")
        val primaryColor: Map<String, Int> = call.argument("buttonColor")
        val color = parseColor(primaryColor)

        val dialogResultHandler = DialogResultHandler(result)

        AlertDialog.Builder(activity, R.style.DialogBase)
                .setTitle(title)
                .setMessage(body)
                .setPositiveButton(positiveButtonText, dialogResultHandler)
                .setNegativeButton(negativeButtonText, dialogResultHandler)
                .setOnDismissListener(dialogResultHandler)
                .create()
                .apply {
                    if (color != null) {
                        setOnShowListener {
                            getButton(android.content.DialogInterface.BUTTON_POSITIVE).setTextColor(color)
                            getButton(android.content.DialogInterface.BUTTON_NEGATIVE).setTextColor(color)
                        }
                    }
                }
                .show()
    }

    private fun parseColor(color: Map<String, Int>?): Int? {
        return if (color == null) {
            null
        } else {
            val red: Int? = color["red"]
            val green: Int? = color["green"]
            val blue: Int? = color["blue"]
            val alpha: Int? = color["alpha"]

            if (red == null || green == null || blue == null || alpha == null) {
                null
            } else {
                Color.argb(alpha, red, green, blue)
            }
        }
    }

    private class DialogResultHandler(private val result: Result) : DialogInterface.OnClickListener, DialogInterface.OnDismissListener {

        private var resultSent = false

        override fun onClick(dialog: DialogInterface?, which: Int) {
            resultSent = true
            result.success(which == DialogInterface.BUTTON_POSITIVE)
        }

        override fun onDismiss(dialog: DialogInterface?) {
            if (!resultSent) {
                result.success(false)
            }
        }
    }
}
