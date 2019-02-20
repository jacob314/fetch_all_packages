package com.github.xu.flutterwechat;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
import com.tencent.mm.opensdk.modelmsg.WXImageObject;
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage;
import com.tencent.mm.opensdk.modelmsg.WXMusicObject;
import com.tencent.mm.opensdk.modelmsg.WXTextObject;
import com.tencent.mm.opensdk.modelmsg.WXVideoObject;
import com.tencent.mm.opensdk.modelmsg.WXWebpageObject;
import com.tencent.mm.opensdk.modelpay.PayReq;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.EventChannel.StreamHandler;

/**
 * FlutterWechatPlugin
 */
public class FlutterWechatPlugin implements MethodCallHandler {

    private static int code;//返回错误吗
    private static String loginCode;//获取access_code
    private static IWXAPI iwxapi;
    private static  Result res;
    private Context c;
    private String wxId;
    private Bitmap bitmap;
    private WXMediaMessage wxMsg;
    private int type = 0;
    private final PluginRegistry.Registrar registrar;
    private BroadcastReceiver sendRespReceiver;
    private Handler mHandler = new Handler(new Handler.Callback() {

        @Override
        public boolean handleMessage(Message msg) {
            SendMessageToWX.Req req = new SendMessageToWX.Req();
            req.scene = type == 0 ? SendMessageToWX.Req.WXSceneSession : SendMessageToWX.Req.WXSceneTimeline;
            switch (msg.what) {
                case 0:
                    if (bitmap != null) {
                        wxMsg.setThumbImage(bitmap);
                    }
                    req.transaction = String.valueOf(System.currentTimeMillis());
                    req.message = wxMsg;
                    iwxapi.sendReq(req);
                    break;
                case 1:
                    if (bitmap != null) {
                        wxMsg.setThumbImage(bitmap);
                    } else {
                        Toast.makeText(c, "图片路径错误", Toast.LENGTH_SHORT).show();
                        break;
                    }
                    WXImageObject wxImageObject = new WXImageObject(bitmap);
                    wxMsg.mediaObject = wxImageObject;
                    Bitmap bmp = Bitmap.createScaledBitmap(bitmap, 80, 80, true);
                    bmp.recycle();
                    wxMsg.setThumbImage(bitmap);
                    req.transaction = String.valueOf(System.currentTimeMillis());
                    req.message = wxMsg;
                    iwxapi.sendReq(req);
                    break;
                case 3:
                    if (bitmap != null) {
                        wxMsg.setThumbImage(bitmap);
                    }
                    req.transaction = String.valueOf(System.currentTimeMillis());
                    req.message = wxMsg;

                    iwxapi.sendReq(req);
                    break;
                case 4:
                    if (bitmap != null) {
                        wxMsg.setThumbImage(bitmap);
                    }
                    req.transaction = String.valueOf(System.currentTimeMillis());
                    req.message = wxMsg;
                    iwxapi.sendReq(req);
                    break;
                default:
                    break;
            }
            return false;
        }
    });

    public static int getCode() {

        return code;
    }

    public static void setCode(int tCode) {

        code = tCode;
    }

    public static String getLoginCode() {
        return loginCode;
    }

    public static void setLoginCode(String tCode) {

        loginCode = tCode;
    }

    private FlutterWechatPlugin(Context context, Registrar registrar) {
        this.registrar = registrar;
        c = context;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_wechat");
        final FlutterWechatPlugin instance = new FlutterWechatPlugin(registrar.context(), registrar);
        channel.setMethodCallHandler(instance);
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("sendResp");
        registrar.context().registerReceiver(createReceiver(), intentFilter);
    }


