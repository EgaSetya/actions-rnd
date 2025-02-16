//
//  Device.swift
//  Bythen
//
//  Created by Ega Setya on 07/01/25.
//

import UIKit

class DeviceHelper {
    static let shared = DeviceHelper()
    
    var deviceID: String { UIDevice.current.identifierForVendor?.uuidString ?? "" }
    var deviceName: String { getDeviceTypeName() }
    
    private func getDeviceTypeName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        // Convert utsname.machine to a Swift String, trimming null characters
        let identifier = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(cString: $0)
            }
        }
        
        return mapToDeviceName(identifier: identifier)
    }

    private func mapToDeviceName(identifier: String) -> String {
        let deviceList: [String: String] = [
            "iPhone14,2": "iPhone 13 Pro",
            "iPhone14,3": "iPhone 13 Pro Max",
            "iPhone15,2": "iPhone 14 Pro",
            "iPhone15,3": "iPhone 14 Pro Max",
            "iPhone15,4": "iPhone 15",
            "iPhone15,5": "iPhone 15 Plus",
            "iPhone16,1": "iPhone 15 Pro",
            "iPhone16,2": "iPhone 15 Pro Max",
            "iPhone16,3": "iPhone 16",
            "iPhone16,4": "iPhone 16 Plus",
            "iPhone16,5": "iPhone 16 Pro",
            "iPhone16,6": "iPhone 16 Pro Max",
            "iPhone10,3": "iPhone X",
            "iPhone10,6": "iPhone X",
            "iPhone11,2": "iPhone XS",
            "iPhone11,4": "iPhone XS Max",
            "iPhone11,6": "iPhone XS Max",
            "iPhone12,1": "iPhone 11",
            "iPhone12,3": "iPhone 11 Pro",
            "iPhone12,5": "iPhone 11 Pro Max"
        ]
        
        return deviceList[identifier] ?? "Unknown Device (\(identifier))"
    }
}
