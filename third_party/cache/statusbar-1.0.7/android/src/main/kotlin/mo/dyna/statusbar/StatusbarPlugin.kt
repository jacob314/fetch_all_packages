package mo.dyna.statusbar

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar

class StatusbarPlugin(): MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar): Unit {
      val channel = MethodChannel(registrar.messenger(), "statusbar")

      val plugin = StatusbarPlugin()
      plugin.activity = registrar.activity()
      plugin.default = registrar.activity().getWindow().getStatusBarColor()
      channel.setMethodCallHandler(plugin)
    }
  }

  private var activity: android.app.Activity? = null
  private var color: Int? = null
  private var default: Int? = null
  private var active = false

  override fun onMethodCall(call: MethodCall, result: Result): Unit
  {
    if (call.method.equals("show"))
    {
      if(active == false)
      {
        active = true
        val c = color
        if (c != null)
        {
          activity?.getWindow()?.setStatusBarColor(c);
        }
      }
    }
    else if(call.method.equals("hide"))
    {
      val c = default
      if(c != null)
      {
        activity?.getWindow()?.setStatusBarColor(c);
      }
    }
    else if(call.method.equals("color"))
    {
      color = android.graphics.Color.parseColor(call.argument("hex"))
      if(active)
      {
        val c = color
        if (c != null)
        {
          activity?.getWindow()?.setStatusBarColor(c);
        }
      }
    }
    else
    {
      result.notImplemented()
    }
  }
}
