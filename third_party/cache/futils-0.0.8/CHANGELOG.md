## 0.0.8

* Update(Fix) SinPoints.


## 0.0.7

* Update(Fix) FWebView launchUrlInWebView.


## 0.0.6

+ FWebView add launchUrlInWidget method.
    + FWebView.launchUrlInWidget(BuildContext context, String url, {MessageChannelCallback messageCallback,});


## 0.0.5

* FWebView remove Toolbar.


## 0.0.4

* FWebView add ProgressBar, on page started show, on page finished hide.

## 0.0.3

+ Add onPageStarted、onPageFinished message in BasicMessageChannel.
+ FWebView:
	+ FWebView.setMessageChannelCallback(void callback(String message));
    	+ {"ShouldOverrideUrl","https://github.com"}
    	+ {"PageStarted","https://github.com"}
    	+ {"PageFinished","https://github.com"}
	+ FWebView.launchUrlInWebView(String url);
	+ FWebView.closeWebView();

## 0.0.2

* Append FWebViewWidget.
* FWebView.setMessageChannelCallback(void callback(String message));
* FWebView.launchUrlInWebView(String url);
* FWebView.closeWebView();


## 0.0.1

* Init Utils.
