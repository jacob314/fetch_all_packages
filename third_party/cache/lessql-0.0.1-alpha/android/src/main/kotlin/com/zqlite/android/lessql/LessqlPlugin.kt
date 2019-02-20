package com.zqlite.android.lessql

import android.app.Activity
import android.os.Handler
import android.os.HandlerThread
import android.widget.Toast
import com.amitshekhar.DebugDB
import com.zqlite.android.lessql.db.DBInfo
import com.zqlite.android.lessql.db.InsertHelper
import com.zqlite.android.lessql.db.LesDBOpenHelper
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar
import org.json.JSONObject

class LessqlPlugin(val activity: Activity,val methodChannel: MethodChannel) : MethodCallHandler {

    val TAG: String = "LesSql"

    private val METHOD_INIT_DB: String = "init_db"
    private val METHOD_INSERT: String = "insert"
    private val METHOD_DB_IP :String = "db_ip"

    private var mDBInfoCache: DBInfo? = null
    private var mLesDBOpenHelper:LesDBOpenHelper? = null

    private var mHandler : Handler? = null



    init {
        val handlerThread = HandlerThread("LesWorker")
        handlerThread.start()
        mHandler = Handler(handlerThread.looper)
    }
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "lessql")
            channel.setMethodCallHandler(LessqlPlugin(registrar.activity(),channel))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        methodChannel.invokeMethod(METHOD_DB_IP,DebugDB.getAddressLog() + " to check your DB")
        when (call.method) {
            METHOD_INIT_DB -> {
                val data = call.arguments
                mDBInfoCache = DBInfo(data as String)
                mLesDBOpenHelper = LesDBOpenHelper(context = activity,name = mDBInfoCache!!.dbName,version = mDBInfoCache!!.dbVersion,factory = null,dbInfo = mDBInfoCache!!)
                val dbInstance = mLesDBOpenHelper!!.readableDatabase
                result.success("init db successful")
                dbInstance.close()
                show(activity,data)
            }

            METHOD_INSERT ->{
                val data = call.arguments
                val insert = InsertHelper(JSONObject(data as String))
                mHandler!!.post {
                    val des = insert.insert(mDBInfoCache!!, mLesDBOpenHelper!!.readableDatabase)
                    result.success(des)
                }
                show(activity,data)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun show(context:Activity,content:String){
        Toast.makeText(activity, content, Toast.LENGTH_LONG).show()
    }
}
