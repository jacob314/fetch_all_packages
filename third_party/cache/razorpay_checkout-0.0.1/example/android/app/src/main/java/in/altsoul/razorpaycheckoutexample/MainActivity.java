package in.altsoul.razorpaycheckoutexample;

import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.razorpay.PaymentResultListener;
import com.razorpay.Checkout;

public class MainActivity extends FlutterActivity implements PaymentResultListener {
  private String TAG = "RazaorPayCheckout";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Checkout.preload(getApplicationContext());
    GeneratedPluginRegistrant.registerWith(this);
  }


  @Override
  public void onPaymentSuccess(String razorpayPaymentID) {
    Toast.makeText(this, "Payment Successful: " + razorpayPaymentID, Toast.LENGTH_SHORT).show();
    Log.d(TAG, razorpayPaymentID);
  }

  @Override
  public void onPaymentError(int code, String error) {
      Log.e(TAG, code + ": " + error);
  }
}
