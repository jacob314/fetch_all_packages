package apps.markhamenterprises.testplugin

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class TestPlugin: MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flutterplugins.markhamenterprises.com/test_plugin")
      channel.setMethodCallHandler(TestPlugin())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
      if("kickBack" == call.method) {
        val kick = call.argument<String>("kick") as String
        val res = kickBack(kick)
        if(res != null){
            result.success("Android Got it : $res ");
        }else {
            result.error("ERROR", "Post failed.", null);
        }
      }else{
          result.notImplemented();
      }


  }

  private fun kickBack(kick:String):String{
    // do a proper return //
    return kick;
  }

}
