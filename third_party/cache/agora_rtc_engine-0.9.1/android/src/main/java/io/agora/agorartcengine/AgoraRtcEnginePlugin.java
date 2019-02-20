package io.agora.agorartcengine;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;


import android.content.Context;
import android.graphics.Rect;
import android.view.SurfaceView;

import java.util.ArrayList;
import java.util.HashMap;

import io.agora.rtc.Constants;
import io.agora.rtc.RtcEngine;
import io.agora.rtc.IRtcEngineEventHandler;
//import io.agora.rtc.RtcEngine

import io.agora.rtc.video.VideoCanvas;
import io.agora.rtc.video.VideoEncoderConfiguration;
import io.flutter.plugin.common.StandardMessageCodec;

import static io.agora.rtc.video.VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_1;
import static io.agora.rtc.video.VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_10;
import static io.agora.rtc.video.VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_15;
import static io.agora.rtc.video.VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_24;
import static io.agora.rtc.video.VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_30;
import static io.agora.rtc.video.VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_7;
import static io.agora.rtc.video.VideoEncoderConfiguration.ORIENTATION_MODE.ORIENTATION_MODE_ADAPTIVE;
import static io.agora.rtc.video.VideoEncoderConfiguration.ORIENTATION_MODE.ORIENTATION_MODE_FIXED_LANDSCAPE;
import static io.agora.rtc.video.VideoEncoderConfiguration.ORIENTATION_MODE.ORIENTATION_MODE_FIXED_PORTRAIT;

/** AgoraRtcEnginePlugin */
public class AgoraRtcEnginePlugin implements MethodCallHandler {

  private final Registrar mRegistrar;
  private final MethodChannel mMethodChannel;
  private RtcEngine mRtcEngine;
  private HashMap<String, SurfaceView> mRendererViews;

  public void addView(SurfaceView view, int id) {
    mRendererViews.put("" + id, view);
  }

  public void removeView(int id) {
    mRendererViews.remove("" + id);
  }

  public SurfaceView getView(int id) {
    return mRendererViews.get("" + id);
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "agora_rtc_engine");

    AgoraRtcEnginePlugin plugin = new AgoraRtcEnginePlugin(registrar, channel);
    channel.setMethodCallHandler(plugin);

