# audio_focus

A new Flutter plugin for managing audio focus

## Getting Started

Using a Media Playing Plugin, start playing an audio file.  Android Only

## Usage

AudioFocus audioFocus = AudioFocus();

audioFocus.audioFocusEvents.listen((focusEvent) {
      if (focusEvent == AudioState.AUDIOFOCUS_GAIN) {
        //Do Something
      } else if (focusEvent == AudioState.BECOME_NOISY) {
        //Do Something
      } else if (focusEvent == AudioState.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK) {
         //Do Something
      }else if(focusEvent == AudioState.AUDIOFOCUS_LOSS_TRANSIENT){
        //Do Something
      }
});

## Audio States

  BECOME_NOISY,
  AUDIOFOCUS_GAIN,
  AUDIOFOCUS_GAIN_TRANSIENT,
  AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK,
  AUDIOFOCUS_LOSS,
  AUDIOFOCUS_LOSS_TRANSIENT,
  AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK,
  AUDIOFOCUS_REQUEST_FAILED

This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
