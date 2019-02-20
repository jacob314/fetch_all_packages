package io.flutter.biometric;

import android.app.Activity;
import android.app.Application;
import android.app.KeyguardManager;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.support.v4.hardware.fingerprint.FingerprintManagerCompat;
import android.support.v4.os.CancellationSignal;
import io.flutter.plugin.common.MethodCall;

public class BiometricHelper extends FingerprintManagerCompat.AuthenticationCallback implements Application.ActivityLifecycleCallbacks {

    private final Activity activity;
    private final AuthCompletionHandler authCompletionHandler;
    private final KeyguardManager keyguardManager;
    private final FingerprintManagerCompat fingerprintManager;
    private final MethodCall call;
    private String errorCode = "";
    private String errorMessage = "";
    private CancellationSignal cancellationSignal;
    private static final long DISMISS_MS = 300;

    interface AuthCompletionHandler {
        void onSuccess();
        void onFailure(String erroCode, String errorMessage);
        void onError(String erroCode, String errorMessage);
    }

    BiometricHelper(Activity activity, MethodCall call, AuthCompletionHandler authCompletionHandler) {
        this.activity = activity;
        this.authCompletionHandler = authCompletionHandler;
        this.call = call;
        this.keyguardManager = (KeyguardManager) activity.getSystemService(Context.KEYGUARD_SERVICE);
        this.fingerprintManager = FingerprintManagerCompat.from(activity);
    }

    void biometricAuthenticate() {
        if (fingerprintManager.isHardwareDetected()) {
            if (keyguardManager.isKeyguardSecure() && fingerprintManager.hasEnrolledFingerprints()) {
                start();
            } else if (!keyguardManager.isKeyguardSecure()) {
                authCompletionHandler.onError("BIO-ERROR", "Phone not secured by PIN, pattern or password, or SIM is currently locked.");
            } else {
                authCompletionHandler.onError("BIO-ERROR", "No fingerprint enrolled on this device.");
            }
        } else {
            authCompletionHandler.onError("BIO-ERROR", "Fingerprint is not available on this device.");
        }
    }

    private void start() {
        activity.getApplication().registerActivityLifecycleCallbacks(this);
        resume();
    }

    private void resume() {
        cancellationSignal = new CancellationSignal();
        fingerprintManager.authenticate(null, 0, cancellationSignal, this, null);
    }

    private void pause() {
        if (cancellationSignal != null) {
            cancellationSignal.cancel();
        }
    }

    private void stop(boolean success, String errorCode, String errorMessage) {
        pause();
        activity.getApplication().unregisterActivityLifecycleCallbacks(this);
        if (success) {
            authCompletionHandler.onSuccess();
        } else {
            authCompletionHandler.onFailure(errorCode, errorMessage);
        }
    }

    @Override
    public void onActivityPaused(Activity activity) {

        if (call.argument("keepAlive")) {
            pause();
        } else {
            errorCode = "BIO-ERROR";
            errorMessage = "Generic Error";
            stop(false, errorCode, errorMessage);
        }
    }

    @Override
    public void onActivityResumed(Activity activity) {
        if (call.argument("keepAlive")) {
            resume();
        }
    }


    @Override
    public void onAuthenticationError(int errMsgId, CharSequence errString) {
        if (cancellationSignal.isCanceled()) return;
        errorCode = "BIO-ERROR";
        errorMessage = errString.toString();
        new Handler(Looper.myLooper())
            .postDelayed(
                new Runnable() {
                    @Override
                    public void run() {
                        stop(false, errorCode, errorMessage);
                    }
                },
                DISMISS_MS
            );
    }

    @Override
    public void onAuthenticationHelp(int helpMsgId, CharSequence helpString) {
        if (cancellationSignal.isCanceled()) return;
        errorCode = "BIO-ERROR";
        errorMessage = helpString.toString();
        new Handler(Looper.myLooper())
            .postDelayed(
                new Runnable() {
                    @Override
                    public void run() {
                        stop(false, errorCode, errorMessage);
                    }
                },
                DISMISS_MS
            );
    }

    @Override
    public void onAuthenticationFailed() {
        if (cancellationSignal.isCanceled()) return;
        errorCode = "BIO-ERROR";
        errorMessage = "Generic Error";
        new Handler(Looper.myLooper())
            .postDelayed(
                new Runnable() {
                    @Override
                    public void run() {
                        stop(false, errorCode, errorMessage);
                    }
                },
                DISMISS_MS
            );
    }

    @Override
    public void onAuthenticationSucceeded(FingerprintManagerCompat.AuthenticationResult result) {
        if (cancellationSignal.isCanceled()) return;
        errorCode = "BIO-SUCCESS";
        errorMessage = "";
        new Handler(Looper.myLooper())
            .postDelayed(
                new Runnable() {
                    @Override
                    public void run() {
                        stop(true, errorCode, errorMessage);
                    }
                },
                DISMISS_MS
            );
    }

    public void onAuthenticationCancelled() {
        if (cancellationSignal.isCanceled()) return;
        errorCode = "BIO-CANCEL";
        errorMessage = "Authentication Cancelled";
        new Handler(Looper.myLooper())
            .postDelayed(
                new Runnable() {
                    @Override
                    public void run() {
                        stop(false, errorCode, errorMessage);
                    }
                },
                DISMISS_MS
            );
    }

    @Override
    public void onActivityCreated(Activity activity, Bundle bundle) {}

    @Override
    public void onActivityStarted(Activity activity) {}

    @Override
    public void onActivityStopped(Activity activity) {}

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle bundle) {}

    @Override
    public void onActivityDestroyed(Activity activity) {}

}
