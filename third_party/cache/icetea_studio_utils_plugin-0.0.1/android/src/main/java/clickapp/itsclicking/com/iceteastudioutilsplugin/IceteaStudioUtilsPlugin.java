package clickapp.itsclicking.com.iceteastudioutilsplugin;

import android.content.Context;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** IceteaStudioUtilsPlugin */
public class IceteaStudioUtilsPlugin implements MethodCallHandler {

  private final Registrar mRegistrar;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "icetea_studio_utils_plugin");
    channel.setMethodCallHandler(new IceteaStudioUtilsPlugin(registrar));
  }

  private IceteaStudioUtilsPlugin(Registrar registrar) {
    mRegistrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case MethodChannelName.CHANNEL_APP_VERSION:
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case MethodChannelName.CHANNEL_SHOW_TOAST:
        showToast(call);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private void showToast(MethodCall call) {
    if(!call.hasArgument("msg")) {
      return;
    }
    String msg = call.argument("msg");
    String backgroundColor = "#84bd00";
    String textColor = "#ffffff";
    String toastType = "short";
    String isFullWith = "false";
    String gravity = "bottom";

    if(call.hasArgument("backgroundColor")) {
      backgroundColor = call.argument("backgroundColor");
    }
    if(call.hasArgument("textColor")) {
      textColor = call.argument("textColor");
    }
    if(call.hasArgument("length")) {
      toastType = call.argument("length");
    }
    if(call.hasArgument("isFullWidth")) {
      isFullWith = call.argument("isFullWidth");
    }
    if(call.hasArgument("gravity")) {
      gravity = call.argument("gravity");
    }

    Utils.showToast(getActiveContext(), msg, backgroundColor, textColor, Utils.getToastType(toastType),
            Utils.convertStringToBoolean(isFullWith),
            Utils.getGravity(gravity));
  }

  private Context getActiveContext() {
    return (mRegistrar.activity() != null) ? mRegistrar.activity() : mRegistrar.context();
  }

  class MethodChannelName {
    public static final String CHANNEL_APP_VERSION = "getPlatformVersion";
    public static final String CHANNEL_SHOW_TOAST = "showToast";
  }
}
