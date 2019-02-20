package in.altsoul.razorpaycheckout;

import android.app.Activity;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import org.json.JSONObject;
import com.razorpay.Checkout;

/** RazorpayCheckoutPlugin */
public class RazorpayCheckoutPlugin implements MethodCallHandler {
  private Activity activity;
  private Checkout checkout = new Checkout();
  private JSONObject options = new JSONObject();
  private JSONObject preFill = new JSONObject();

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "razorpay_checkout");
    channel.setMethodCallHandler(new RazorpayCheckoutPlugin(registrar.activity()));
  }

  private RazorpayCheckoutPlugin(Activity activity) {
    this.activity = activity;
  }

  private void prefillCheckout(MethodCall call) {

    try {
      preFill.put("email", call.argument("email"));
      preFill.put("contact", call.argument("contact"));

      options.put("amount", call.argument("amount"));
      options.put("prefill", preFill);

      this.checkout.open(activity, options);
    } catch (Exception e){
      Log.e("RZP", "ERR");
    }
  }

  private void showCheckout() {

  }

  private void clearCheckout() {
    this.preFill = new JSONObject();
    this.options = new JSONObject();
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("showCheckout")) {
      try {
        this.prefillCheckout(call);
        this.showCheckout();
        result.success("Android " + android.os.Build.VERSION.RELEASE);
      } catch (Exception e) {
        Log.e("RazorPayCheckout", e.getMessage());
      }
    } else {
      result.notImplemented();
    }
  }
}
