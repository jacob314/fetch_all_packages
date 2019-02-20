package com.github.putraxor.fluttermidtrans

import android.util.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar
import com.midtrans.sdk.corekit.core.themes.CustomColorTheme
import com.midtrans.sdk.corekit.BuildConfig.BASE_URL
import com.midtrans.sdk.corekit.core.LocalDataHandler
import com.midtrans.sdk.corekit.core.MidtransSDK
import com.midtrans.sdk.uikit.SdkUIFlowBuilder
import java.util.*
import com.midtrans.sdk.corekit.core.TransactionRequest
import com.midtrans.sdk.corekit.models.ItemDetails
import kotlin.collections.ArrayList
import com.midtrans.sdk.corekit.models.UserDetail




class FlutterMidtransPlugin : MethodCallHandler {
    companion object {

        private var mRegistrar: Registrar? = null

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            mRegistrar = registrar
            val channel = MethodChannel(registrar.messenger(), "flutter_midtrans")
            channel.setMethodCallHandler(FlutterMidtransPlugin())
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method == "initSdkFlow" -> initSdkFlow(call)
            call.method == "createTransaction" -> createTransaction(call, result)
            else -> result.notImplemented()
        }
    }


    /**
     * Initialize sdk flow
     */
    private fun initSdkFlow(call: MethodCall) {
        val clientKey = call.argument<String>("clientKey")
        val colors = listOf<String>(
                call.argument("primaryColor"),
                call.argument("secondaryColor"),
                call.argument("accentColor")
        )
        SdkUIFlowBuilder.init()
                .setClientKey(clientKey)
                .setContext(mRegistrar?.activity())
                .setMerchantBaseUrl(BASE_URL)
                .enableLog(true)
                .setColorTheme(CustomColorTheme(colors[0], colors[1], colors[2]))
                .buildSDK()
    }


    /**
     * Method prepare transaction
     */
    private fun createTransaction(call: MethodCall, result: Result) {
        val transId = call.argument<String>("transId")
        val amount = call.argument<Double>("amount")
        val items = call.argument<List<Map<String, Objects>>>("items")
        val userDetails = call.argument<Map<String, String>>("user_details")

        if(userDetails!=null){
            val user = UserDetail()
            user.userFullName = userDetails["fullName"]
            user.email = userDetails["email"]
            user.userId = userDetails["uid"]
            LocalDataHandler.saveObject("user_detail", user)
        }

        val transRequest = TransactionRequest(transId, amount)

        val itemDetails = ArrayList<ItemDetails>()
        items.forEach { it ->
            val id = it["id"].toString()
            val name = it["name"].toString()
            val price = it["price"].toString().toInt()
            val quantity = it["quantity"].toString().toInt()
            itemDetails.add(ItemDetails(id, price, quantity, name))
        }
        transRequest.itemDetails = itemDetails
        MidtransSDK.getInstance().transactionRequest = transRequest
        MidtransSDK.getInstance()
                .startPaymentUiFlow(mRegistrar?.activity())
        MidtransSDK.getInstance().setTransactionFinishedCallback {
            Log.d("Midtrans", "Transaction finished $it")
            result.success(mapOf<String, Any>(
                    "transactionId" to it.response.transactionId,
                    "canceled" to it.isTransactionCanceled,
                    "source" to it.source,
                    "status" to it.status,
                    "message" to it.statusMessage
            ))
        }
    }
}