    AgoraRenderViewFactory fac = new AgoraRenderViewFactory(StandardMessageCodec.INSTANCE, plugin);
    registrar.platformViewRegistry().registerViewFactory("AgoraRendererView", fac);
  }

  private AgoraRtcEnginePlugin(Registrar registrar, MethodChannel channel) {
    this.mRegistrar = registrar;
    this.mMethodChannel = channel;
    this.mRendererViews = new HashMap<String, SurfaceView>();
  }

  private Context getActiveContext() {
    return (mRegistrar.activity() != null) ? mRegistrar.activity() : mRegistrar.context();
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    Context context = getActiveContext();

    switch (call.method) {
      // Core Methods
      case "create": {
        try {
          String appId = call.argument("appId");
          mRtcEngine = RtcEngine.create(context, appId, mRtcEventHandler);
        } catch (Exception e) {
          throw new RuntimeException("NEED TO check rtc sdk init fatal error\n");
        }
      }
      break;
      case "destroy": {
        RtcEngine.destroy();
      }
      break;
      case "setChannelProfile": {
        int profile = call.argument("profile");
        mRtcEngine.setChannelProfile(profile);
      }
      break;
      case "setClientRole": {
        int role = call.argument("role");
        mRtcEngine.setClientRole(role);
      }
      break;
      case "joinChannel": {
        String appId = call.argument("appId");
        String token = call.argument("token");
        String channel = call.argument("channelId");
        String info = call.argument("info");
        int uid = call.argument("uid");
        mRtcEngine.joinChannel(token, channel, info, uid);
      }
      break;
      case "leaveChannel": {
        mRtcEngine.leaveChannel();
      }
      break;
      case "renewToken": {
        String token = call.argument("token");
        mRtcEngine.renewToken(token);
      }
      break;
      case "enableWebSdkInteroperability": {
        boolean enabled = call.argument("enabled");
        mRtcEngine.enableWebSdkInteroperability(enabled);
      }
      break;
      case "getConnectionState": {
        int state = mRtcEngine.getConnectionState();
        result.success(state);
      }
      break;
      // Core Audio
      case "enableAudio": {
        mRtcEngine.enableAudio();
      }
      break;
      case "disableAudio": {
        mRtcEngine.disableAudio();
      }
      break;
      case "setAudioProfile": {
        int profile = call.argument("profile");
        int scenario = call.argument("scenario");
        mRtcEngine.setAudioProfile(profile, scenario);
      }
      break;
      case "adjustRecordingSignalVolume": {
        int volume = call.argument("volume");
        mRtcEngine.adjustRecordingSignalVolume(volume);
      }
      break;
      case "adjustPlaybackSignalVolume": {
        int volume = call.argument("volume");
        mRtcEngine.adjustPlaybackSignalVolume(volume);
      }
      break;
      case "enableAudioVolumeIndication": {
        int interval = call.argument("interval");
        int smooth = call.argument("smooth");
        mRtcEngine.enableAudioVolumeIndication(interval, smooth);
      }
      break;
      case "enableLocalAudio": {
        boolean enabled = call.argument("enabled");
        mRtcEngine.enableLocalAudio(enabled);
      }
      break;
      case "muteLocalAudioStream": {
        boolean muted = call.argument("muted");
        mRtcEngine.muteLocalAudioStream(muted);
      }
      break;
      case "muteRemoteAudioStream": {
        int uid = call.argument("uid");
        boolean muted = call.argument("muted");
        mRtcEngine.muteRemoteAudioStream(uid, muted);
      }
      break;
      case "muteAllRemoteAudioStreams": {
        boolean muted = call.argument("muted");
        mRtcEngine.muteAllRemoteAudioStreams(muted);
      }
      break;
      case "setDefaultMuteAllRemoteAudioStreams": {
        boolean muted = call.argument("muted");
        mRtcEngine.setDefaultMuteAllRemoteAudioStreams(muted);
      }
      break;
      // Core Video
      case "enableVideo": {
        mRtcEngine.enableVideo();
      }
      break;
      case "disableVideo": {
        mRtcEngine.disableVideo();
      }
      break;
      case "setVideoEncoderConfiguration": {
        int width = call.argument("width");
        int height = call.argument("height");
        int frameRate = call.argument("frameRate");
        int bitrate = call.argument("bitrate");
        int minBitrate = call.argument("minBitrate");
        int orientationMode = call.argument("orientationMode");

        VideoEncoderConfiguration configuration = new VideoEncoderConfiguration();
        configuration.dimensions = new VideoEncoderConfiguration.VideoDimensions(width, height);
        configuration.frameRate = frameRateFromValue(frameRate);
        configuration.bitrate = bitrate;
        configuration.minBitrate = minBitrate;
        configuration.orientationMode = orientationFromValue(orientationMode);
        mRtcEngine.setVideoEncoderConfiguration(configuration);
      }
      break;
      case "removeNativeView": {
        int viewId = call.argument("viewId");
        removeView(viewId);
      }
      break;
      case "setupLocalVideo": {
        int localViewId = call.argument("viewId");
        SurfaceView localView = getView(localViewId);
        int localRenderMode = call.argument("renderMode");
        VideoCanvas localCanvas = new VideoCanvas(localView);
        localCanvas.renderMode = localRenderMode;
        mRtcEngine.setupLocalVideo(localCanvas);
      }
      break;
      case "setupRemoteVideo": {
        int remoteViewId = call.argument("viewId");
        SurfaceView view = getView(remoteViewId);
        int remoteRenderMode = call.argument("renderMode");
        int remoteUid = call.argument("uid");
        mRtcEngine.setupRemoteVideo(new VideoCanvas(view, remoteRenderMode, remoteUid));
      }
      break;
      case "setLocalRenderMode": {
        int mode = call.argument("mode");
        mRtcEngine.setLocalRenderMode(mode);
      }
      break;
      case "setRemoteRenderMode": {
        int uid = call.argument("uid");
        int mode = call.argument("mode");
        mRtcEngine.setRemoteRenderMode(uid, mode);
      }
      break;
      case "startPreview": {
        mRtcEngine.startPreview();
      }
      break;
      case "stopPreview": {
        mRtcEngine.stopPreview();
      }
      break;
      case "enableLocalVideo": {
        boolean enabled = call.argument("enabled");
        mRtcEngine.enableLocalVideo(enabled);
      }
      break;
      case "muteLocalVideoStream": {
        boolean muted = call.argument("muted");
        mRtcEngine.muteLocalVideoStream(muted);
      }
      break;
      case "muteRemoteVideoStream": {
        int uid = call.argument("uid");
        boolean muted = call.argument("muted");
        mRtcEngine.muteRemoteVideoStream(uid, muted);
      }
      break;
      case "muteAllRemoteVideoStreams": {
        boolean muted = call.argument("muted");
        mRtcEngine.muteAllRemoteVideoStreams(muted);
      }
      break;
      case "setDefaultMuteAllRemoteVideoStreams": {
        boolean muted = call.argument("muted");
        mRtcEngine.setDefaultMuteAllRemoteVideoStreams(muted);
      }
      break;

      // Audio Routing Controller
      case "setDefaultAudioRouteToSpeaker": {
        boolean defaultToSpeaker = call.argument("defaultToSpeaker");
        mRtcEngine.setDefaultAudioRoutetoSpeakerphone(defaultToSpeaker);
      }
      break;
      case "setEnableSpeakerphone": {
        boolean enabled = call.argument("enabled");
        mRtcEngine.setEnableSpeakerphone(enabled);
      }
      break;
      case "isSpeakerphoneEnabled": {
        boolean enabled = mRtcEngine.isSpeakerphoneEnabled();
        result.success(enabled);
      }
      break;

      // Stream Fallback
      case "setLocalPublishFallbackOption": {
        int option = call.argument("option");
        mRtcEngine.setLocalPublishFallbackOption(option);
      }
      break;
      case "setRemoteSubscribeFallbackOption": {
        int option = call.argument("option");
        mRtcEngine.setRemoteSubscribeFallbackOption(option);
      }
      break;

      // Dual-stream Mode
      case "enableDualStreamMode": {
        boolean enabled = call.argument("enabled");
        mRtcEngine.enableDualStreamMode(enabled);
      }
      break;
      case "setRemoteVideoStreamType": {
        int uid = call.argument("uid");
        int streamType = call.argument("streamType");
        mRtcEngine.setRemoteVideoStreamType(uid, streamType);
      }
      break;
      case "setRemoteDefaultVideoStreamType": {
        int streamType = call.argument("streamType");
        mRtcEngine.setRemoteDefaultVideoStreamType(streamType);
      }
      break;

      // Camera Control
      case "switchCamera": {
        mRtcEngine.switchCamera();
      }
      break;

      // Miscellaneous Methods
      case "getSdkVersion": {
        String version = RtcEngine.getSdkVersion();
        result.success(version);
      }
      break;


      default:
        result.notImplemented();
    }
  }

  private VideoEncoderConfiguration.ORIENTATION_MODE orientationFromValue(int value) {
    switch (value) {
      case 0:
        return ORIENTATION_MODE_ADAPTIVE;
      case 1:
        return ORIENTATION_MODE_FIXED_LANDSCAPE;
      case 2:
        return ORIENTATION_MODE_FIXED_PORTRAIT;
      default:
        return ORIENTATION_MODE_ADAPTIVE;
    }
  }

  private VideoEncoderConfiguration.FRAME_RATE frameRateFromValue(int value) {
    switch (value) {
      case 1:
        return FRAME_RATE_FPS_1;
      case 7:
        return FRAME_RATE_FPS_7;
      case 10:
        return FRAME_RATE_FPS_10;
      case 15:
        return FRAME_RATE_FPS_15;
      case 24:
        return FRAME_RATE_FPS_24;
      case 30:
        return FRAME_RATE_FPS_30;
      default:
        return FRAME_RATE_FPS_15;
    }
  }

  final IRtcEngineEventHandler mRtcEventHandler = new IRtcEngineEventHandler() {
    @Override
    public void onWarning(int warn) {
      super.onWarning(warn);
      HashMap map = new HashMap<String, Object>();
      map.put("warn", warn);
      mMethodChannel.invokeMethod("onWarning", map);
    }

    @Override
    public void onError(int err) {
      super.onError(err);
      HashMap map = new HashMap<String, Object>();
      map.put("err", err);
      mMethodChannel.invokeMethod("onError", map);
    }

    @Override
    public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
      super.onJoinChannelSuccess(channel, uid, elapsed);
      HashMap map = new HashMap<String, Object>();
      map.put("channel", channel);
      map.put("uid", uid);
      map.put("elapsed", elapsed);
      mMethodChannel.invokeMethod("onJoinChannelSuccess", map);
    }

    @Override
    public void onRejoinChannelSuccess(String channel, int uid, int elapsed) {
      super.onRejoinChannelSuccess(channel, uid, elapsed);
      HashMap map = new HashMap<String, Object>();
      map.put("channel", channel);
      map.put("uid", uid);
      map.put("elapsed", elapsed);
      mMethodChannel.invokeMethod("onRejoinChannelSuccess", map);
    }

    @Override
    public void onLeaveChannel(RtcStats stats) {
      super.onLeaveChannel(stats);
      HashMap map = new HashMap<String, Object>();
      map.put("stats", mapFromStats(stats));
      mMethodChannel.invokeMethod("onLeaveChannel", map);
    }

    @Override
    public void onClientRoleChanged(int oldRole, int newRole) {
      super.onClientRoleChanged(oldRole, newRole);
      HashMap map = new HashMap<String, Object>();
      map.put("oldRole", oldRole);
      map.put("newRole", newRole);
      mMethodChannel.invokeMethod("onClientRoleChanged", map);
    }

    @Override
    public void onUserJoined(int uid, int elapsed) {
      super.onUserJoined(uid, elapsed);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("elapsed", elapsed);
      mMethodChannel.invokeMethod("onUserJoined", map);
    }

    @Override
    public void onUserOffline(int uid, int reason) {
      super.onUserOffline(uid, reason);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("reason", reason);
      mMethodChannel.invokeMethod("onUserOffline", map);
    }

    @Override
    public void onConnectionStateChanged(int state, int reason) {
      super.onConnectionStateChanged(state, reason);
      HashMap map = new HashMap<String, Object>();
      map.put("state", state);
      map.put("reason", reason);
      mMethodChannel.invokeMethod("onConnectionStateChanged", map);
    }

    @Override
    public void onConnectionLost() {
      super.onConnectionLost();
      mMethodChannel.invokeMethod("onConnectionLost", null);
    }

    @Override
    public void onApiCallExecuted(int error, String api, String result) {
      super.onApiCallExecuted(error, api, result);
      HashMap map = new HashMap<String, Object>();
      map.put("error", error);
      map.put("api", api);
      map.put("result", result);
      mMethodChannel.invokeMethod("onApiCallExecuted", map);
    }

    @Override
    public void onTokenPrivilegeWillExpire(String token) {
      super.onTokenPrivilegeWillExpire(token);
      HashMap map = new HashMap<String, Object>();
      map.put("token", token);
      mMethodChannel.invokeMethod("onTokenPrivilegeWillExpire", map);
    }

    @Override
    public void onRequestToken() {
      super.onRequestToken();
      mMethodChannel.invokeMethod("onRequestToken", null);
    }

    @Override
    public void onMicrophoneEnabled(boolean enabled) {
      super.onMicrophoneEnabled(enabled);
      HashMap map = new HashMap<String, Object>();
      map.put("enabled", enabled);
      mMethodChannel.invokeMethod("onMicrophoneEnabled", map);
    }

    @Override
    public void onAudioVolumeIndication(AudioVolumeInfo[] speakers, int totalVolume) {
      super.onAudioVolumeIndication(speakers, totalVolume);
      HashMap map = new HashMap<String, Object>();
      map.put("totalVolume", totalVolume);
      map.put("speakers", arrayFromSpeakers(speakers));
      mMethodChannel.invokeMethod("onAudioVolumeIndication", map);
    }

    @Override
    public void onActiveSpeaker(int uid) {
      super.onActiveSpeaker(uid);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      mMethodChannel.invokeMethod("onActiveSpeaker", map);
    }

    @Override
    public void onFirstLocalAudioFrame(int elapsed) {
      super.onFirstLocalAudioFrame(elapsed);
      HashMap map = new HashMap<String, Object>();
      map.put("elapsed", elapsed);
      mMethodChannel.invokeMethod("onFirstLocalAudioFrame", map);
    }

    @Override
    public void onFirstRemoteAudioFrame(int uid, int elapsed) {
      super.onFirstRemoteAudioFrame(uid, elapsed);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("elapsed", elapsed);
      mMethodChannel.invokeMethod("onFirstRemoteAudioFrame", map);
    }

    @Override
    public void onVideoStopped() {
      super.onVideoStopped();
      mMethodChannel.invokeMethod("onVideoStopped", null);
    }

    @Override
    public void onFirstLocalVideoFrame(int width, int height, int elapsed) {
      super.onFirstLocalVideoFrame(width, height, elapsed);
      HashMap map = new HashMap<String, Object>();
      map.put("width", width);
      map.put("height", height);
      map.put("elapsed", elapsed);
      mMethodChannel.invokeMethod("onFirstLocalVideoFrame", map);
    }

    @Override
    public void onFirstRemoteVideoDecoded(int uid, int width, int height, int elapsed) {
      super.onFirstRemoteVideoDecoded(uid, width, height, elapsed);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("width", width);
      map.put("height", height);
      map.put("elapsed", elapsed);
      mMethodChannel.invokeMethod("onFirstRemoteVideoDecoded", map);
    }

    @Override
    public void onFirstRemoteVideoFrame(int uid, int width, int height, int elapsed) {
      super.onFirstRemoteVideoFrame(uid, width, height, elapsed);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("width", width);
      map.put("height", height);
      map.put("elapsed", elapsed);
      mMethodChannel.invokeMethod("onFirstRemoteVideoFrame", map);
    }

    @Override
    public void onUserMuteAudio(int uid, boolean muted) {
      super.onUserMuteAudio(uid, muted);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("muted", muted);
      mMethodChannel.invokeMethod("onUserMuteAudio", map);
    }

    @Override
    public void onUserMuteVideo(int uid, boolean muted) {
      super.onUserMuteVideo(uid, muted);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("muted", muted);
      mMethodChannel.invokeMethod("onUserMuteVideo", map);
    }

    @Override
    public void onUserEnableVideo(int uid, boolean enabled) {
      super.onUserEnableVideo(uid, enabled);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("enabled", enabled);
      mMethodChannel.invokeMethod("onUserEnableVideo", map);
    }

    @Override
    public void onUserEnableLocalVideo(int uid, boolean enabled) {
      super.onUserEnableLocalVideo(uid, enabled);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("enabled", enabled);
      mMethodChannel.invokeMethod("onUserEnableLocalVideo", map);
    }

    @Override
    public void onVideoSizeChanged(int uid, int width, int height, int rotation) {
      super.onVideoSizeChanged(uid, width, height, rotation);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("enabled", width);
      map.put("enabled", height);
      map.put("enabled", rotation);
      mMethodChannel.invokeMethod("onVideoSizeChanged", map);
    }

    @Override
    public void onRemoteVideoStateChanged(int uid, int state) {
      super.onRemoteVideoStateChanged(uid, state);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("state", state);
      mMethodChannel.invokeMethod("onRemoteVideoStateChanged", map);
    }

    @Override
    public void onLocalPublishFallbackToAudioOnly(boolean isFallbackOrRecover) {
      super.onLocalPublishFallbackToAudioOnly(isFallbackOrRecover);
      HashMap map = new HashMap<String, Object>();
      map.put("isFallbackOrRecover", isFallbackOrRecover);
      mMethodChannel.invokeMethod("onLocalPublishFallbackToAudioOnly", map);
    }

    @Override
    public void onRemoteSubscribeFallbackToAudioOnly(int uid, boolean isFallbackOrRecover) {
      super.onRemoteSubscribeFallbackToAudioOnly(uid, isFallbackOrRecover);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("isFallbackOrRecover", isFallbackOrRecover);
      mMethodChannel.invokeMethod("onRemoteSubscribeFallbackToAudioOnly", map);
    }

    @Override
    public void onAudioRouteChanged(int routing) {
      super.onAudioRouteChanged(routing);
      HashMap map = new HashMap<String, Object>();
      map.put("routing", routing);
      mMethodChannel.invokeMethod("onAudioRouteChanged", map);
    }

    @Override
    public void onCameraReady() {
      super.onCameraReady();
      mMethodChannel.invokeMethod("onCameraReady", null);
    }

    @Override
    public void onCameraFocusAreaChanged(Rect rect) {
      super.onCameraFocusAreaChanged(rect);
      HashMap map = new HashMap<String, Object>();
      map.put("rect", mapFromRect(rect));
      mMethodChannel.invokeMethod("onCameraFocusAreaChanged", map);
    }

    @Override
    public void onCameraExposureAreaChanged(Rect rect) {
      super.onCameraExposureAreaChanged(rect);
      HashMap map = new HashMap<String, Object>();
      map.put("rect", mapFromRect(rect));
      mMethodChannel.invokeMethod("onCameraExposureAreaChanged", map);
    }

    @Override
    public void onRtcStats(RtcStats stats) {
      super.onRtcStats(stats);
      HashMap map = new HashMap<String, Object>();
      map.put("stats", mapFromStats(stats));
      mMethodChannel.invokeMethod("onRtcStats", map);
    }

    @Override
    public void onLastmileQuality(int quality) {
      super.onLastmileQuality(quality);
      HashMap map = new HashMap<String, Object>();
      map.put("quality", quality);
      mMethodChannel.invokeMethod("onLastmileQuality", map);
    }

    @Override
    public void onNetworkQuality(int uid, int txQuality, int rxQuality) {
      super.onNetworkQuality(uid, txQuality, rxQuality);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("txQuality", txQuality);
      map.put("rxQuality", rxQuality);
      mMethodChannel.invokeMethod("onNetworkQuality", map);
    }

    @Override
    public void onLocalVideoStats(LocalVideoStats stats) {
      super.onLocalVideoStats(stats);
      HashMap map = new HashMap<String, Object>();
      map.put("stats", mapFromLocalVideoStats(stats));
      mMethodChannel.invokeMethod("onLocalVideoStats", map);
    }

    @Override
    public void onRemoteVideoStats(RemoteVideoStats stats) {
      super.onRemoteVideoStats(stats);
      HashMap map = new HashMap<String, Object>();
      map.put("stats", mapFromRemoteVideoStats(stats));
      mMethodChannel.invokeMethod("onRemoteVideoStats", map);
    }

    @Override
    public void onRemoteAudioStats(RemoteAudioStats stats) {
      super.onRemoteAudioStats(stats);
      HashMap map = new HashMap<String, Object>();
      map.put("stats", mapFromRemoteAudioStats(stats));
      mMethodChannel.invokeMethod("onRemoteAudioStats", map);
    }

    @Override
    public void onRemoteAudioTransportStats(int uid, int delay, int lost, int rxKBitRate) {
      super.onRemoteAudioTransportStats(uid, delay, lost, rxKBitRate);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("delay", delay);
      map.put("lost", lost);
      map.put("rxKBitRate", rxKBitRate);
      mMethodChannel.invokeMethod("onRemoteAudioTransportStats", map);
    }

    @Override
    public void onRemoteVideoTransportStats(int uid, int delay, int lost, int rxKBitRate) {
      super.onRemoteVideoTransportStats(uid, delay, lost, rxKBitRate);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("delay", delay);
      map.put("lost", lost);
      map.put("rxKBitRate", rxKBitRate);
      mMethodChannel.invokeMethod("onRemoteVideoTransportStats", map);
    }

    @Override
    public void onAudioMixingFinished() {
      super.onAudioMixingFinished();
      mMethodChannel.invokeMethod("onAudioMixingFinished", null);
    }

    @Override
    public void onAudioEffectFinished(int soundId) {
      super.onAudioEffectFinished(soundId);
      HashMap map = new HashMap<String, Object>();
      map.put("soundId", soundId);
      mMethodChannel.invokeMethod("onAudioEffectFinished", map);
    }

    @Override
    public void onStreamPublished(String url, int error) {
      super.onStreamPublished(url, error);
      HashMap map = new HashMap<String, Object>();
      map.put("url", url);
      map.put("error", error);
      mMethodChannel.invokeMethod("onStreamPublished", map);
    }

    @Override
    public void onStreamUnpublished(String url) {
      super.onStreamUnpublished(url);
      HashMap map = new HashMap<String, Object>();
      map.put("url", url);
      mMethodChannel.invokeMethod("onStreamUnpublished", map);
    }

    @Override
    public void onTranscodingUpdated() {
      super.onTranscodingUpdated();
      mMethodChannel.invokeMethod("onTranscodingUpdated", null);
    }

    @Override
    public void onStreamInjectedStatus(String url, int uid, int status) {
      super.onStreamInjectedStatus(url, uid, status);
      HashMap map = new HashMap<String, Object>();
      map.put("url", url);
      map.put("uid", uid);
      map.put("status", status);
      mMethodChannel.invokeMethod("onStreamInjectedStatus", map);
    }

    @Override
    public void onStreamMessage(int uid, int streamId, byte[] data) {
      super.onStreamMessage(uid, streamId, data);
      try {
        String message = new String(data, "UTF-8");
        HashMap map = new HashMap<String, Object>();
        map.put("streamId", streamId);
        map.put("uid", uid);
        map.put("message", message);
        mMethodChannel.invokeMethod("onStreamMessage", map);
      } catch (Exception e) {}
    }

    @Override
    public void onStreamMessageError(int uid, int streamId, int error, int missed, int cached) {
      super.onStreamMessageError(uid, streamId, error, missed, cached);
      HashMap map = new HashMap<String, Object>();
      map.put("uid", uid);
      map.put("streamId", streamId);
      map.put("error", error);
      map.put("missed", missed);
      map.put("cached", cached);
      mMethodChannel.invokeMethod("onStreamMessageError", map);
    }

    @Override
    public void onMediaEngineLoadSuccess() {
      super.onMediaEngineLoadSuccess();
      mMethodChannel.invokeMethod("onMediaEngineLoadSuccess", null);
    }

    @Override
    public void onMediaEngineStartCallSuccess() {
      super.onMediaEngineStartCallSuccess();
      mMethodChannel.invokeMethod("onMediaEngineStartCallSuccess", null);
    }

    private HashMap mapFromStats(RtcStats stats) {
      HashMap map = new HashMap();
      map.put("duration", stats.totalDuration);
      map.put("txBytes", stats.txBytes);
      map.put("rxBytes", stats.rxBytes);
      map.put("txAudioKBitrate", stats.txAudioKBitRate);
      map.put("rxAudioKBitrate", stats.rxAudioKBitRate);
      map.put("txVideoKBitrate", stats.txVideoKBitRate);
      map.put("rxVideoKBitrate", stats.rxVideoKBitRate);
      map.put("lastmileDelay", stats.lastmileDelay);
      map.put("userCount", stats.users);
      map.put("cpuAppUsage", stats.cpuAppUsage);
      map.put("cpuTotalUsage", stats.cpuTotalUsage);
      return map;
    }

    private HashMap mapFromRect(Rect rect) {
      HashMap map = new HashMap();
      map.put("x", rect.left);
      map.put("y", rect.top);
      map.put("width", rect.width());
      map.put("height", rect.height());
      return map;
    }

    private HashMap mapFromLocalVideoStats(LocalVideoStats stats) {
      HashMap map = new HashMap();
      map.put("sentBitrate", stats.sentBitrate);
      map.put("sentFrameRate", stats.sentFrameRate);
      return map;
    }

    private HashMap mapFromRemoteVideoStats(RemoteVideoStats stats) {
      HashMap map = new HashMap();
      map.put("uid", stats.uid);
      map.put("width", stats.width);
      map.put("height", stats.height);
      map.put("receivedBitrate", stats.receivedBitrate);
      map.put("receivedFrameRate", stats.receivedFrameRate);
      map.put("rxStreamType", stats.rxStreamType);
      return map;
    }

    private HashMap mapFromRemoteAudioStats(RemoteAudioStats stats) {
      HashMap map = new HashMap();
      map.put("uid", stats.uid);
      map.put("quality", stats.quality);
      map.put("networkTransportDelay", stats.networkTransportDelay);
      map.put("jitterBufferDelay", stats.jitterBufferDelay);
      map.put("audioLossRate", stats.audioLossRate);
      return map;
    }

    private HashMap[] arrayFromSpeakers(AudioVolumeInfo[] speakers) {
      ArrayList<HashMap> list = new ArrayList<HashMap>();

      for (int i = 0; i < speakers.length; ++i) {
        AudioVolumeInfo info = speakers[i];
        HashMap map = new HashMap();
        map.put("uid", info.uid);
        map.put("volume", info.volume);

        list.add(map);
      }

      HashMap[] array = new HashMap[list.size()];
      return list.toArray(array);
    }
  };
}




