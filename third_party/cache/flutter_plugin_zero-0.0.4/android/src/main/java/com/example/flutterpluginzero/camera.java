package com.example.flutterpluginzero;

import android.app.Activity;
import android.content.Intent;

public class camera {

    private Activity activity;

    public camera(Activity activity) {
        this.activity = activity;
    }

    public void openCamera(){
        Intent intent = new Intent("android.media.action.IMAGE_CAPTURE");
        activity.startActivityForResult(intent, 0);
    }
}
