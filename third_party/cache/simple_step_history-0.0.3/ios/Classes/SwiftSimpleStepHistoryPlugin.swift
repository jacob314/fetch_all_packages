import Flutter
import UIKit
import CoreMotion

public class SwiftSimpleStepHistoryPlugin: NSObject, FlutterPlugin {
    
    var _result: FlutterResult?
    let pedometer = CMPedometer()
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "simple_step_history", binaryMessenger: registrar.messenger())
        let instance = SwiftSimpleStepHistoryPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let res = _result {
            res(FlutterError(code: "multiple_request",
                             message: "Cancelled by second request",
                             details: nil))
            _result = nil
        }
        
        if (call.method == "fetchSteps") {
            _result = result
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-MM-dd"
            if let dateStr = call.arguments as? String,
                let date = fmt.date(from: dateStr) {
                fetchSteps(for: date)
            } else {
                sendRes(count: 0)
            }
        } else if(call.method == "checkStepsAvailability") {
            if #available(iOS 11.0, *) {
                let status = CMPedometer.authorizationStatus()
                result(status == CMAuthorizationStatus.authorized)
            } else if #available(iOS 9.0, *) {
                result(CMSensorRecorder.isAuthorizedForRecording())
            } else {
                result(false)   // Fallback on earlier versions
            }
        } else if(call.method == "requestStepsAuthorization") {
            _result = result
            fetchSteps(for: Date())
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    private func fetchSteps(for date: Date) {
        pedometer
            .queryPedometerData(from: date.startOfDay,
                                to: date.endOfDay) {
                                    [weak self] (data, error) in
                                    let count = data?.numberOfSteps ?? NSNumber(value: -1)
                                    self?.sendRes(count: count.intValue)
                                    
        }
    }
    
    private func sendRes(count: Int) {
        guard let res = self._result else { return }
        res(count)
        _result = nil
    }
}


extension Date {
    
    var startOfDay : Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
    
    var endOfDay : Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }
}
