package vn.hudastudio.basewebview;

import android.graphics.Bitmap;
import android.util.Log;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by lejard_h on 20/12/2017.
 */

public class BrowserClient extends WebViewClient {
    private static final String TAG = BrowserClient.class.getSimpleName();
    List<String> overridableUrls;
    List<String> uriSchemes;

    public BrowserClient() {
        super();
    }

    public void setOverridableUrls(List<String> overridableUrls) {
        this.overridableUrls = overridableUrls;
        Log.d(TAG, "setOverridableUrls in BrowserClient");
    }

    public void setUriSchemes(List<String> uriSchemes) {
        this.uriSchemes = uriSchemes;
        Log.d(TAG, "setUriSchemes in BrowserClient");
    }

    @Override
    public void onPageStarted(WebView view, String url, Bitmap favicon) {
        super.onPageStarted(view, url, favicon);
        Map<String, Object> data = new HashMap<>();
        data.put("url", url);
        data.put("type", "startLoad");
        BaseWebviewPlugin.channel.invokeMethod("onState", data);
    }

    @Override
    public boolean shouldOverrideUrlLoading(WebView view, String url) {
        if (schemeMatched(url)) {
            Map<String, Object> data = new HashMap<>();
            data.put("url", url);
            BaseWebviewPlugin.channel.invokeMethod("onSchemeMatched", data);
            Log.d(TAG, "schemeMatched: " + url);
            return true;
        } else if (canUrlBeOverridden(url)) {
            Map<String, Object> data = new HashMap<>();
            data.put("url", url);
            BaseWebviewPlugin.channel.invokeMethod("onUrlOverridden", data);
            Log.d(TAG, "canUrlBeOverridden: " + url);
            return true;
        } else {
            return false;
        }
    }

    private boolean schemeMatched(String url) {
        if (uriSchemes != null) {
            for (String scheme : uriSchemes) {
                if (url.startsWith(scheme)) {
                    return true;
                }
            }
        }
        return false;
    }

    private boolean canUrlBeOverridden(String url) {
        if (overridableUrls != null) {
            for (String oUrl : overridableUrls) {
                if (url.contains(oUrl)) {
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public void onPageFinished(WebView view, String url) {
        super.onPageFinished(view, url);
        Map<String, Object> data = new HashMap<>();
        data.put("url", url);

        BaseWebviewPlugin.channel.invokeMethod("onUrlChanged", data);

        data.put("type", "finishLoad");
        BaseWebviewPlugin.channel.invokeMethod("onState", data);

    }

    @Override
    public void onReceivedHttpError(WebView view, WebResourceRequest request, WebResourceResponse errorResponse) {
        super.onReceivedHttpError(view, request, errorResponse);
        Map<String, Object> data = new HashMap<>();
        data.put("url", request.getUrl().toString());
        data.put("code", Integer.toString(errorResponse.getStatusCode()));
        BaseWebviewPlugin.channel.invokeMethod("onHttpError", data);
    }


}