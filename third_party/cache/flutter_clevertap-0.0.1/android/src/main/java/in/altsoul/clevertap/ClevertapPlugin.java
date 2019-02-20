package in.altsoul.clevertap;

import android.app.Activity;
import android.util.Log;

import com.clevertap.android.sdk.CleverTapAPI;
import com.clevertap.android.sdk.exceptions.CleverTapMetaDataNotFoundException;
import com.clevertap.android.sdk.exceptions.CleverTapPermissionsNotSatisfied;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** ClevertapPlugin */
public class ClevertapPlugin implements MethodCallHandler {
  private String tag = "CleverTap";
  private Activity activity;
  private CleverTapAPI cleverTap;

  private ClevertapPlugin(Activity activity) {
    this.activity = activity;
    try {
      this.cleverTap = CleverTapAPI.getInstance(activity.getApplicationContext());
    } catch (CleverTapMetaDataNotFoundException e) {
      // handle appropriately
      Log.e(tag, e.getMessage());
    } catch (CleverTapPermissionsNotSatisfied e) {
      // handle appropriately
      Log.e(tag, e.getMessage());
    }
  Log.e(tag, "Created Plugin");
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "in.altsoul/clevertap");
    channel.setMethodCallHandler(
            new ClevertapPlugin(registrar.activity())
    );
  }

  private void pushEvent(String eventName, Map<String, Object> eventData) {
    this.cleverTap.event.push(eventName, eventData);
  }

  private void pushUser(Map<String, Object> profile) {
    this.cleverTap.profile.push(profile);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "pushEvent": {
        Map<String, Object>_eventData = call.argument("eventData");
        String _eventName = call.argument("eventName");
        this.pushEvent(_eventName, _eventData);
        break;
      }
      case "pushUser": {
        Map<String, Object> profile = call.argument("profile");
        this.pushUser(profile);
        break;
      }
      default: {
        result.notImplemented();
      }
    }
  }
}
