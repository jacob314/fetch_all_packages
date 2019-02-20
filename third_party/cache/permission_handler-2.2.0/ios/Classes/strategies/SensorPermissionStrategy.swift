//
//  SensorPermissions.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//

import CoreMotion
import Foundation

class SensorPermissionStrategy : NSObject, PermissionStrategy {
    
    func checkPermissionStatus(permission: PermissionGroup) -> PermissionStatus {
        return SensorPermissionStrategy.getPermissionStatus()
    }
    
    private static func getPermissionStatus() -> PermissionStatus {
        if #available(iOS 11.0, *) {
            let status: CMAuthorizationStatus = CMMotionActivityManager.authorizationStatus()
            var permissionStatus: PermissionStatus
            
            switch status {
            case CMAuthorizationStatus.authorized:
                permissionStatus = PermissionStatus.granted
            case CMAuthorizationStatus.denied:
                permissionStatus = PermissionStatus.denied
            case CMAuthorizationStatus.restricted:
                permissionStatus = PermissionStatus.restricted
            default:
                permissionStatus = PermissionStatus.unknown
            }
            
            if (permissionStatus == PermissionStatus.granted || permissionStatus == PermissionStatus.denied) && !CMMotionActivityManager.isActivityAvailable() {
                return PermissionStatus.disabled
            } else {
                return permissionStatus
            }
        }
        
        return PermissionStatus.unknown
    }
    
    func checkServiceStatus(permission: PermissionGroup) -> ServiceStatus {
        if #available(iOS 11.0, *) {
            return CMMotionActivityManager.isActivityAvailable()
                ? ServiceStatus.enabled
                : ServiceStatus.disabled
        }
        
        return ServiceStatus.unknown
    }
    
    func requestPermission(permission: PermissionGroup, completionHandler: @escaping PermissionStatusHandler) {
        let status = checkPermissionStatus(permission: permission)
        
        if status != PermissionStatus.unknown {
            completionHandler(status)
            return
        }
        
        if #available(iOS 11.0, *) {
            let motionManager = CMMotionActivityManager.init()
            
            motionManager.startActivityUpdates(to: OperationQueue.main) { (_) in
                motionManager.stopActivityUpdates()
                
                completionHandler(.granted)
            }
        } else {
            completionHandler(.unknown)
        }
    }
}
