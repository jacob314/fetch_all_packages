package com.sheikhsoft.fbshareplugin;


import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;

import android.os.Environment;
import android.support.v4.content.FileProvider;
import android.util.Log;
import android.widget.Toast;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.messenger.MessengerUtils;
import com.facebook.messenger.ShareToMessengerParams;
import com.facebook.share.ShareApi;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.model.SharePhoto;
import com.facebook.share.model.SharePhotoContent;
import com.facebook.share.model.ShareVideo;
import com.facebook.share.model.ShareVideoContent;
import com.facebook.share.widget.ShareDialog;
import com.twitter.sdk.android.core.DefaultLogger;
import com.twitter.sdk.android.core.Twitter;
import com.twitter.sdk.android.core.TwitterAuthConfig;
import com.twitter.sdk.android.core.TwitterConfig;
import com.twitter.sdk.android.tweetcomposer.TweetComposer;


import java.io.File;
import java.net.MalformedURLException;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static android.support.v4.content.FileProvider.getUriForFile;
import static android.support.v7.widget.StaggeredGridLayoutManager.TAG;

/** FbSharePlugin */
public class FbSharePlugin implements MethodCallHandler {

  CallbackManager callbackManager;
  ShareDialog shareDialog;

  private static final String CHANNEL = "com.sheikhsoft.share_plugin";

  private static final int SOURCE_CAMERA = 0;
  private static final int SOURCE_GALLERY = 1;


  private final ImagePickerDelegate delegate;

  private static final int REQUEST_CODE_SHARE_TO_MESSENGER = 1;
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {

    TwitterConfig config = new TwitterConfig.Builder(registrar.activity())
            .logger(new DefaultLogger(Log.DEBUG))
            .twitterAuthConfig(new TwitterAuthConfig("OEXktbm2rKEuq6hkalqS9gwyX", "Xs5UgtvZMbFyNkyCNAMfpdeXu6RzBKhnG5917GIckPK28bXCcc"))
            .debug(true)
            .build();
    Twitter.initialize(config);
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);

    final File externalFilesDirectory =
            registrar.activity().getExternalFilesDir(Environment.DIRECTORY_PICTURES);
    final ExifDataCopier exifDataCopier = new ExifDataCopier();
    final ImageResizer imageResizer = new ImageResizer(externalFilesDirectory, exifDataCopier);

    final ImagePickerDelegate delegate =
            new ImagePickerDelegate(registrar.activity(), externalFilesDirectory, imageResizer);
    registrar.addActivityResultListener(delegate);
    registrar.addRequestPermissionsResultListener(delegate);

    final FbSharePlugin instance = new FbSharePlugin(registrar, delegate);


