package com.mediaMetadata.mediametadataplugin;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaMetadataRetriever;
import android.os.Build;
import android.provider.Settings;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import mkaflowski.mediastylepalette.MediaNotificationProcessor;

/** MediaMetadataPlugin */
public class MediaMetadataPlugin implements MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {

    private Activity activity;
    private static Registrar registrar;


    /** Plugin registration. */
    public static void registerWith(Registrar registrar) {
//    final MethodChannel channel = new MethodChannel(registrar.messenger(), "media_metadata_plugin");
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "media_metadata_plugin");

        MediaMetadataPlugin mediaMetadataPlugin = new MediaMetadataPlugin(registrar.activity(), channel);
        channel.setMethodCallHandler(mediaMetadataPlugin);
        mediaMetadataPlugin.registrar = registrar;
    }


    public MediaMetadataPlugin(Activity activity, MethodChannel channel) {
        this.activity = activity;
    }


    @Override
    public void onMethodCall(MethodCall call, Result result) {
        GsonBuilder builder = new GsonBuilder();
        Gson gson = builder.serializeNulls().create();
        switch (call.method) {
            case "getMediaMetadata": {
                String filePath = call.argument("filePath");
                result.success(gson.toJson(getMediaMetadata(filePath)));
                break;
            }
            case "getImageColors": {
                String filePath = call.argument("filePath");
                result.success(gson.toJson(getImageColors(filePath)) );
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }


    @TargetApi(Build.VERSION_CODES.M)
    private AudioMetaData getMediaMetadata(String filePath) {
        AudioMetaData audioData = new AudioMetaData();
        try {
//            if (!Settings.System.canWrite(this.activity.getApplicationContext())) {
//                this.activity.requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE}, 2909);
//            }
            MediaMetadataRetriever mediaMetadataRetriever = (MediaMetadataRetriever) new MediaMetadataRetriever();
            mediaMetadataRetriever.setDataSource(filePath);
            audioData.ArtistName = mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ARTIST);
            audioData.AuthorName = mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_AUTHOR);
            audioData.Album = mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ALBUM);
            audioData.MimeTYPE = mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_MIMETYPE);
            audioData.TrackDuration = Long.parseLong(mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION));
            return audioData;
        } catch (Exception e) {
            return audioData;
        }
    }


    private ImageColor getImageColors(String imagePath){
        Bitmap myBitmap = BitmapFactory.decodeFile(imagePath);
        ImageColor imageColor = new ImageColor();
        if(myBitmap != null) {
            MediaNotificationProcessor processor = new MediaNotificationProcessor(this.activity, myBitmap); // can use drawable
            imageColor.setBackgroundColor(processor.getBackgroundColor());
            imageColor.setPrimaryColor(processor.getPrimaryTextColor());
            imageColor.setSecondaryColor(processor.getSecondaryTextColor());
            imageColor.setLight(processor.isLight());
        }
        return imageColor;
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        boolean granted = false;
        switch (requestCode) {
            case 1: {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    granted = true;
                }
                return true;
            }
        }
        return false;
    }
}
