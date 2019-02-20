import Flutter
import UIKit
import com_awareframework_ios_sensor_significantmotion
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkSignificantmotionPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, SignificantMotionObserver{

    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                self.significantMotionSensor = SignificantMotionSensor.init(SignificantMotionSensor.Config(config))
            }else{
                self.significantMotionSensor = SignificantMotionSensor.init(SignificantMotionSensor.Config())
            }
            self.significantMotionSensor?.CONFIG.sensorObserver = self
            return self.significantMotionSensor
        }else{
            return nil
        }
    }

    var significantMotionSensor:SignificantMotionSensor?

    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftAwareframeworkSignificantmotionPlugin()
        super.setMethodChannel(with: registrar, instance: instance, channelName: "awareframework_significantmotion/method")
        super.setEventChannels(with: registrar, instance: instance, channelNames:
            ["awareframework_significantmotion/event",
            "awareframework_significantmotion/event_on_significant_motion_start",
            "awareframework_significantmotion/event_on_significant_motion_end"]);
    }

    public func onSignificantMotionStart() {
        for handler in self.streamHandlers {
            if handler.eventName == "on_significant_motion_start" {
                handler.eventSink(nil)
            }
        }
    }
    
    public func onSignificantMotionEnd() {
        for handler in self.streamHandlers {
            if handler.eventName == "on_significant_motion_end" {
                handler.eventSink(nil)
            }
        }
    }
}