    channel.setMethodCallHandler(instance);


  }
  private final Registrar mRegistrar;

  public FbSharePlugin(Registrar registrar,ImagePickerDelegate delegate) {
    this.mRegistrar = registrar;
    this.delegate = delegate;


  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    callbackManager = CallbackManager.Factory.create();
    shareDialog = new ShareDialog(mRegistrar.activity());

    if (mRegistrar.activity() == null) {
      result.error("no_activity", "image_picker plugin requires a foreground activity.", null);
      return;
    }

    if (call.method.equals("shareContent")) {
      String contentUrl = (String) call.argument("videoUrl");

      Toast.makeText(mRegistrar.activity(), "Ready To Share", Toast.LENGTH_SHORT).show();

      fbShareContent(contentUrl);

    }
    else if (call.method.equals("shareVideo")) {
      String videoPath = (String) call.argument("videoPath");

      FbVideoShare(videoPath);
    }
    else if (call.method.equals("shareImageFb")) {
      String imagePath = (String) call.argument("imagePath");

      shareImageFb(imagePath);
    }
    else if (call.method.equals("shareImageMessenger")) {
      String imagePath = (String) call.argument("imagePath");

      shareImageMessenger(imagePath);
    }
    else if (call.method.equals("shareVideoWhatsApp")) {
      String videoPath = (String) call.argument("videoPath");

      shareVideoWhatsApp(videoPath);
    }
    else if (call.method.equals("shareVideoMessenger")) {
      String videoPath = (String) call.argument("videoPath");

      shareVideoMessenger(videoPath);
    }
    else if (call.method.equals("shareVideoTwitter")) {
        String videoPath = (String) call.argument("videoPath");

        shareVideoTwitter(videoPath);
    }
    else if (call.method.equals("getPlatformVersion")) {
      result.success("Android flutter working" );
    } else if (call.method.equals("pickImage")) {
      int imageSource = call.argument("source");
      switch (imageSource) {
        case SOURCE_GALLERY:
          delegate.chooseImageFromGallery(call, result);
          break;
        case SOURCE_CAMERA:
          delegate.takeImageWithCamera(call, result);
          break;
        default:
          throw new IllegalArgumentException("Invalid image source: " + imageSource);
      }
    } else if (call.method.equals("pickVideo")) {
      int imageSource = call.argument("source");
      switch (imageSource) {
        case SOURCE_GALLERY:
          delegate.chooseVideoFromGallery(call, result);
          break;
        case SOURCE_CAMERA:
          delegate.takeVideoWithCamera(call, result);
          break;
        default:
          throw new IllegalArgumentException("Invalid video source: " + imageSource);
      }
    } else {
      throw new IllegalArgumentException("Unknown method " + call.method);
    }
  }

  private void shareImageWhatsApp(String imagePath) {

  }

  private void shareImageFb(String imagePath) {
    Toast.makeText(mRegistrar.activity(), "Ready To Share", Toast.LENGTH_SHORT).show();
    Bitmap bitmap = BitmapFactory.decodeFile(imagePath);

    SharePhoto photo = new SharePhoto.Builder()
            .setBitmap(bitmap)
            .build();
    SharePhotoContent content = new SharePhotoContent.Builder()
            .addPhoto(photo)
            .build();

    if (ShareDialog.canShow(ShareVideoContent.class)){
      shareDialog.show(content);
    }
  }

  private void shareVideoTwitter(String videoPath) {
        File Fileuri = new File(videoPath);
        Log.d("wavideo",Fileuri.toString());

        String authorities = mRegistrar.activity().getPackageName()+".flutter.image_provider";
        Uri videoUri = FileProvider.getUriForFile(mRegistrar.activity(),authorities,Fileuri);
        Log.d("videoUrl",videoUri.toString());

        TweetComposer.Builder builder = new TweetComposer.Builder(mRegistrar.activity())
                .text("Share Video From ShareTube")
                .image(videoUri);
        builder.show();
    }

    private void FbVideoShare(String videoPath) {

    Toast.makeText(mRegistrar.activity(), "Ready To Share", Toast.LENGTH_SHORT).show();
    Uri selectedVideo = Uri.fromFile(new File(videoPath));



    ShareVideo video = new ShareVideo.Builder()
            .setLocalUrl(selectedVideo)
            .build();


    ShareVideoContent videoContent = new ShareVideoContent.Builder()
            .setContentTitle("This Is Useful video ")
            .setContentDescription("Funny Video Form Youtube")
            .setVideo(video)
            .build();

    if (ShareDialog.canShow(ShareVideoContent.class)){
      shareDialog.show(videoContent);
    }
  }


  private void fbShareContent(String contentUrl) {
    shareDialog.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {
      @Override
      public void onSuccess(Sharer.Result result) {
        Toast.makeText(mRegistrar.context(), "Share Successful", Toast.LENGTH_SHORT).show();
      }

      @Override
      public void onCancel() {
        Toast.makeText(mRegistrar.context(), "Share Cancel", Toast.LENGTH_SHORT).show();
      }

      @Override
      public void onError(FacebookException error) {
        Toast.makeText(mRegistrar.context(), error.getMessage(), Toast.LENGTH_SHORT).show();

      }
    });

    ShareLinkContent linkContent = new ShareLinkContent.Builder()
            .setQuote("SHEIKH SOFT")
            .setContentUrl(Uri.parse(contentUrl))
            .build();
    if (ShareDialog.canShow(ShareLinkContent.class)){
      shareDialog.show(linkContent);
    }
  }

  private void shareVideoWhatsApp(String videoPath) {
    Toast.makeText(mRegistrar.activity(), "Ready To Share", Toast.LENGTH_SHORT).show();


   File Fileuri = new File(videoPath);
    Log.d("wavideo",Fileuri.toString());

    String authorities = mRegistrar.activity().getPackageName()+".flutter.image_provider";
    Uri videoUri = FileProvider.getUriForFile(mRegistrar.activity(),authorities,Fileuri);
    Log.d("videoUrl",videoUri.toString());

    Intent videoshare = new Intent(Intent.ACTION_SEND);
    videoshare.setType("*/*");
    videoshare.setPackage("com.whatsapp");
    videoshare.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
    videoshare.putExtra(Intent.EXTRA_STREAM,videoUri);

    mRegistrar.activity().startActivity(videoshare);

  }

  private void shareVideoMessenger(String videoPath) {
    Toast.makeText(mRegistrar.activity(), "Ready To Share", Toast.LENGTH_SHORT).show();


    File Fileuri = new File(videoPath);
    Log.d("wavideo",Fileuri.toString());

    String authrited = mRegistrar.activity().getPackageName()+".flutter.image_provider";
    Uri videoUri = FileProvider.getUriForFile(mRegistrar.activity(),authrited,Fileuri);
    Log.d("videoUrl",videoUri.toString());

    ShareToMessengerParams shareToMessengerParams =
            ShareToMessengerParams.newBuilder(videoUri, "video/mp4")
                    .setMetaData("{ \"image\" : \"tree\" }")
                    .build();
    MessengerUtils.shareToMessenger(
            mRegistrar.activity(),
            REQUEST_CODE_SHARE_TO_MESSENGER,
            shareToMessengerParams);

  }

  private void shareImageMessenger(String imagePath) {
    Toast.makeText(mRegistrar.activity(), "Ready To Share", Toast.LENGTH_SHORT).show();


    File Fileuri = new File(imagePath);
    Log.d("wavideo",Fileuri.toString());

    String authrited = mRegistrar.activity().getPackageName()+".flutter.image_provider";
    Uri videoUri = FileProvider.getUriForFile(mRegistrar.activity(),authrited,Fileuri);
    Log.d("videoUrl",videoUri.toString());

    ShareToMessengerParams shareToMessengerParams =
            ShareToMessengerParams.newBuilder(videoUri, "image/*")
                    .setMetaData("{ \"image\" : \"tree\" }")
                    .build();
    MessengerUtils.shareToMessenger(
            mRegistrar.activity(),
            REQUEST_CODE_SHARE_TO_MESSENGER,
            shareToMessengerParams);

  }
}
