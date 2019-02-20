package com.scliang.futils;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.os.Build;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.ref.SoftReference;
import java.util.Map;
import java.util.regex.Pattern;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

final class FutilsWebManager {
  private SoftReference<Activity> mActivity;
  private BasicMessageChannel<String> mMessageChannel;
  boolean closed;
  private RelativeLayout mWebViewContainer;
  private WebView mWebView;
  private ProgressBar mProgressBar;

  FutilsWebManager(Activity activity, BasicMessageChannel<String> messageChannel) {
    mActivity = new SoftReference<>(activity);
    mMessageChannel = messageChannel;
    mWebViewContainer = new RelativeLayout(activity);
    mWebViewContainer.setBackgroundColor(0xffffffff);
    mWebViewContainer.setPadding(0, getStatusBarHeight(), 0, 0);
    mWebView = new WebView(activity);
    mProgressBar = new ProgressBar(activity);
    setupWebView();
    layout(activity);
    closed = false;
  }

  @SuppressLint("SetJavaScriptEnabled")
  private void setupWebView() {
    mWebView.setScrollBarStyle(View.SCROLLBARS_INSIDE_OVERLAY);
    mWebView.setWebViewClient(new WebClient());
    mWebView.setWebChromeClient(new ChromeClient());

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
      WebSettings settings = mWebView.getSettings();
      if (settings != null) {
        settings.setJavaScriptEnabled(true);
        settings.setGeolocationEnabled(true);

        settings.setDomStorageEnabled(true);
        settings.setAllowFileAccess(true);
        settings.setAppCacheEnabled(true);
        settings.setAllowContentAccess(true);
        settings.setLightTouchEnabled(true);

        settings.setDatabaseEnabled(true);
        settings.setNeedInitialFocus(true);

        settings.setJavaScriptCanOpenWindowsAutomatically(true);
        settings.setLoadWithOverviewMode(true);
        settings.setUseWideViewPort(true);
        settings.setSupportZoom(true);
        settings.setBuiltInZoomControls(true);
        settings.setDisplayZoomControls(false);
      }

      // 移除系统开放的JS接口
      mWebView.removeJavascriptInterface("searchBoxJavaBridge_");
      mWebView.removeJavascriptInterface("accessibility");
      mWebView.removeJavascriptInterface("accessibilityTraversal");
    }
  }

  private void layout(Activity activity) {
    final RelativeLayout.LayoutParams wlp =
        new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT,
            RelativeLayout.LayoutParams.MATCH_PARENT);
    mWebViewContainer.addView(mWebView, wlp);
