package io.fluttervn.flutteryoutubeextractor;

import android.content.Context;
import android.util.SparseArray;
import android.text.TextUtils;

import at.huber.youtubeExtractor.VideoMeta;
import at.huber.youtubeExtractor.YouTubeExtractor;
import at.huber.youtubeExtractor.YtFile;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterYoutubeExtractorPlugin
 */
public class FlutterYoutubeExtractorPlugin implements MethodCallHandler {
    private Context context;
    private final MethodChannel nativeChannel;

    public FlutterYoutubeExtractorPlugin(Context context, MethodChannel nativeChannel) {
        this.context = context;
        this.nativeChannel = nativeChannel;
        this.nativeChannel.setMethodCallHandler(this);
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter.youtube.extractor/native");
        channel.setMethodCallHandler(new FlutterYoutubeExtractorPlugin(registrar.activeContext(), channel));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getYoutubeMediaLink")) {
            String youtubeLink = (String) call.arguments;
            new YouTubeExtractor(this.context) {
                @Override
                public void onExtractionComplete(SparseArray<YtFile> ytFiles, VideoMeta vMeta) {
                    if (ytFiles != null) {
                        String mediaLink = "";
                        String link720 = "", link480 = "", link360 = "";

                        if (ytFiles.get(22) != null || ytFiles.get(18) != null || ytFiles.get(36) != null) {
                            mediaLink = ytFiles.get(22) != null ? ytFiles.get(22).getUrl() : (ytFiles.get(18) != null) ? ytFiles.get(18).getUrl() : (ytFiles.get(36) != null) ? ytFiles.get(36).getUrl() : "";

                        } else {
                            YtFile ytFile;
                            for (int i = 0; i < ytFiles.size(); i++) {
                                if (!TextUtils.isEmpty(link720) && !TextUtils.isEmpty(link480) && !TextUtils.isEmpty(link360))
                                    break;

                                ytFile = ytFiles.get(i);
                                if(ytFile != null && ytFile.getFormat()!= null) {
                                    if (TextUtils.isEmpty(link720) && ytFile.getFormat().getHeight() == 720 && ytFile.getFormat().getAudioBitrate() != -1) {
                                        link720 = ytFile.getUrl();

                                    } else if (TextUtils.isEmpty(link480) && ytFile.getFormat().getHeight() == 480 && ytFile.getFormat().getAudioBitrate() != -1) {
                                        link480 = ytFile.getUrl();

                                    } else if (TextUtils.isEmpty(link360) && ytFile.getFormat().getHeight() == 360 && ytFile.getFormat().getAudioBitrate() != -1) {
                                        link360 = ytFile.getUrl();

                                    } else if (ytFile.getFormat().getAudioBitrate() != -1)
                                        mediaLink = ytFile.getUrl();
                                }
                            }

                            mediaLink = !TextUtils.isEmpty(link720) ? link720 : !TextUtils.isEmpty(link480) ? link480 : !TextUtils.isEmpty(link360)? link360 : mediaLink;
                        }
                        nativeChannel.invokeMethod("receiveYoutubeMediaLink", mediaLink);
                    }
                }
            }.extract(youtubeLink, true, true);

        } else {
            result.notImplemented();
        }
    }
}
