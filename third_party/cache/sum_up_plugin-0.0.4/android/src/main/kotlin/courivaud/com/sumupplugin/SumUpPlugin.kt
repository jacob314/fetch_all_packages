package courivaud.com.sumupplugin

import android.app.Activity
import android.content.Intent
import com.sumup.merchant.api.SumUpAPI
import com.sumup.merchant.api.SumUpLogin
import com.sumup.merchant.api.SumUpPayment
import com.sumup.merchant.api.SumUpState
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.math.BigDecimal
import java.util.*

class SumUpPlugin: MethodCallHandler{


  companion object : PluginRegistry.ActivityResultListener {

    private val REQUEST_CODE_LOGIN = 1
    private val REQUEST_CODE_PAYMENT = 2
    private val REQUEST_CODE_PAYMENT_SETTINGS = 3

    override fun onActivityResult(requestCode: Int, p1: Int, data: Intent?): Boolean {
        when (requestCode) {

          REQUEST_CODE_LOGIN -> if (data != null) {
            val extra = data.extras
            if (extra?.getInt(SumUpAPI.Response.RESULT_CODE) == SumUpAPI.Response.ResultCode.ERROR_INVALID_TOKEN){
              mResult.error("TOKEN ERROR","Login code error =" + extra!!.getString(SumUpAPI.Response.MESSAGE),null)
            }
            mResult.success("Login code sucess =" + extra!!.getString(SumUpAPI.Response.MESSAGE))

          }

          REQUEST_CODE_PAYMENT -> if (data != null) {
            val extra = data.extras
            mResult.success("Payment code ="+ extra!!.getString(SumUpAPI.Response.MESSAGE))

          }

          REQUEST_CODE_PAYMENT_SETTINGS -> if (data != null) {
            val extra = data.extras
            mResult.success("Setting code ="+ extra!!.getString(SumUpAPI.Response.MESSAGE))

          }

          else -> {
          }

        }

        return true
          }

    lateinit var mActivity : Activity
    lateinit var mResult : Result

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "sum_up_plugin")
      channel.setMethodCallHandler(SumUpPlugin())
      mActivity  = registrar.activity()
      registrar.addActivityResultListener(this)
      SumUpState.init(mActivity)

    }

  }

  override fun onMethodCall(call: MethodCall, result: Result) {

    //Register result object
    mResult = result

    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    }
    if (call.method == "login") {
      val token = call.argument<String>("token")
      val mAffiliateKey = "d1d722ae-806c-4cf8-b8cb-cf31ac51a30f"
      val sumupLogin = SumUpLogin.builder(mAffiliateKey).accessToken(token).build()
      SumUpAPI.openLoginActivity(mActivity, sumupLogin, 1)
    }
    if (call.method == "prepareTransaction") {
      val price = call.argument<String>("totalPrice")
      val payment = SumUpPayment.builder()
              // mandatory parameters
              .total(BigDecimal(price)) // minimum 1.00
              .currency(SumUpPayment.Currency.EUR)
              // optional: add details
              .title("Taxi Ride")
              .receiptEmail("customer@mail.com")
              .receiptSMS("+3531234567890")
              // optional: Add metadata
              .addAdditionalInfo("AccountId", "taxi0334")
              .addAdditionalInfo("From", "Paris")
              .addAdditionalInfo("To", "Berlin")
              // optional: foreign transaction ID, must be unique!
              .foreignTransactionId(UUID.randomUUID().toString()) // can not exceed 128 chars
              .build()

      SumUpAPI.checkout(mActivity, payment, REQUEST_CODE_PAYMENT)

    }
    if (call.method == "paymentPreferences") {
      SumUpAPI.openPaymentSettingsActivity(mActivity, REQUEST_CODE_PAYMENT_SETTINGS)

    }

    if (call.method == "isSumUpTokenValid") {
        if(SumUpAPI.getCurrentMerchant() == null ){
            result.success(false)
        } else {
            result.success(true)
        }
    }

  }
}
