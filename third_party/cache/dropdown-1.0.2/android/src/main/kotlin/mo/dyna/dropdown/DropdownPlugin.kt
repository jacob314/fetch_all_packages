package mo.dyna.dropdown

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar

class DropdownPlugin(): MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar): Unit {
      val channel = MethodChannel(registrar.messenger(), "dropdown")

      val plugin = DropdownPlugin()
      plugin.activity = registrar.activity()
      channel.setMethodCallHandler(plugin)
    }
  }

  private var activity: android.app.Activity? = null

  override fun onMethodCall(call: MethodCall, result: Result): Unit
  {
    if (call.method.equals("show"))
    {
      val foreground = android.graphics.Color.parseColor(call.argument("foreground"))
      val background = android.graphics.Color.parseColor(call.argument("background"))
      val message: String? = call.argument("message")

      activity?.let {
        EZDropdown.show(it, message, background, foreground)
      }
      result.success("done")
    }
    else
    {
      result.notImplemented()
    }
  }
}
