package com.example.flutterpedometer;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;


import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * SensorsPlugin
 */
public class FlutterPedometerPlugin implements EventChannel.StreamHandler {
  private static final String STEP_COUNT_CHANNEL_NAME =
          "flutter_pedometer.eventChannel";

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final EventChannel accelerometerChannel =
            new EventChannel(registrar.messenger(), STEP_COUNT_CHANNEL_NAME);
    accelerometerChannel.setStreamHandler(
            new FlutterPedometerPlugin(registrar.context(), Sensor.TYPE_STEP_COUNTER));
  }

  private SensorEventListener sensorEventListener;
  private final SensorManager sensorManager;
  private final Sensor sensor;

  private FlutterPedometerPlugin(Context context, int sensorType) {
    sensorManager = (SensorManager) context.getSystemService(context.SENSOR_SERVICE);
    sensor = sensorManager.getDefaultSensor(sensorType);
  }

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
    sensorEventListener = createSensorEventListener(events);
    sensorManager.registerListener(sensorEventListener, sensor, sensorManager.SENSOR_DELAY_FASTEST);
  }

  @Override
  public void onCancel(Object arguments) {
    sensorManager.unregisterListener(sensorEventListener);
  }

  SensorEventListener createSensorEventListener(final EventChannel.EventSink events) {
    return new SensorEventListener() {
      @Override
      public void onAccuracyChanged(Sensor sensor, int accuracy) {
      }

      @Override
      public void onSensorChanged(SensorEvent event) {
        int stepCount = (int) event.values[0];
        events.success(stepCount);
      }
    };
  }
}
