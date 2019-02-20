package in.appyflow.geofire;

import android.view.View;
import android.widget.Toast;

import com.firebase.geofire.GeoFire;
import com.firebase.geofire.GeoLocation;
import com.firebase.geofire.GeoQuery;
import com.firebase.geofire.GeoQueryEventListener;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.util.ArrayList;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** GeofirePlugin */
public class GeofirePlugin implements MethodCallHandler {

    GeoFire geoFire;
    DatabaseReference databaseReference;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "geofire");
    channel.setMethodCallHandler(new GeofirePlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }
    if (call.method.equals("getQuery")) {

      databaseReference = FirebaseDatabase.getInstance().getReference("Sites");
      geoFire = new GeoFire(databaseReference);

      geoFireArea(Double.parseDouble(call.argument("lat").toString()),Double.parseDouble(call.argument("lng").toString()),result);


//      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }



  private void geoFireArea(double latitude, double longitude,final Result result) {
    try {
//            Log.i("test", "pickuplatlngtest : " + latitude + " - " + longitude);

      final ArrayList<String > stringBuffer=new ArrayList<>();
      final GeoQuery geoQuery = geoFire.queryAtLocation(new GeoLocation(latitude, longitude), 5000);
      geoQuery.addGeoQueryEventListener(new GeoQueryEventListener() {
        @Override
        public void onKeyEntered(String key, GeoLocation location) {
//                    Log.i("test", "key: " + key + " - location: " + location);
          stringBuffer.add(key);
        }

        @Override
        public void onKeyExited(String key) {
        }

        @Override
        public void onKeyMoved(String key, GeoLocation location) {
        }

        @Override
        public void onGeoQueryReady() {
          geoQuery.removeAllListeners();
          result.success(stringBuffer);
        }

        @Override
        public void onGeoQueryError(DatabaseError error) {
//                    Log.i("test", "onGeoQueryError : " + error.toString());
        }
      });
    } catch (Exception e) {
      e.printStackTrace();
//            Log.i("test", e.toString());
    }
  }

}