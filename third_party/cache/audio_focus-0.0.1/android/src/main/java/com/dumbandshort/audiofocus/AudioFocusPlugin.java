package com.dumbandshort.audiofocus;

import android.annotation.TargetApi;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.Sensor;
import android.media.AudioManager;
import android.os.Build;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** AudioFocusPlugin */
@TargetApi(Build.VERSION_CODES.FROYO)
public class AudioFocusPlugin implements EventChannel.StreamHandler{

    private static final String AUDIO_BECOME_NOISY_CHANNEL = "dumbandshort.flutter.io/BecomeNoisy";
    private static final String AUDIO_FOCUS_CHANNEL = "dumbandshort.flutter.io/AudioFocus";
    private PluginRegistry.Registrar registrar;
    private BroadcastReceiver audioBecomeNoisyChangeReceiver;
    AudioManager.OnAudioFocusChangeListener audioFocusChangeListener;
    private AudioManager audioManager;

    AudioFocusPlugin(PluginRegistry.Registrar registrar){
        this.registrar = registrar;
        audioManager = (AudioManager) registrar.context().getSystemService(Context.AUDIO_SERVICE);
    }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
      final EventChannel audioNoisyChannel = new EventChannel(registrar.messenger(), AUDIO_BECOME_NOISY_CHANNEL);
      audioNoisyChannel.setStreamHandler(new AudioFocusPlugin(registrar));

      final EventChannel audioFocusChannel = new EventChannel(registrar.messenger(), AUDIO_FOCUS_CHANNEL);
      audioFocusChannel.setStreamHandler(new AudioFocusPlugin(registrar));
  }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {

        audioFocusChangeListener = createAudioFocusChangeListener(eventSink);
        audioManager.requestAudioFocus(audioFocusChangeListener, AudioManager.STREAM_MUSIC, AudioManager.AUDIOFOCUS_GAIN);

        audioBecomeNoisyChangeReceiver = createAudioNoisyReceiver(eventSink);
        registrar.context().registerReceiver(audioBecomeNoisyChangeReceiver, new IntentFilter(AudioManager.ACTION_AUDIO_BECOMING_NOISY));
    }

    @Override
    public void onCancel(Object o) {
        registrar.context().unregisterReceiver(audioBecomeNoisyChangeReceiver);
        audioBecomeNoisyChangeReceiver = null;
    }

    private BroadcastReceiver createAudioNoisyReceiver(final EventChannel.EventSink events) {
        return new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                String action  = intent.getAction();
                events.success(action);
            }
        };
    }

    private AudioManager.OnAudioFocusChangeListener createAudioFocusChangeListener(final EventChannel.EventSink events){
     return new AudioManager.OnAudioFocusChangeListener() {
        @Override
        public void onAudioFocusChange(int focusChange) {
            switch (focusChange) {
                case AudioManager.AUDIOFOCUS_GAIN:
                    events.success("AUDIOFOCUS_GAIN");
                    break;
                case AudioManager.AUDIOFOCUS_GAIN_TRANSIENT:
                    events.success("AUDIOFOCUS_GAIN_TRANSIENT");
                    break;
                case AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK:
                    events.success("AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK");
                    break;
                case AudioManager.AUDIOFOCUS_LOSS:
                    events.success("AUDIOFOCUS_LOSS");
                    break;
                case AudioManager.AUDIOFOCUS_LOSS_TRANSIENT:
                    events.success("AUDIOFOCUS_LOSS_TRANSIENT");;
                    break;
                case AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK:
                    events.success("AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK");
                    break;
                case AudioManager.AUDIOFOCUS_REQUEST_FAILED:
                    events.success("AUDIOFOCUS_REQUEST_FAILED");
                    break;
                default:
                    events.success("AUDIOFOCUS_REQUEST_FAILED");
                    break;
            }
        }
    };
}
}
