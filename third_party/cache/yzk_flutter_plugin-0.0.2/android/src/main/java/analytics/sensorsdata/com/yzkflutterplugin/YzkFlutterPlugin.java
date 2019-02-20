package analytics.sensorsdata.com.yzkflutterplugin;

import android.text.TextUtils;

import org.json.JSONObject;
import com.sensorsdata.analytics.android.sdk.SALog;
import com.sensorsdata.analytics.android.sdk.SensorsDataAPI;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** YzkFlutterPlugin */
public class YzkFlutterPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "yzk_flutter_plugin");
    channel.setMethodCallHandler(new YzkFlutterPlugin());
  }
  private static final String TAG = "SA.test";
  @Override
  public void onMethodCall(MethodCall call, Result result) {
    try {
      List list = (List) call.arguments;
      switch (call.method) {
        case "track":
          track(list);
          break;
        case "trackTimerStart":
          trackTimerStart(list);
          break;
        case "trackTimerEnd":
          trackTimerEnd(list);
          break;
        case "clearTrackTimer":
          clearTrackTimer();
          break;
        case "login":
          login(list);
          break;
        case "logout":
          logout();
          break;
        case "trackViewScreen":
          trackViewScreen(list);
          break;
        case "profileSet":
          profileSet(list);
          break;
        case "profileSetOnce":
          profileSetOnce(list);
          break;
        case "profileUnset":
          profileUnset(list);
          break;
        case "profileIncrement":
          profileIncrement(list);
          break;
        case "profileAppend":
          profileAppend(list);
          break;
        case "profileDelete":
          profileDelete();
          break;
        case "getDistinctId":
          getDistinctId(result);
          break;
        default:
          result.notImplemented();
          break;
      }
    } catch (Exception e) {
      e.printStackTrace();
      SALog.d(TAG, e.getMessage());
    }

  }

  /**
   * trackInstallation 记录激活事件
   */
  private void trackInstallation(List list) {
    SensorsDataAPI.sharedInstance().trackInstallation(assertEventName((String) list.get(0)), assertProperties((Map) list.get(1)));
  }

  /**
   * track 事件
   */
  private void track(List list) {
    SensorsDataAPI.sharedInstance().track(assertEventName((String) list.get(0)), assertProperties((Map) list.get(1)));
  }

  /**
   * login
   */
  private void login(List list) {
    SensorsDataAPI.sharedInstance().login(assertEventName((String) list.get(0)));
  }

  /**
   * trackViewScreen
   */
  private void trackViewScreen(List list) {
    SensorsDataAPI.sharedInstance().trackViewScreen((String) list.get(0), assertProperties((Map) list.get(1)));
  }

  /**
   * profileSet
   */
  private void profileSet(List list) {
    JSONObject properties = assertProperties((Map) list.get(0));
    if (properties == null) {
      return;
    }
    SensorsDataAPI.sharedInstance().profileSet(properties);
  }

  /**
   * getDistinctId
   */
  private void getDistinctId(Result result) {
    String loginId = SensorsDataAPI.sharedInstance().getLoginId();
    if (!TextUtils.isEmpty(loginId)) {
      result.success(loginId);
    } else {
      result.success(SensorsDataAPI.sharedInstance().getAnonymousId());
    }
  }

  /**
   * profileDelete
   */
  private void profileDelete() {
    SensorsDataAPI.sharedInstance().profileDelete();
  }

  /**
   * profileAppend
   */
  @SuppressWarnings("unchecked")
  private void profileAppend(List list) {
    SensorsDataAPI.sharedInstance().profileAppend((String) list.get(0), new HashSet<>((Collection<? extends String>) list.get(1)));
  }

  /**
   * profileIncrement
   */
  private void profileIncrement(List list) {
    SensorsDataAPI.sharedInstance().profileIncrement((String) list.get(0), (Number) list.get(1));
  }

  /**
   * profileUnset
   */
  private void profileUnset(List list) {
    SensorsDataAPI.sharedInstance().profileUnset((String) list.get(0));
  }

  /**
   * profileSetOnce
   */
  private void profileSetOnce(List list) {
    JSONObject properties = assertProperties((Map) list.get(0));
    if (properties == null) {
      return;
    }
    SensorsDataAPI.sharedInstance().profileSetOnce(properties);
  }

  /**
   * logout
   */
  private void logout() {
    SensorsDataAPI.sharedInstance().logout();
  }


  /**
   * clearTrackTimer
   */
  private void clearTrackTimer() {
    SensorsDataAPI.sharedInstance().clearTrackTimer();
  }

  /**
   * trackTimerStart
   */
  private void trackTimerStart(List list) {
    SensorsDataAPI.sharedInstance().trackTimerStart(assertEventName((String) list.get(0)));
  }

  /**
   * trackTimerEnd
   */
  private void trackTimerEnd(List list) {
    SensorsDataAPI.sharedInstance().trackTimerEnd(assertEventName((String) list.get(0)), assertProperties((Map) list.get(1)));
  }


  private JSONObject assertProperties(Map map) {
    if (map != null) {
      return new JSONObject(map);
    } else {
      SALog.d(TAG, "传入的属性为空");
      return null;
    }
  }

  private String assertEventName(String eventName) {
    if (TextUtils.isEmpty(eventName)) {
      SALog.d(TAG, "事件名为空，请检查代码");
    }
    return eventName;
  }

}
