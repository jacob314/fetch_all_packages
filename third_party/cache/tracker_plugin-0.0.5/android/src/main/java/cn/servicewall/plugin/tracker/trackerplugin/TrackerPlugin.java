package cn.servicewall.plugin.tracker.trackerplugin;

import android.app.Activity;
import android.content.Context;
import cn.servicewall.android.sdk.OptionBuilder;
import cn.servicewall.android.sdk.ServiceWallOption;
import cn.servicewall.android.sdk.ServiceWallSdk;
import cn.servicewall.android.sdk.ServiceWallSdkCallback;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.HashMap;
import java.util.Map;

/** TrackerPlugin */
public class TrackerPlugin implements MethodCallHandler {

  private static final String CHANNEL_NAME = "plugins.servicewall.cn/tracker";
  private final Registrar registrar;
  private final MethodChannel methodChannel;

  public TrackerPlugin(Registrar registrar, MethodChannel methodChannel) {
    this.registrar = registrar;
    this.methodChannel = methodChannel;
  }

  private Activity getActivity() {
    return registrar.activity();
  }

  private Context getApplicationContext() {
    return getActivity().getApplicationContext();
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
    channel.setMethodCallHandler(new TrackerPlugin(registrar, channel));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("initSWSdk")) {
      if (call.hasArgument("unique_id")) {
        String uniqueId = call.argument("unique_id");
        String channel = call.argument("channel");
        ServiceWallOption option =
            OptionBuilder.newBuilder(uniqueId).openLog(true).channel(channel).build();
        ServiceWallSdk.initWithCallback(getApplicationContext(), option,
            new ServiceWallSdkCallback() {
              @Override public void onError(int i) {
              }

              @Override public void onSuccess(String deviceInfo, String fingerPrintId) {
                Map<String, String> map = new HashMap<>();
                map.put("device_info", deviceInfo);
                map.put("fingerprint_id", fingerPrintId);
                methodChannel.invokeMethod("device_info", map);
              }
            });
      }
      result.success(true);
    } else {
      result.notImplemented();
    }
  }
}