//    final RelativeLayout.LayoutParams tlp =
//        new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT,
//            dp2px(activity, 44));
//    final LinearLayout toolbar = new LinearLayout(activity);
//    toolbar.setOrientation(LinearLayout.HORIZONTAL);
//    toolbar.setBackgroundColor(0x33000000);
//    mWebViewContainer.addView(toolbar, tlp);
    final RelativeLayout.LayoutParams plp =
        new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT,
            RelativeLayout.LayoutParams.WRAP_CONTENT);
    plp.addRule(RelativeLayout.CENTER_IN_PARENT);
    mProgressBar.setVisibility(View.GONE);
    mWebViewContainer.addView(mProgressBar, plp);
  }

  private int getStatusBarHeight() {
    final Activity activity = mActivity == null ? null : mActivity.get();
    if (activity == null) {
      return 0;
    }

    int result = 0;
    Resources resources = activity.getResources();
    int resourceId = resources.getIdentifier(
        "status_bar_height", "dimen", "android"
    );

    if (resourceId > 0) {
      result = resources.getDimensionPixelSize(resourceId);
    }

    return result;
  }

  private final class WebClient extends WebViewClient {
    @Override
    public void onPageStarted(WebView view, String url, Bitmap favicon) {
      super.onPageStarted(view, url, favicon);
      mProgressBar.setVisibility(View.VISIBLE);
      if (mMessageChannel != null) {
        JSONObject msg = new JSONObject();
        try {
          msg.put("PageStarted", url);
        } catch (JSONException ignored) {
        }
        mMessageChannel.send(msg.toString());
      }
    }

    @Override
    public void onPageFinished(WebView view, String url) {
      mProgressBar.setVisibility(View.GONE);
      if (mMessageChannel != null) {
        JSONObject msg = new JSONObject();
        try {
          msg.put("PageFinished", url);
        } catch (JSONException ignored) {
        }
        mMessageChannel.send(msg.toString());
      }
      super.onPageFinished(view, url);
    }

    @Override
    public boolean shouldOverrideUrlLoading(WebView view, String url) {
      if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
//        Log.d("FutilsWebManager", "shouldOverrideUrlLoading: " + url);
        if (mMessageChannel != null) {
          JSONObject msg = new JSONObject();
          try {
            msg.put("ShouldOverrideUrl", url);
          } catch (JSONException ignored) {
          }
          mMessageChannel.send(msg.toString());
        }
      }
      return super.shouldOverrideUrlLoading(view, url);
    }

    @Override
    public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//        Log.d("FutilsWebManager", "shouldOverrideUrlLoading: " + request.getUrl().toString());
        if (mMessageChannel != null) {
          JSONObject msg = new JSONObject();
          try {
            msg.put("ShouldOverrideUrl", request.getUrl().toString());
          } catch (JSONException ignored) { }
          mMessageChannel.send(msg.toString());
        }
      }
      return super.shouldOverrideUrlLoading(view, request);
    }
  }

  private final class ChromeClient extends WebChromeClient {
    @Override
    public void onReceivedTitle(WebView view, String title) {
      super.onReceivedTitle(view, title);
      final String regexA = "^([hH][tT]{2}[pP]://|[hH][tT]{2}[pP][sS]://)(([A-Za-z0-9-~]+).)+([A-Za-z0-9-~\\/])+$";
      final String regexB = "^(([A-Za-z0-9-~]+).)+([A-Za-z0-9-~\\/])+$";
      final Pattern patternA = Pattern.compile(regexA);
      final Pattern patternB = Pattern.compile(regexB);
      if (!patternA.matcher(title).matches() && !patternB.matcher(title).matches()) {
      }
    }
  }

  void launchUrl(MethodCall call, MethodChannel.Result result) {
    final Activity activity = mActivity == null ? null : mActivity.get();
    if (activity == null) {
      result.success("Activity is null");
      return;
    }

    final ViewParent parent = mWebViewContainer.getParent();
    if (parent == null) {
      FrameLayout.LayoutParams params = buildLayoutParams(call);
//      Log.d("FutilsWebManager", "LayoutParams: " + params.width + "," + params.height);
      activity.addContentView(mWebViewContainer, params);
    }

    final String url = call.argument("url");
//    Log.d("FutilsWebManager", "launchUrl: " + url);
    mWebView.loadUrl(url);
    result.success(url);
  }

  void close(MethodCall call, MethodChannel.Result result) {
    final ViewParent parent = mWebViewContainer.getParent();
    if (parent instanceof ViewGroup) {
      final ViewGroup vg = (ViewGroup) parent;
      vg.removeView(mWebViewContainer);
    }
    result.success("closed");
    closed = true;
  }

  private FrameLayout.LayoutParams buildLayoutParams(MethodCall call) {
    final Activity activity = mActivity == null ? null : mActivity.get();
    if (activity == null) {
      return new FrameLayout.LayoutParams(
          FrameLayout.LayoutParams.MATCH_PARENT,
          FrameLayout.LayoutParams.MATCH_PARENT
      );
    }

    Map<String, Number> rc = call.argument("rect");
    FrameLayout.LayoutParams params;
    if (rc != null) {
      params = new FrameLayout.LayoutParams(
          dp2px(activity, rc.get("width").intValue()),
          dp2px(activity, rc.get("height").intValue()));
      params.setMargins(dp2px(activity, rc.get("left").intValue()),
          dp2px(activity, rc.get("top").intValue()),
          0, 0);
    } else {
      DisplayMetrics dm = new DisplayMetrics();
      Display display = activity.getWindowManager().getDefaultDisplay();
      display.getMetrics(dm);
      params = new FrameLayout.LayoutParams(dm.widthPixels, dm.heightPixels);
    }
    return params;
  }

  private int dp2px(Context context, float dp) {
    final float scale = context.getResources().getDisplayMetrics().density;
    return (int) (dp * scale + 0.5f);
  }
}
