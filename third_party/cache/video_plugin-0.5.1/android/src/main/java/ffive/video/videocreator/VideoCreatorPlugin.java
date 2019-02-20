package ffive.video.videocreator;


import android.content.Intent;
import android.net.Uri;
import android.os.Environment;
import android.os.StrictMode;
import android.util.Log;

import com.getkeepsafe.relinker.ReLinker;

import java.io.File;
import java.io.IOException;

import ffive.video.videocreator.videogen.VideoGenerator;
import ffive.video.videocreator.videogen.VideoParams;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** VideoCreatorPlugin */
public class VideoCreatorPlugin implements MethodCallHandler {

  private static final String CHANNEL_GAME = "video_creator";

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_GAME);
    VideoCreatorPlugin instance = new VideoCreatorPlugin(registrar);
    channel.setMethodCallHandler(instance);

    try {
     // ReLinker.recursively().loadLibrary(registrar.context(), "swscale-5");
      ReLinker.recursively().loadLibrary(registrar.context(), "videocreator");
    } catch(Exception e){
      e.printStackTrace();
       System.loadLibrary("videocreator");
    }


  }

  private final Registrar mRegistrar;

  private VideoCreatorPlugin(Registrar registrar) {
    this.mRegistrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {

    switch (call.method) {

      case "savevideo":
        result.success("good");
        break;
      case "makeVideo":
        VideoParams vParams;
        vParams = new VideoParams();

        //  String dir =  Environment.getExternalStorageDirectory().getPath()+"/pixeld_videos/";
        String filename = "video_" + System.currentTimeMillis() + ".mp4";

        String videoPath = "";


        StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
        StrictMode.setVmPolicy(builder.build());

        File file = new File(Environment.getExternalStorageDirectory(), filename);
        try {
          boolean res = file.createNewFile();

          videoPath = file.getPath();
        } catch (IOException e) {
          e.printStackTrace();
        }
        Log.e("file", "" + file.getPath());
        Log.e("vpath", "" + videoPath);
        vParams.videoPath = videoPath;
        vParams.history = call.argument("history");
        vParams.palette = call.argument("palette");
        vParams.original = call.argument("original");
        vParams.originalWidth = call.argument("width");
        vParams.originalHeight = call.argument("height");
        vParams.secondsPaint = call.argument("secondsPaint");
        vParams.secondsShow = call.argument("secondsShow");

        VideoGenerator.generate(vParams);


        result.success(videoPath);

        break;

      case "shareInsta":
        String vpath = call.argument("path");

        String type = "video/*";
        createInstagramIntent(type, vpath);

      default:
        break;
    }
  }

  private void createInstagramIntent(String type, String mediaPath) {

    // Create the new Intent using the 'Send' action.
    Intent share = new Intent(Intent.ACTION_SEND);

    // Set the MIME type
    share.setType(type);

    // Create the URI from the media
    File media = new File(mediaPath);
    Uri uri = Uri.fromFile(media);

    // Add the URI to the Intent.
    share.putExtra(Intent.EXTRA_STREAM, uri);

    // Broadcast the Intent.
  mRegistrar.context().startActivity(Intent.createChooser(share, "Share to"));

  }
}
