package com.shareclarity.voicerecognition;

import android.Manifest;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Bundle;
import android.speech.RecognitionListener;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.shareclarity.voicerecognition.speechrecognitionview.RecognitionProgressView;
import com.shareclarity.voicerecognition.speechrecognitionview.adapters.RecognitionListenerAdapter;

import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformView;

public class VoiceRecognitionView  implements PlatformView, MethodChannel.MethodCallHandler{
    public final MethodChannel methodChannel;
    private Context context;
    private View mView;
    private Application.ActivityLifecycleCallbacks activityLifecycleCallbacks;

    //Speech Recognition
    private SpeechRecognizer speech;
    private boolean cancelled = false;
    RecognitionProgressView recognitionProgressView;
    private Intent recognizerIntent;

    VoiceRecognitionView(Context _context, BinaryMessenger messenger, int id, Object object, PluginRegistry.Registrar registrar) {
        context = _context;
        methodChannel = new MethodChannel(messenger, "voice_recognition_" + id);
        methodChannel.setMethodCallHandler(this);


        recognizerIntent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
        recognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
        recognizerIntent.putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true);
        recognizerIntent.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 3);


        int[] colors = {
                VoiceRecognitionPlugin.mActivity.getResources().getColor(R.color.color1),
                VoiceRecognitionPlugin.mActivity.getResources().getColor(R.color.color1),
                VoiceRecognitionPlugin.mActivity.getResources().getColor(R.color.color1),
                VoiceRecognitionPlugin.mActivity.getResources().getColor(R.color.color1),
                VoiceRecognitionPlugin.mActivity.getResources().getColor(R.color.color1),
                VoiceRecognitionPlugin.mActivity.getResources().getColor(R.color.color1),
                VoiceRecognitionPlugin.mActivity.getResources().getColor(R.color.color1),
                VoiceRecognitionPlugin.mActivity.getResources().getColor(R.color.color1),
                VoiceRecognitionPlugin.mActivity.getResources().getColor(R.color.color1),
                VoiceRecognitionPlugin.mActivity.getResources().getColor(R.color.color1),
                VoiceRecognitionPlugin.mActivity.getResources().getColor(R.color.color1),
        };

        int[] heights = { 50, 48, 36, 46, 32 , 48, 56, 34, 24 , 48, 48};


        LayoutInflater inflater = LayoutInflater.from(VoiceRecognitionPlugin.mActivity);
        View view = inflater.inflate(R.layout.speech_layout, null);

        recognitionProgressView = (RecognitionProgressView) view.findViewById(R.id.recognition_view);

        recognitionProgressView.setColors(colors);
        recognitionProgressView.setBarMaxHeightsInDp(heights);
        recognitionProgressView.setCircleRadiusInDp(5);
        recognitionProgressView.setSpacingInDp(5);
        recognitionProgressView.setIdleStateAmplitudeInDp(5);
        recognitionProgressView.setRotationRadiusInDp(10);
        recognitionProgressView.play();

        mView = view;
        if (checkSelfPermission(Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED) {
            speech = SpeechRecognizer.createSpeechRecognizer(VoiceRecognitionPlugin.mActivity.getApplicationContext());
            recognitionProgressView.setSpeechRecognizer(speech);

            recognitionProgressView.setRecognitionListener(new RecognitionListenerAdapter() {
                @Override
                public void onEndOfSpeech() {
                    super.onEndOfSpeech();
                }

                @Override
                public void onResults(Bundle results) {
                    startRecognition();
                }

                @Override
                public void onPartialResults(Bundle partialResults) {
                    showResults(partialResults);
                }
            });

        }

    }

    private void showResults(Bundle results) {
        ArrayList<String> matches = results
                .getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);
        String result = "";
        for (int i=0;i<matches.size();i++) {
            result = result + matches.get(i) + " ";
        }

        methodChannel.invokeMethod("voice.result",result);

    }

    @Override
    public View getView() {
        return mView;
    }

    @Override
    public void dispose() {

        speech.stopListening();
    }

    private void stopRecognition() {
        speech.stopListening();
    }

    private int checkSelfPermission(String permission) {
        if (permission == null) {
            throw new IllegalArgumentException("permission is null");
        }
        return context.checkPermission(
                permission, android.os.Process.myPid(), android.os.Process.myUid());
    }

    private void startRecognition() {
        speech.startListening(recognizerIntent);
        recognitionProgressView.play();
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "voice.start":
                startRecognition();
                result.success("");
                break;
            case "voice.stop":
                stopRecognition();
                result.success("");
                break;

            default:
                result.notImplemented();
        }

    }

}
