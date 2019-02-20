package com.example.simplestephistory

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.fitness.Fitness
import com.google.android.gms.fitness.FitnessOptions

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import com.google.android.gms.fitness.data.DataType
import com.google.android.gms.fitness.request.DataReadRequest
import com.google.android.gms.fitness.result.DataReadResponse
import com.google.android.gms.tasks.Tasks
import io.flutter.plugin.common.PluginRegistry
import java.text.SimpleDateFormat
import java.text.DateFormat
import java.util.*
import java.util.concurrent.TimeUnit

class SimpleStepHistoryPlugin(private val activity: Activity): MethodCallHandler, PluginRegistry.ActivityResultListener {

  companion object {

    const val GOOGLE_FIT_PERMISSIONS_REQUEST_CODE = 1

        val dataType: DataType = DataType.TYPE_STEP_COUNT_DELTA
        val aggregatedDataType: DataType = DataType.AGGREGATE_STEP_COUNT_DELTA

        val TAG = SimpleStepHistoryPlugin::class.java.simpleName
    
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val plugin = SimpleStepHistoryPlugin(registrar.activity())
      registrar.addActivityResultListener(plugin)
      
      val channel = MethodChannel(registrar.messenger(), "simple_step_history")
      channel.setMethodCallHandler(plugin)
    }
  }

  private var deferredResult: Result? = null

  override fun onMethodCall(call: MethodCall, result: Result) {

    when(call.method) {
      "fetchSteps" -> {
        val dateStr: String = call.arguments as String
        getStepsTotal(result, dateStr) 
      }

      "checkStepsAvailability" -> checkStatus(result)

      "requestStepsAuthorization" -> connect(result)

        else -> result.notImplemented()

    }

  }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == GOOGLE_FIT_PERMISSIONS_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                recordData { success: Boolean ->
                    Log.i(TAG, "Record data success: $success!")

                    if (success)
                        deferredResult?.success(1)
                    else
                        deferredResult?.success(-1)

                    deferredResult = null
                }
            } else {
                deferredResult?.success(-1)
                deferredResult = null
            }

            return true
        }

        return false
    }

  private fun checkStatus(result: Result) {
    val fitnessOptions = getFitnessOptions()
        if (!GoogleSignIn.hasPermissions(GoogleSignIn.getLastSignedInAccount(activity), fitnessOptions)) {
            result.success(-1)
        } else {
            result.success(1)
        }
  }

  private fun connect(result: Result) {

        val fitnessOptions = getFitnessOptions()

        if (!GoogleSignIn.hasPermissions(GoogleSignIn.getLastSignedInAccount(activity), fitnessOptions)) {
            deferredResult = result

            GoogleSignIn.requestPermissions(
                    activity,
                    GOOGLE_FIT_PERMISSIONS_REQUEST_CODE,
                    GoogleSignIn.getLastSignedInAccount(activity),
                    fitnessOptions)
        } else {
            result.success(1)
        }
    }


  private fun getFitnessOptions() = FitnessOptions.builder()
            .addDataType(dataType, FitnessOptions.ACCESS_READ)
            .build()

  private fun recordData(callback: (Boolean) -> Unit) {
        Fitness.getRecordingClient(activity, GoogleSignIn.getLastSignedInAccount(activity)!!)
                .subscribe(dataType)
                .addOnSuccessListener {
                    callback(true)
                }
                .addOnFailureListener {
                    callback(false)
                }
    }


    private fun getStepsTotal(result: Result, dateStr: String) {

      val gsa = GoogleSignIn.getAccountForExtension(activity, getFitnessOptions())
      
      val startCal = GregorianCalendar()
	    val sdf = SimpleDateFormat("yyyy-MM-dd")
	    startCal.setTime(sdf.parse(dateStr))// all done
    
      val endCal = GregorianCalendar(
                    startCal.get(Calendar.YEAR),
                    startCal.get(Calendar.MONTH),
                    startCal.get(Calendar.DAY_OF_MONTH),
                    23,
                    59)
                    Log.d(TAG, "buckets count : ${endCal.toString()}")

      val request = DataReadRequest.Builder()
                      .aggregate(dataType, aggregatedDataType)
                      .bucketByTime(1, TimeUnit.DAYS)
                      .setTimeRange(startCal.timeInMillis, endCal.timeInMillis, TimeUnit.MILLISECONDS)
                      .build()
      
      val response = Fitness.getHistoryClient(activity, gsa).readData(request)

      val dateFormat = DateFormat.getDateInstance()
      val dayString = dateFormat.format(Date(startCal.timeInMillis))

      Thread {

        try {

          val readDataResult = Tasks.await<DataReadResponse>(response)
          Log.d(TAG, "buckets count : ${readDataResult.buckets.size}")

          if (!readDataResult.buckets.isEmpty()) {
            val dp = readDataResult.buckets[0].dataSets[0].dataPoints[0]
            val count = dp.getValue(aggregatedDataType.fields[0])

            Log.d(TAG, "returning $count steps for $dayString")
            
            result.success(count.asInt())
            
          } else {
            result.success(-2)
          }
          
        } catch(e: Throwable) {
          Log.d(TAG, "${e.toString()}")
          result.success(-1)
        }

      }.start()
    }
}
