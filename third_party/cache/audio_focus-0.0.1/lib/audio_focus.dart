import 'dart:async';
import 'package:flutter/services.dart';


enum AudioState {
  BECOME_NOISY,
  AUDIOFOCUS_GAIN,
  AUDIOFOCUS_GAIN_TRANSIENT,
  AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK,
  AUDIOFOCUS_LOSS,
  AUDIOFOCUS_LOSS_TRANSIENT,
  AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK,
  AUDIOFOCUS_REQUEST_FAILED
}

class AudioFocus {

  static const MethodChannel _channel = const MethodChannel('audio_focus');

  EventChannel _audioBecomeNoisyChannel = EventChannel(
      'dumbandshort.flutter.io/BecomeNoisy');
  Stream<AudioState> _audioBecomeNoisyEvents;

  EventChannel _audioFocusChannel = EventChannel(
      'dumbandshort.flutter.io/AudioFocus');
  Stream<AudioState> _audioFocusEvents;


  Stream<AudioState> get audioManagerEvents {
    if (_audioBecomeNoisyEvents == null) {
      _audioBecomeNoisyEvents = _audioBecomeNoisyChannel
          .receiveBroadcastStream()
          .map((dynamic event) => _parseAudioState(event));
    }
    return _audioBecomeNoisyEvents;
  }

  Stream<AudioState> get audioFocusEvents {
    if (_audioFocusEvents == null) {
      _audioFocusEvents = _audioFocusChannel
          .receiveBroadcastStream()
          .map((dynamic event) =>_parseAudioState(event));
    }
    return _audioFocusEvents;
  }


  AudioState _parseAudioState(String state) {
    switch (state) {
      case "android.media.AUDIO_BECOMING_NOISY":
        return AudioState.BECOME_NOISY;
      case "AUDIOFOCUS_GAIN":
        return AudioState.AUDIOFOCUS_GAIN;
      case "AUDIOFOCUS_GAIN_TRANSIENT":
        return AudioState.AUDIOFOCUS_GAIN_TRANSIENT;
      case "AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK":
        return AudioState.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK;
      case "AUDIOFOCUS_LOSS":
        return AudioState.AUDIOFOCUS_LOSS;
      case "AUDIOFOCUS_LOSS_TRANSIENT":
        return AudioState.AUDIOFOCUS_LOSS_TRANSIENT;
      case "AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK":
        return AudioState.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK;
      case "AUDIOFOCUS_REQUEST_FAILED":
        return AudioState.AUDIOFOCUS_REQUEST_FAILED;
      default:
        return AudioState.AUDIOFOCUS_REQUEST_FAILED;
    }
  }
}
