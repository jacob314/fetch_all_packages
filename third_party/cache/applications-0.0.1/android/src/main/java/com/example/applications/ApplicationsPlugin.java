package com.example.applications;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.text.TextUtils;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.util.ArrayList;
import java.util.List;

/**
 * ApplicationsPlugin
 */
public class ApplicationsPlugin implements MethodCallHandler {
    /**
     * Plugin registration.
     */

    private Context context;

    public static void registerWith(Registrar registrar) {
        final String channelName = "applicationsMethodChannel";
        final MethodChannel channel = new MethodChannel(registrar.messenger(), channelName);
        channel.setMethodCallHandler(new ApplicationsPlugin(registrar));
    }

    public ApplicationsPlugin(Registrar registrar) {
        context = registrar.activeContext();
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        String listString = getInstalledApps();

        if (call.method.equals("getApplications")) {
            result.success(listString);
        } else {
            result.notImplemented();
        }
    }

    private String getInstalledApps() {
        ArrayList<String> appList = new ArrayList<>();
        List<PackageInfo> packList = context.getPackageManager().getInstalledPackages(0);
        for (int i = 0; i < packList.size(); i++) {
            PackageInfo packInfo = packList.get(i);
            if ((packInfo.applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM) == 0) {
                PackageManager pckgManager = context.getPackageManager();
                String appName = packInfo.applicationInfo.loadLabel(pckgManager).toString();
                appList.add(appName);
            }
        }

        String appListString = TextUtils.join(",\n", appList);
        return appListString;
    }
}
