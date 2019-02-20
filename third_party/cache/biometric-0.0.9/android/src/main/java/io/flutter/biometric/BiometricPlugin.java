package io.flutter.biometric;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.app.Activity;
import android.support.v4.hardware.fingerprint.FingerprintManagerCompat;
import io.flutter.biometric.BiometricHelper.AuthCompletionHandler;
import java.util.ArrayList;
import java.util.concurrent.atomic.AtomicBoolean;

/** BiometricPlugin */
public class BiometricPlugin implements MethodCallHandler {

  private final Registrar registrar;
  private final AtomicBoolean inProgress = new AtomicBoolean(false);

  private BiometricHelper biometricHelper;
  private Activity activity;

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "biometric");
    channel.setMethodCallHandler(new BiometricPlugin(registrar));
  }

  private BiometricPlugin(Registrar registrar) {
    this.registrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {

    if (call.method.equals("biometricAuthenticate")) {

      if (!inProgress.compareAndSet(false, true)) {
        result.error("BIO-PROGRESS", "Authentication already in progress", null);
        return;
      }
      activity = registrar.activity();
      if (activity == null || activity.isFinishing()) {
        result.error("BIO-ERROR", "Internal Error", null);
        return;
      }
      biometricHelper =
        new BiometricHelper(
          activity,
            call,
            new AuthCompletionHandler() {
              @Override
              public void onSuccess() {
                if (inProgress.compareAndSet(true, false)) {
                  result.success(true);
                }
              }

              @Override
              public void onFailure(String errorCode, String errorMessage) {
                if (inProgress.compareAndSet(true, false)) {
                  result.error(errorCode, errorMessage, null);
                }
              }

              @Override
              public void onError(String errorCode, String errorMessage) {
                if (inProgress.compareAndSet(true, false)) {
                  result.error(errorCode, errorMessage, null);
                }
              }
            });
      biometricHelper.biometricAuthenticate();

    } else if (call.method.equals("biometricAvailable")) {

      try {
        FingerprintManagerCompat fingerprintMgr = FingerprintManagerCompat.from(registrar.activity());
        if (fingerprintMgr.isHardwareDetected()) {
          if (fingerprintMgr.hasEnrolledFingerprints()) {
            result.success(true);
          } else {
            result.success(false);
          }
        }
      } catch (Exception e) {
        result.error("BIO-ERROR", e.getMessage(), null);
      }

    } else if (call.method.equals("biometricCancel")) {

      if (!inProgress.compareAndSet(false, true)) {
        biometricHelper.onAuthenticationCancelled();
      }

    } else if (call.method.equals("biometricType")) {

      try {
        ArrayList<String> biometricList = new ArrayList<String>();
        FingerprintManagerCompat fingerprintMgr = FingerprintManagerCompat.from(registrar.activity());
        if (fingerprintMgr.isHardwareDetected()) {
          if (fingerprintMgr.hasEnrolledFingerprints()) {
            biometricList.add("fingerprint");
          } else {
            biometricList.add("undefined");
          }
        }
        result.success(biometricList);
      } catch (Exception e) {
        result.error("BIO-ERROR", e.getMessage(), null);
    }

    } else {
      result.notImplemented();
    }
  }

}