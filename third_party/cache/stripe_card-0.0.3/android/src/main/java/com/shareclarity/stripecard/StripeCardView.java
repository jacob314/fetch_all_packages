package com.shareclarity.stripecard;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.stripe.android.Stripe;
import com.stripe.android.TokenCallback;
import com.stripe.android.model.Token;
import com.stripe.android.view.CardInputWidget;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformView;

import static java.security.AccessController.getContext;

public class StripeCardView implements PlatformView, MethodChannel.MethodCallHandler {
    public final MethodChannel methodChannel;
    private Context context;
    private View mView;
    private CardInputWidget mCardInputWidget;
    String publishKey;
    Map<String, Object> info;
    private PluginRegistry.Registrar registrar;
    StripeCardView(Context _context, BinaryMessenger messenger, int id, Object object, PluginRegistry.Registrar registrar) {
        context = _context;
        methodChannel = new MethodChannel(messenger, "stripe_card_" + id);
        this.registrar = registrar;
        methodChannel.setMethodCallHandler(this);
        info = (Map<String, Object>)object;
        publishKey = (String)info.get("publishKey");
    }

    @Override
    public View getView() {
        LinearLayout linearLayout = new LinearLayout(context);
        FrameLayout rootView = (FrameLayout)registrar.activity().getWindow().getDecorView().getRootView();
        mView = StripeCardPlugin.mActivity.getLayoutInflater().inflate(R.layout.layout_card,null);
        mCardInputWidget = (CardInputWidget) mView.findViewById(R.id.card_input_widget);
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.WRAP_CONTENT
        );
        params.setMargins((int)info.get("left"), (int)info.get("top"), (int)info.get("right"), (int)info.get("bottom"));
        mView.setLayoutParams(params);
        rootView.addView(mView);
        return rootView;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, final MethodChannel.Result result) {
        switch (methodCall.method) {
            case "validate":
                if (mCardInputWidget.getCard() == null) {
                    result.success(false);
                } else {
                    if (!mCardInputWidget.getCard().validateCard()) {
                        result.success(false);
                    } else {
                        result.success(true);
                    }
                }
                break;
            case "createToken":
                Stripe stripe = new Stripe(context, publishKey);
                stripe.createToken(
                        mCardInputWidget.getCard(),
                        new TokenCallback() {
                            public void onSuccess(Token token) {
                                // Send token to your server
                                result.success(token.getId());
                            }
                            public void onError(Exception error) {
                                // Show localized error message
                                result.success(null);
                            }
                        }
                );
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void dispose() {

    }
}
