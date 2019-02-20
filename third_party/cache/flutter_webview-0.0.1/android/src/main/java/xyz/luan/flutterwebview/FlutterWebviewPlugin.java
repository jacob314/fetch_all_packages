package xyz.luan.flutterwebview;

import android.app.Activity;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.FrameLayout;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutterWebviewPlugin implements MethodCallHandler {

    private static final String CLOSE_BUTTON_TEXT = "Close!";
    private final Activity activity;
    private WebView webView;
    private Button closeButton;

    private FlutterWebviewPlugin(Activity activity) {
        this.activity = activity;
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_webview");
        channel.setMethodCallHandler(new FlutterWebviewPlugin(registrar.activity()));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("launch")) {
            String url = call.argument("url").toString();
            FrameLayout.LayoutParams params = buildLayoutParams();

            webView = new WebView(activity);
            WebViewClient webViewClient = new WebViewClient();
            webView.setWebViewClient(webViewClient);
            webView.getSettings().setJavaScriptEnabled(true);
            webView.loadUrl(url);
            activity.addContentView(webView, params);

            closeButton = new Button(activity.getApplicationContext());
            closeButton.setText(CLOSE_BUTTON_TEXT);
            closeButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    ViewGroup vg = (ViewGroup) (FlutterWebviewPlugin.this.webView.getParent());
                    vg.removeView(FlutterWebviewPlugin.this.webView);
                    vg.removeView(FlutterWebviewPlugin.this.closeButton);
                }
            });
            activity.addContentView(closeButton, new FrameLayout.LayoutParams(200, 200));
            result.success("Opened url: " + url);
        } else {
            result.notImplemented();
        }
    }

    private FrameLayout.LayoutParams buildLayoutParams() {
        DisplayMetrics size = new DisplayMetrics();
        activity.getWindowManager().getDefaultDisplay().getRealMetrics(size);
        return new FrameLayout.LayoutParams(size.widthPixels, size.heightPixels);
    }
}