    @Override
    public void onMethodCall(MethodCall call, Result result) {
        res=result;
        switch (call.method) {
            case "registerWechat":
                wxId = call.argument("wxId");
                iwxapi = WXAPIFactory.createWXAPI(c, wxId, true);
                iwxapi.registerApp(wxId);
                res=result;
                res.success(null);
                break;
            case "shareWebPage":
                WXWebpageObject webpage = new WXWebpageObject();
                final String webpageUrl = call.argument("webpageUrl");
                final String webDescription = call.argument("description");
                final String webTitle = call.argument("title");
                type = call.argument("type");
                final String imgUrl = call.argument("imgUrl");
                webpage.webpageUrl = webpageUrl;
                wxMsg = new WXMediaMessage(webpage);
                wxMsg.title = webTitle;
                wxMsg.description = webDescription;

                //网络图片或者本地图片
                new Thread() {
                    public void run() {
                        Message message = new Message();
                        bitmap = GetLocalOrNetBitmap(imgUrl);
                        message.what = 0;
                        mHandler.sendMessage(message);
                    }
                }.start();

                break;
            case "shareText":
                WXTextObject textObject = new WXTextObject();
                final String text = call.argument("text");
                textObject.text = text;
                wxMsg = new WXMediaMessage();
                wxMsg.mediaObject = textObject;
                wxMsg.description = text;
                SendMessageToWX.Req req = new SendMessageToWX.Req();
                req.transaction = String.valueOf(System.currentTimeMillis());
                req.message = wxMsg;
                req.scene = type == 0 ? SendMessageToWX.Req.WXSceneSession : SendMessageToWX.Req.WXSceneTimeline;
                iwxapi.sendReq(req);
                break;
            case "shareImage":
                final String shareImageUrl = call.argument("imgUrl");
                wxMsg = new WXMediaMessage();
                //网络图片或者本地图片
                new Thread() {
                    public void run() {
                        Message message = new Message();
                        bitmap = GetLocalOrNetBitmap(shareImageUrl);
                        message.what = 1;
                        mHandler.sendMessage(message);
                    }
                }.start();
            case "shareMusic":
                String musicUrl = call.argument("musicUrl");
                final String musicDataUrl = call.argument("musicDataUrl");
                final String musicImgUrl = call.argument("imgUrl");
                final String musicLowBandDataUrl = call.argument("musicLowBandDataUrl");
                final String musicLowBandUrl = call.argument("musicLowBandUrl");
                final String musicDescription = call.argument("description");
                final String musicTitle = call.argument("title");
                WXMusicObject wxMusicObject = new WXMusicObject();
                wxMusicObject.musicUrl = musicUrl;
                wxMusicObject.musicDataUrl = musicDataUrl;
                wxMusicObject.musicLowBandDataUrl = musicLowBandDataUrl;
                wxMusicObject.musicLowBandUrl = musicLowBandUrl;
                wxMsg = new WXMediaMessage();
                wxMsg.mediaObject = wxMusicObject;
                wxMsg.title = musicTitle;
                wxMsg.description = musicDescription;
                //网络图片或者本地图片
                new Thread() {
                    public void run() {
                        Message message = new Message();
                        bitmap = GetLocalOrNetBitmap(musicImgUrl);
                        message.what = 3;
                        mHandler.sendMessage(message);
                    }
                }.start();
                break;
            case "shareVideo":
                final String videoImgUrl = call.argument("imgUrl");
                final String videoDescription = call.argument("description");
                final String videoTitle = call.argument("title");
                final String videoUrl = call.argument("videoUrl");
                final String videoLowBandUrl = call.argument("videoLowBandUrl");
                WXVideoObject videoObject = new WXVideoObject();
                videoObject.videoUrl = videoUrl;
                videoObject.videoLowBandUrl = videoLowBandUrl;
                wxMsg = new WXMediaMessage(videoObject);
                wxMsg.description = videoDescription;
                wxMsg.title = videoTitle;

                //网络图片或者本地图片
                new Thread() {
                    public void run() {
                        Message message = new Message();
                        bitmap = GetLocalOrNetBitmap(videoImgUrl);
                        message.what = 4;
                        mHandler.sendMessage(message);
                    }
                }.start();

                break;
            case "login":
                final String scope = call.argument("scope");
                final String state = call.argument("state");
                SendAuth.Req sendReq = new SendAuth.Req();
                sendReq.scope = scope;
                sendReq.state = state;
                iwxapi.sendReq(sendReq);
                break;
            case "pay":
                final String appId = call.argument("appId");
                final String partnerId = call.argument("partnerId");
                final String prepayId = call.argument("prepayId");
                final String nonceStr = call.argument("nonceStr");
                final String timeStampe = call.argument("timeStamp");
                final String sign = call.argument("sign");
                final String packageValue = call.argument("package");
                PayReq payReq = new PayReq();
                payReq.partnerId = partnerId;
                payReq.prepayId = prepayId;
                payReq.nonceStr = nonceStr;
                payReq.timeStamp = timeStampe;
                payReq.sign = sign;
                payReq.packageValue = packageValue;
                payReq.appId = appId;
                iwxapi.sendReq(payReq);
                break;
            default:
                result.notImplemented();
                break;
        }


    }

    public Bitmap GetLocalOrNetBitmap(String url) {
        Bitmap bitmap = null;
        InputStream in = null;
        BufferedOutputStream out = null;
        try {
            in = new BufferedInputStream(new URL(url).openStream(), 1024);
            final ByteArrayOutputStream dataStream = new ByteArrayOutputStream();
            out = new BufferedOutputStream(dataStream, 1024);
            copy(in, out);
            out.flush();
            byte[] data = dataStream.toByteArray();
            bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);
            return bitmap;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    private static void copy(InputStream in, OutputStream out)
            throws IOException {
        byte[] b = new byte[1024];
        int read;
        while ((read = in.read(b)) != -1) {
            out.write(b, 0, read);
        }
    }

    private static BroadcastReceiver createReceiver() {
        return new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                System.out.println(intent.getStringExtra("type"));
                if (intent.getStringExtra("type").equals("SendAuthResp")) {
                    res.success(intent.getStringExtra("code"));
                } else if (intent.getStringExtra("type").equals("PayResp")) {
                    res.success(intent.getStringExtra("code"));
                } else if (intent.getStringExtra("type").equals("ShareResp")) {
                    System.out.println(intent.getStringExtra("code"));
                    res.success(intent.getStringExtra("code"));
                }
            }
        };
    }
}
