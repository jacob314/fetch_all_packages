package com.github.yyl.update.flutterupdate.impl;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.support.v4.content.FileProvider;

import java.io.File;
import java.io.FileNotFoundException;

/**
 * Created by yunlong.yang on 2018/12/26.
 */

public class AppInstaller {
    String filePath;
    Context context;

    public AppInstaller(String filePath, Context context) {
        this.filePath = filePath;
        this.context = context;
    }

    public void install() throws Exception {
        Intent install = new Intent();
        if (!(new File(filePath).exists())) {
            throw new FileNotFoundException(filePath + " (not exist)");
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            Uri apkUri = FileProvider.getUriForFile(context, getAuth(context), new File(filePath));
            install.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            install.setDataAndType(apkUri, "application/vnd.android.package-archive");
        } else {
            install.setAction(Intent.ACTION_VIEW);
            install.setDataAndType(Uri.fromFile(new File(filePath)), "application/vnd.android.package-archive");
        }
        if (!(context instanceof Activity)) {
            install.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        }
        context.startActivity(install);
    }

    private static String getAuth(Context context) throws PackageManager.NameNotFoundException {
        ApplicationInfo appInfo = context.getPackageManager().getApplicationInfo(context.getPackageName(),
                PackageManager.GET_META_DATA);
        String authorities = appInfo.metaData.getString("FILE_PROVIDER_AUTHORITIES");
        return authorities;
    }
}
