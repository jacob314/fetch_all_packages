package com.dibi.phonecalllog;

import android.Manifest;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.os.Build;
import android.provider.CallLog;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.util.ArrayList;
import java.util.HashMap;


/** PhonecallLogPlugin */
@TargetApi(Build.VERSION_CODES.N)
public class PhonecallLogPlugin implements MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {
//  private final MethodChannel channel;
  private Result pendingResult;
  public Registrar registrar;

  PhonecallLogPlugin (Registrar registrar) {
    this.registrar = registrar;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "phonecall_log");
    PhonecallLogPlugin phoneCallLogPlugin = new PhonecallLogPlugin(registrar);

    channel.setMethodCallHandler(phoneCallLogPlugin);

    registrar.addRequestPermissionsResultListener(phoneCallLogPlugin);
  }

  @TargetApi(Build.VERSION_CODES.M)
  public void requestPermission () {
    Log.i("PhoneLogPlugin", "Requesting permission : " + Manifest.permission.READ_CALL_LOG);
    String[] perm = {Manifest.permission.READ_CALL_LOG};
    registrar.activity().requestPermissions(perm, 0);
  }

    @Override
    public boolean onRequestPermissionsResult(int requestCode,
                                              String[] strings,
                                              int[] grantResults) {
        boolean res = false;
        if (requestCode == 0 && grantResults.length > 0) {
            res = grantResults[0] == PackageManager.PERMISSION_GRANTED;
            pendingResult.success(res);
            pendingResult = null;
        }
        return res;
    }

  @TargetApi(Build.VERSION_CODES.M)
  private boolean checkPermission() {
    Log.i("PhoneLogPlugin", "Checking permission : " + Manifest.permission.READ_CALL_LOG);
    return PackageManager.PERMISSION_GRANTED
            == registrar.activity().checkSelfPermission(Manifest.permission.READ_CALL_LOG);
  }

  @TargetApi(Build.VERSION_CODES.M)
  public void getPhoneLogs (String startDate, String duration) {
    if (registrar.activity().checkSelfPermission(Manifest.permission.READ_CALL_LOG) == PackageManager.PERMISSION_GRANTED) {
      String selectionCondition = null;
      if (startDate != null) {
        selectionCondition = CallLog.Calls.DATE + "> " + startDate;
      }
      if (duration != null) {
        String durationSelection = CallLog.Calls.DURATION + "> " + duration;
        if (selectionCondition != null) {
          selectionCondition = selectionCondition + " AND " + durationSelection;
        } else {
          selectionCondition = durationSelection;
        }
      }
      @SuppressLint("MissingPermission") Cursor cursor = registrar.context().getContentResolver().query(
              CallLog.Calls.CONTENT_URI, PROJECTION,
              selectionCondition,
              null, CallLog.Calls.DATE + " DESC");
      try {
        ArrayList<HashMap<String, Object>> records = getCallRecordMaps(cursor);
        pendingResult.success(records);
        pendingResult = null;
      } catch (Exception e) {
        Log.e("PhoneLog", "Error on fetching call record" + e);
//        pendingResult.error("PhoneLog", e.getMessage(), null);
        pendingResult = null;
      } finally {
        if (cursor != null) {
          cursor.close();
        }
      }
    } else {
      Log.i("PhoneLog", "Permission is not granted", null);
      pendingResult.error("PhoneLog", "Permission is not granted", null);
      pendingResult = null;
    }
  }

  private static final String[] PROJECTION =
          {
                  CallLog.Calls.NUMBER,
                  CallLog.Calls.CACHED_NAME,
                  CallLog.Calls.TYPE,
                  CallLog.Calls.DATE,
                  CallLog.Calls.DURATION,
          };
  /**
   * Builds the list of call record maps from the cursor
   *
   * @param cursor
   * @return the list of maps
   */
  private ArrayList<HashMap<String, Object>> getCallRecordMaps(Cursor cursor) {
    ArrayList<HashMap<String, Object>> records = new ArrayList<>();
    while (cursor != null && cursor.moveToNext()) {
      CallRecord record = new CallRecord();
      record.number = cursor.getString(0);
      record.name = cursor.getString(1);
      record.callType = getCallType(cursor.getInt(2));
      record.date = cursor.getString(3);
      record.duration = cursor.getLong(4);

      records.add(record.toMap());
    }
    return records;
  }

  private String getCallType(int anInt) {
    switch (anInt) {
      case CallLog.Calls.INCOMING_TYPE:
        return "INCOMING_TYPE";
      case CallLog.Calls.OUTGOING_TYPE:
        return "OUTGOING_TYPE";
      case CallLog.Calls.MISSED_TYPE:
        return "MISSED_TYPE";
      default:
        break;
    }
    return null;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (pendingResult != null) {
//      pendingResult.error("multiple_requests", "Cancelled by a second request.", null);
      pendingResult = null;
    }
    pendingResult = result;

    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "requestPermission":
        requestPermission();
        break;
      case "checkPermission":
        pendingResult.success(checkPermission());
        pendingResult = null;
        break;
      case "getPhoneLogs":
        String startDate = call.argument("startDate");
        String duration = call.argument("duration");
        getPhoneLogs(startDate, duration);
        break;
      default:
        result.notImplemented();
    }
  }
}
