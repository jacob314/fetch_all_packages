package com.cloudsoft.simservice;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

import io.flutter.plugin.common.PluginRegistry.Registrar;



/** SimServicePlugin */
public class SimServicePlugin  implements MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {
    private final Registrar mRegistrar;
    static Context context;
    private Result result;
    private MethodCall call;

    private static final String GET_SIM_INFO = "getSimInfo";
    private static final String HAS_READ_PERMISSION = "hasReadPermission";
    private static final String REQUEST_READ_PERMISSION = "requestReadPermission";

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
//        final MethodChannel channel = new MethodChannel(registrar.messenger(), "sim_service");
//        channel.setMethodCallHandler(new SimServicePlugin(registrar));
//
//        registrar.addRequestPermissionsResultListener(SimServicePlugin);
//

        final MethodChannel channel = new MethodChannel(registrar.messenger(), "sim_service");
        SimServicePlugin simServicePlugin = new SimServicePlugin(registrar);
        channel.setMethodCallHandler(simServicePlugin);
        registrar.addRequestPermissionsResultListener(simServicePlugin);

    }
    private  SimServicePlugin(Registrar registrar){
        mRegistrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result)  {


        String permission = "READ_PHONE_STATE";

        permission=  getManifestPermission(permission);
        if(checkPermission(permission)){
            result.success(getSimData(call, result).toString());
        }else {
            this.result = result;
            this.call = call;
            requestPermission(permission);
        }

//
//          if(call.method =="getSimDataPerm"){
//              Log.e("getSimDataPerm:","we are getting sim Data permassions");
//
//            result.success(gettingSimDataPerm());
//        }
//         else if(call.method =="getSimData"){
//                  Log.e("getSimData:","we are getting sim Data");
//                result.success( getSimData(call, result).toString());
//         }

    }
   private boolean gettingSimDataPerm(){
       Log.e("Getting Perm","ccccc");
       String permission = "READ_PHONE_STATE";
       boolean permainsionGranted = false;
        try{
            permission =  getManifestPermission(permission);
            if(checkPermission(permission) == false){
                 requestPermission(permission);
                 permainsionGranted = checkPermission(permission);
            }else if(checkPermission(permission) ==true) {
                 permainsionGranted = true;
            }
        } catch (Throwable r){
            Log.i("SimService", "Requesting problem : " + r);
        }
        return permainsionGranted;
    }



    private  JSONObject getSimData(MethodCall call, Result result) {

        Log.e("Getting Perm","1111111111");
       JSONObject  mainSimData = null;
            context = mRegistrar.context();
            // Get Sim Data -----------------------------------------------------------


            TelephonyManager manager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);

            // dual SIM detection with SubscriptionManager API
            // requires API 22
            // requires permission READ_PHONE_STATE
            JSONArray sims = null;
            Integer phoneCount = null;
            Integer activeSubscriptionInfoCount = null;
            Integer activeSubscriptionInfoCountMax = null;

            try {
                // TelephonyManager.getPhoneCount() requires API 23
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                    phoneCount = manager.getPhoneCount();
                }

                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP_MR1) {



                    SubscriptionManager subscriptionManager = (SubscriptionManager) context.getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE);
                    activeSubscriptionInfoCount = subscriptionManager.getActiveSubscriptionInfoCount();
                    activeSubscriptionInfoCountMax = subscriptionManager.getActiveSubscriptionInfoCountMax();

                    sims = new JSONArray();

                    List<SubscriptionInfo> subscriptionInfos = subscriptionManager.getActiveSubscriptionInfoList();
                    for (SubscriptionInfo subscriptionInfo : subscriptionInfos) {

                        CharSequence carrierName = subscriptionInfo.getCarrierName();
                        String countryIso = subscriptionInfo.getCountryIso();
                        int dataRoaming = subscriptionInfo.getDataRoaming();  // 1 is enabled ; 0 is disabled
                        CharSequence displayName = subscriptionInfo.getDisplayName();
                        String iccId = subscriptionInfo.getIccId();
                        int mcc = subscriptionInfo.getMcc();
                        int mnc = subscriptionInfo.getMnc();
                        String number = subscriptionInfo.getNumber();
                        int simSlotIndex = subscriptionInfo.getSimSlotIndex();
                        int subscriptionId = subscriptionInfo.getSubscriptionId();

                        boolean networkRoaming = subscriptionManager.isNetworkRoaming(simSlotIndex);

                        String deviceId = null;
                        // TelephonyManager.getDeviceId(slotId) requires API 23
                        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                            deviceId = manager.getDeviceId(simSlotIndex);
                        }

                        JSONObject simData = new JSONObject();

                        simData.put("carrierName", carrierName.toString());
                        simData.put("displayName", displayName.toString());
                        simData.put("countryCode", countryIso);
                        simData.put("mcc", mcc);
                        simData.put("mnc", mnc);
                        simData.put("isNetworkRoaming", networkRoaming);
                        simData.put("isDataRoaming", (dataRoaming == 1));
                        simData.put("simSlotIndex", simSlotIndex);
                        simData.put("phoneNumber", number);
                        if (deviceId != null) {
                            simData.put("deviceId", deviceId);
                        }
                        simData.put("simSerialNumber", iccId);
                        simData.put("subscriptionId", subscriptionId);

                        sims.put(simData);

                    }
                }

            } catch (JSONException e) {
                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }

            String phoneNumber = null;
            String countryCode = manager.getSimCountryIso();
            String simOperator = manager.getSimOperator();
            String carrierName = manager.getSimOperatorName();

            String deviceId = null;
            String deviceSoftwareVersion = null;
            String simSerialNumber = null;
            String subscriberId = null;

            int callState = manager.getCallState();
            int dataActivity = manager.getDataActivity();
            int networkType = manager.getNetworkType();
            int phoneType = manager.getPhoneType();
            int simState = manager.getSimState();

            boolean isNetworkRoaming = manager.isNetworkRoaming();

            try {


                phoneNumber = manager.getLine1Number();
                deviceId = manager.getDeviceId();
                deviceSoftwareVersion = manager.getDeviceSoftwareVersion();
                simSerialNumber = manager.getSimSerialNumber();
                subscriberId = manager.getSubscriberId();


                String mcc = "";
                String mnc = "";

                if (simOperator.length() >= 3) {
                    mcc = simOperator.substring(0, 3);
                    mnc = simOperator.substring(3);
                }

                JSONObject jsonObject = new JSONObject();

                jsonObject.put("carrierName", carrierName);
                jsonObject.put("countryCode", countryCode);
                jsonObject.put("mcc", mcc);
                jsonObject.put("mnc", mnc);

                jsonObject.put("callState", callState);
                jsonObject.put("dataActivity", dataActivity);
                jsonObject.put("networkType", networkType);
                jsonObject.put("phoneType", phoneType);
                jsonObject.put("simState", simState);

                jsonObject.put("isNetworkRoaming", isNetworkRoaming);

                if (phoneCount != null) {
                    jsonObject.put("phoneCount", (int) phoneCount);
                }
                if (activeSubscriptionInfoCount != null) {
                    jsonObject.put("activeSubscriptionInfoCount", (int) activeSubscriptionInfoCount);
                }
                if (activeSubscriptionInfoCountMax != null) {
                    jsonObject.put("activeSubscriptionInfoCountMax", (int) activeSubscriptionInfoCountMax);
                }

                jsonObject.put("phoneNumber", phoneNumber);
                jsonObject.put("deviceId", deviceId);
                jsonObject.put("deviceSoftwareVersion", deviceSoftwareVersion);
                jsonObject.put("simSerialNumber", simSerialNumber);
                jsonObject.put("subscriberId", subscriberId);


                if (sims != null && sims.length() != 0) {
                    jsonObject.put("cards", sims);

                }
                Log.i("Sim Service", "we got the sim data" + jsonObject);
                mainSimData = jsonObject;


            }catch (Exception e){
                e.getMessage();
            }
            // End of get Sim data
        return mainSimData;
    }

    private String getManifestPermission(String permission) {
        String res;
        res = Manifest.permission.READ_PHONE_STATE;
        return res;
    }
    private void requestPermission(String permission) {
        Activity activity = mRegistrar.activity();
        permission = getManifestPermission(permission);
        Log.i("SimService", "Requesting permission : " + permission);
        String[] perm = {permission};
        ActivityCompat.requestPermissions(activity, perm, 0);


    }
    private boolean checkPermission(String permission) {
        Activity activity = mRegistrar.activity();
        permission = getManifestPermission(permission);
        Log.i("SimService ", "Checking permission : " + permission);
        return PackageManager.PERMISSION_GRANTED == ContextCompat.checkSelfPermission(activity, permission);
    }


    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] strings, int[] grantResults) {
       // super.onRequestPermissionsResult(requestCode, strings, grantResults);
        Log.i("SimplePermission", "we are in the on requestPermissions ");
        boolean res = false;
        if (requestCode == 0 && grantResults.length > 0) {
            res = grantResults[0] == PackageManager.PERMISSION_GRANTED;
            Log.i("SimplePermission", "Requesting permission result : " + res);
            result.success(getSimData(call, result).toString());
        }else{
            result.error("Cant access sim data","Cant access sim data",false);
        }
        // result.error("Cant access sim data","Cant access sim data",false);
        return res;
    }




}