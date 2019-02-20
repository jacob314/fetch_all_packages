package com.yourcompany.admob;


import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import android.support.design.widget.CoordinatorLayout;
import android.text.AndroidCharacter;
import android.view.LayoutInflater;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.app.FlutterActivity;

import com.google.android.gms.ads.InterstitialAd;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.AdSize;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.ViewGroup;


public class AdmobPlugin extends AppCompatActivity implements MethodCallHandler {

    public static Context context;
    static String APP_ID = "YOUR_ADMOB_APP_ID";
    String AD_UNIT_ID = "YOUR AD UNIT ID";
    String DEVICE_ID = "";
    Boolean TESTING = true;
    String PLACEMENT = "";

    public static Activity activity;

    @Override
    public void onCreate(Bundle instance){
        super.onCreate(instance);
        setContentView(getWindow().getDecorView().getRootView());
    }

    public static void registerWith(Registrar registrar) {
        context = registrar.activity().getApplicationContext();
        activity = registrar.activity();

        final MethodChannel channel = new MethodChannel(registrar.messenger(), "admob");
        channel.setMethodCallHandler(new AdmobPlugin());
    }

    String arguments;
    @Override
    public void onMethodCall(MethodCall call, Result result) {
        System.out.print("PRINTOUT: SJSKJKSJ");
        arguments = call.arguments();

        if(call.method.equals("loadInterstitial")) {
            List<String> list = new ArrayList<String>(Arrays.asList(arguments.split(",")));
            APP_ID = list.get(0);
            AD_UNIT_ID = list.get(1);
            DEVICE_ID = list.get(2);
            TESTING = Boolean.parseBoolean(list.get(3));
            onLoad(context);
            loadInterstitial();
            result.success("Loaded Interstitial Successfully");
        }

        if(call.method.equals("showInterstitial"))
        {
            if (mInterstitialAd.isLoaded()) {
                mInterstitialAd.show();
                result.success(true);
            }else{result.success(false);}
        }

        if(call.method.equals("showBanner")) {
            List<String> list = new ArrayList<String>(Arrays.asList(arguments.split(",")));
            APP_ID = list.get(0);
            AD_UNIT_ID = list.get(1);
            DEVICE_ID = list.get(2);
            TESTING = Boolean.parseBoolean(list.get(3));
            PLACEMENT = list.get(4);
            onLoad(context);
            createAndLoadBanner();
            result.success("Showing"+PLACEMENT);
        }

        if(call.method.equals("closeBanner")) {
            result.success(true);
        }
    }

    public static void onLoad(Context context)
    {
        MobileAds.initialize(context, APP_ID);
    }

    public InterstitialAd mInterstitialAd;
    public void loadInterstitial()
    {
        if(TESTING){AD_UNIT_ID = "ca-app-pub-3940256099942544/1033173712";}
        mInterstitialAd = new InterstitialAd(context);
        mInterstitialAd.setAdUnitId(AD_UNIT_ID);

        final AdRequest.Builder adRequestBuilder = new AdRequest.Builder();
        if(DEVICE_ID != ""){adRequestBuilder.addTestDevice(DEVICE_ID);}

        mInterstitialAd.loadAd(adRequestBuilder.build());

        mInterstitialAd.setAdListener(new AdListener() {
            @Override
            public void onAdClosed() {
                mInterstitialAd.loadAd(adRequestBuilder.build());
            }
        });
    }

    AdView mAdView;
    public void createAndLoadBanner() {
        LayoutInflater factory = LayoutInflater.from(this);
        View myView = factory.inflate(R.layout.layout, null);

        activity.addContentView(myView, new CoordinatorLayout.LayoutParams(400, 200));

        if (TESTING) {AD_UNIT_ID = "ca-app-pub-3940256099942544/6300978111";}
        //mAdView = (AdView) findViewById(R.id.adView2);
        //mAdView.setAdUnitId(AD_UNIT_ID);
       // AdRequest.Builder adRequest = new AdRequest.Builder();
        //if (DEVICE_ID != "") {adRequest.addTestDevice(DEVICE_ID);}
        //mAdView.loadAd(adRequest.build());
    }

    public void showBanner() {

    }

/*
  CGRect initialBannerPosition;
  CGRect initialViewPosition;

- (void)showBanner:(UIView *)banner Place:(NSString *)Position{

    initialViewPosition = [UIApplication sharedApplication].keyWindow.rootViewController.view.frame;
    CGRect mainFrame = [UIApplication sharedApplication].keyWindow.rootViewController.view.frame;

    int adjustment = 0;

    if([Position  isEqual: @"Top"]){
      CGRect frameRect = banner.frame;
      frameRect.origin.y = 0 - (banner.frame.size.height * 1);
      banner.frame = frameRect;
      initialBannerPosition = banner.frame;
      adjustment = banner.frame.size.height + 18.0;
    }
    else if([Position isEqual: @"Bottom"]){
      CGRect frameRect = banner.frame;
      frameRect.origin.y = [UIApplication sharedApplication].keyWindow.rootViewController.view.frame.size.height;
      banner.frame = frameRect;
      initialBannerPosition = banner.frame;
      adjustment = banner.frame.size.height * -1;
      mainFrame.size.height += adjustment;
    }

    if (banner && [banner isHidden]) {
      banner.hidden = NO;
        [UIView animateWithDuration:0.8 animations:^{
        banner.frame = CGRectOffset(banner.frame, 0, adjustment);
            [UIApplication sharedApplication].keyWindow.rootViewController.view.frame = CGRectOffset(mainFrame, 0, 0);
      } completion:^(BOOL finished) {
        //code for completion
      }];
    }
  }

-(void)closeBanner:(UIView *)banner{
    [UIView animateWithDuration:0.8 animations:^{
      banner.frame = initialBannerPosition;
        [UIApplication sharedApplication].keyWindow.rootViewController.view.frame = initialViewPosition;
    } completion:^(BOOL finished) {
      //code for completion
    }];
  }*/

}