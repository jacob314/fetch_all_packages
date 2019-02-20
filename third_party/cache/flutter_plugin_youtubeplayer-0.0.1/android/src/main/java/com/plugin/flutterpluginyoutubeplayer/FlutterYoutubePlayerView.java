package com.plugin.flutterpluginyoutubeplayer;

import android.content.Context;
import android.view.View;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import static io.flutter.plugin.common.MethodChannel.MethodCallHandler;

public class FlutterYoutubePlayerView implements PlatformView, MethodCallHandler {

    private Context context;
    private final MethodChannel methodChannel;
    private VideoEnabledWebView webView;
    private VideoEnabledWebChromeClient webChromeClient;


    FlutterYoutubePlayerView(Context context, BinaryMessenger messenger, int id) {
        this.context = context;

        methodChannel = new MethodChannel(messenger, "plugins.plugin.com/flutterpluginyoutubeplayer_" + id);
        methodChannel.setMethodCallHandler(this);

        webView = new VideoEnabledWebView(context);
        webChromeClient = new VideoEnabledWebChromeClient() {
            @Override
            public void onProgressChanged(WebView view, int progress) {
            }
        };

        webView.setWebChromeClient(webChromeClient);
        webView.setWebViewClient(new InsideWebViewClient());

        // Navigate anywhere you want, but consider that this classes have only been tested on YouTube's mobile site
//        webView.loadUrl("http://m.youtube.com");

        String html = "<html>" +
                "<head>" +
                "<meta charset=\"utf-8\">" +
                "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">" +
                "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">" +
                "<style>body{padding:15px;font-size:200%}img{width:100%}.videoWrapper{position:relative;padding-bottom:56.25%;padding-top:25px;height:0}.videoWrapper iframe{position:absolute;top:0;left:0;width:100%;height:100%}@media screen and (-webkit-min-device-pixel-ratio: 0){body{word-break:break-word}}</style>" +
                "</head>" +
                "<body><p></p><p></p><p></p><p></p><p></p><p></p><p>" +
                "<div class=\"videoWrapper\">" +

                "<iframe src=\"https://www.youtube.com/embed/epO7ECgm62M?rel=0&border=&autoplay=1\" allowfullscreen=\'true\' frameborder=\"0\">" +

                "</iframe>" +
                "</div></p><p><br></p>" +
                "<h2>Title 1 &nbsp;</h2>" +
                "<p>美麗的生命在於能勇於更新，且願意努力學習。像螃蟹脫殼是為了讓自己長得更健壯；而毛<br>毛蟲蛻變為蝴蝶，或是蝌蚪蛻變為青蛙，才使生命煥然一新。e人的一生，也需要蛻變，才能成長。" +
                "<br>每一次蛻變都使生命走進人生的新領域、新境界，使我們獲得新的接觸、 新的感受、新的驚喜。" +
                "<br>周大觀小朋友從小是父母的心肝寶貝，生活過得快樂充實，七歲就會寫詩，到了九歲得到癌" +
                "<br>症，他開始跟病魔戰鬥，接受截肢手術，雖然少了一隻腿，他仍然努力活下去，並且寫好幾首詩，<br>表達自己不向困境低頭的心意。" +
                "<br>後來醫師幫助他做化學治療，使得他全身有刺骨之痛，頭髮掉光、身體軟弱無力，可是大觀<br>仍然勇敢地參加為自己而開的醫療會議，聆聽一生命運無望的判決，還表示能夠接受這樣的結論，" +
                "<br>並向多位醫生叔叔、伯伯道謝，感謝這些日子來辛勞的照顧。<br>這位生命的勇者在十歲時離開人世。可是他並沒有離開我們，因為他留下了另一種生命，就<br>是他的精神和他的詩： ..." +
                "<span id=\"selectionBoundary_1468824201030_4881703862896598\" class=\"rangySelectionBoundary\">\uFEFF</span>" +
                "<span id=\"selectionBoundary_1468824200207_32529137540397257\" class=\"rangySelectionBoundary\">\uFEFF</span><br>" +
                "</p>" +
                "</body>" +
                "</html>\n";

        webView.loadDataWithBaseURL(null, html, "text/html", "utf-8", null);
    }

    private class InsideWebViewClient extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            view.loadUrl(url);
            return true;
        }
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            default:
                result.notImplemented();
        }
    }

    @Override
    public View getView() {
        return webView;
    }

    @Override
    public void dispose() {
    }
}