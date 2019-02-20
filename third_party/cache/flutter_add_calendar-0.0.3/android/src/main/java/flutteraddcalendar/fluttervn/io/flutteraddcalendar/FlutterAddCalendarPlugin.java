package flutteraddcalendar.fluttervn.io.flutteraddcalendar;

import android.app.Activity;
import android.content.Intent;
import android.provider.CalendarContract;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterAddCalendarPlugin
 */
public class FlutterAddCalendarPlugin implements MethodCallHandler {
    private Activity activity;
    static MethodChannel channel;

    FlutterAddCalendarPlugin(Activity activity) {
        this.activity = activity;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        channel = new MethodChannel(registrar.messenger(), "flutter_add_calendar/native");
        channel.setMethodCallHandler(new FlutterAddCalendarPlugin(registrar.activity()));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("setEventToCalendar")) {
            addEventToCalendar(String.valueOf(call.argument("title")), String.valueOf(call.argument("desc")), Long.valueOf(String.valueOf(call.argument("startDate"))), Long.valueOf(String.valueOf(call.argument("endDate"))));
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else {
            result.notImplemented();
        }
    }

    private void addEventToCalendar(String title, String desc, Long startDate, Long endDate) {
        Intent intent = new Intent(Intent.ACTION_INSERT)
                .setData(CalendarContract.Events.CONTENT_URI)
                .putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startDate)
                .putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endDate)
                .putExtra(CalendarContract.Events.TITLE, title)
                .putExtra(CalendarContract.Events.DESCRIPTION, desc);
        //.putExtra(CalendarContract.Events.EVENT_LOCATION, "The gym")
        //.putExtra(CalendarContract.Events.AVAILABILITY, CalendarContract.Events.AVAILABILITY_BUSY)
        //.putExtra(Intent.EXTRA_EMAIL, "rowan@example.com,trevor@example.com");
        if(intent.resolveActivity(activity.getPackageManager()) != null){
            activity.startActivity(intent);
        } else {
            Map<String, Object> data = new HashMap<>();
            data.put("code", "2");
            data.put("message", "Fail to resolve calendar information");
            channel.invokeMethod("receiveStatus", data);
        }

    }
}
