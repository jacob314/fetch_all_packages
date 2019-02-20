package analytics.sensorsdata.com.yzkflutterpluginexample;


import android.content.Context;
import android.content.pm.ApplicationInfo;

import com.sensorsdata.analytics.android.sdk.SensorsDataAPI;

import java.util.ArrayList;
import java.util.List;

import io.flutter.app.FlutterApplication;

/**
 * Created by yzk on 2018/12/22
 */

public class App extends FlutterApplication {


    // debug 模式的数据接收地址 （测试，测试项目）
    final static String SA_SERVER_URL_DEBUG = " ";

    // release 模式的数据接收地址（发版，正式项目）
    final static String SA_SERVER_URL_RELEASE = " ";

    // SDK Debug 模式选项
    //   SensorsDataAPI.DebugMode.DEBUG_OFF - 关闭 Debug 模式
    //   SensorsDataAPI.DebugMode.DEBUG_ONLY - 打开 Debug 模式，校验数据，但不进行数据导入
    //   SensorsDataAPI.DebugMode.DEBUG_AND_TRACK - 打开 Debug 模式，校验数据，并将数据导入到 Sensors Analytics 中
    // TODO 注意！请不要在正式发布的 App 中使用 DEBUG_AND_TRACK /DEBUG_ONLY 模式！ 请使用 DEBUG_OFF 模式！！！

    // debug 时，初始化 SDK 使用测试项目数据接收 URL 、使用 DEBUG_AND_TRACK 模式；release 时，初始化 SDK 使用正式项目数据接收 URL 、使用 DEBUG_OFF 模式。
    private boolean isDebugMode;

    @Override
    public void onCreate() {
        super.onCreate();

        initSensorsDataSDK(this);
    }

    /**
     * 初始化 SDK 、设置公共属性、开启自动采集
     */
    private void initSensorsDataSDK(Context context) {
        try {
            // 初始化 SDK
            SensorsDataAPI.sharedInstance(
                    context,                                                                                  // 传入 Context
                    (isDebugMode = isDebugMode(context)) ? SA_SERVER_URL_DEBUG : SA_SERVER_URL_RELEASE,       // 数据接收的 URL
                    isDebugMode ? SensorsDataAPI.DebugMode.DEBUG_AND_TRACK : SensorsDataAPI.DebugMode.DEBUG_OFF); // Debug 模式选项

            // 打开自动采集
            List<SensorsDataAPI.AutoTrackEventType> eventTypeList = new ArrayList<>();
            // $AppStart
            eventTypeList.add(SensorsDataAPI.AutoTrackEventType.APP_START);
            // $AppEnd
            eventTypeList.add(SensorsDataAPI.AutoTrackEventType.APP_END);
            SensorsDataAPI.sharedInstance().enableAutoTrack(eventTypeList);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * @param context App 的 Context
     * @return debug return true,release return false
     * 用于判断是 debug 包，还是 relase 包
     */
    public static boolean isDebugMode(Context context) {
        try {
            ApplicationInfo info = context.getApplicationInfo();
            return (info.flags & ApplicationInfo.FLAG_DEBUGGABLE) != 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
