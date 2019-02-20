package com.ly.fluqq;

import android.content.Intent;

import com.tencent.connect.UserInfo;
import com.tencent.connect.common.Constants;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FluqqPlugin implements MethodCallHandler {

    private static Tencent tencent;
    private Registrar registrar;

    private FluqqPlugin(Registrar registrar) {
        this.registrar = registrar;
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "fluqq");
        channel.setMethodCallHandler(new FluqqPlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        QQListener listener = new QQListener();
        registrar.addActivityResultListener(listener);
        switch (call.method) {
            case "register":
                String appid = call.argument("androidAppId");
                tencent = Tencent.createInstance(appid, registrar.context());
                result.success(null);
                break;
            case "login":
                listener.setResult(result);
                tencent.login(registrar.activity(), "all", listener);
                break;
            case "userInfo":
                listener.setResult(result);
                userInfo(call, listener);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void userInfo(MethodCall call, final  QQListener listener) {
        String openId = call.argument("openId");
        tencent.setOpenId(openId);
        String accessToken = call.argument("accessToken");
        Long expiresTime = call.argument("expiresTime");
        tencent.setAccessToken(accessToken, expiresTime.toString());
        final UserInfo userInfo = new UserInfo(registrar.activity(), tencent.getQQToken());
        userInfo.getUserInfo(listener);
    }

    private class QQListener implements IUiListener, PluginRegistry.ActivityResultListener {
        private Result result;

        void setResult(Result result) {
            this.result = result;
        }

        @Override
        public void onComplete(Object object) {
            Map<String, Object> map = new HashMap<>();
            map.put("status", 0);
            map.put("msg", object.toString());
            result.success(map);
        }

        @Override
        public void onError(UiError uiError) {
            Map<String, Object> map = new HashMap<>();
            map.put("status", 1);
            map.put("msg", "errorCode:" + uiError.errorCode + ";errorMessage:" + uiError.errorMessage);
            result.success(map);
        }

        @Override
        public void onCancel() {
            Map<String, Object> map = new HashMap<>();
            map.put("status", 2);
            map.put("msg", "cancel");
            result.success(map);
        }

        @Override
        public boolean onActivityResult(int requestCode, int resultCode, Intent intent) {
            if (requestCode == Constants.REQUEST_LOGIN ||
                    requestCode == Constants.REQUEST_QQ_SHARE ||
                    requestCode == Constants.REQUEST_QZONE_SHARE ||
                    requestCode == Constants.REQUEST_APPBAR) {
                Tencent.onActivityResultData(requestCode, resultCode, intent, this);
                return true;
            }
            return false;
        }
    }
}
