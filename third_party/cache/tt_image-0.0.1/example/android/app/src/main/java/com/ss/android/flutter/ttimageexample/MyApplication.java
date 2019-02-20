package com.ss.android.flutter.ttimageexample;

import com.facebook.drawee.backends.pipeline.Fresco;

import io.flutter.app.FlutterApplication;

/**
 * Created by Xie Ran on 2018/8/7.
 * Email:xieran.sai@bytedance.com
 */
public class MyApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        Fresco.initialize(this);
    }
}
