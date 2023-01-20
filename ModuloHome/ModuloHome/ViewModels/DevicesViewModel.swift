//
//  DevicesViewModel.swift
//  ModuloHome
//
//  Created by Toto on 16/01/2023.
//

import Foundation

class DevicesViewModel : NSObject {
    
    static var shared = DevicesViewModel()

    private var apiService : APIService?
    
    var bindDevicesVMToController : (() -> ()) = {}
    
    private(set) var lights = [Light]()
    private(set) var heaters = [Heater]()
    private(set) var rollerShutters = [RollerShutter]()
    let changeDeviceStateNotification = Notification(name: Notification.Name(rawValue: "deviceStateChange"))
    
    override private init(){
        super.init()
        self.apiService = APIService()
    }
    
    func getData() {
        self.apiService?.getDevicesData { (devices) in
            self.sortDevices(devices) {
                self.bindDevicesVMToController()
            }
        }
    }
    
    private func sortDevices(_ devices : [APIDevice], completion: () -> ()) {
        
        for device in devices {
            switch device.productType {
            case "Light" :
                if let intensity = device.intensity, let mode = device.mode?.lowercased() {
                    let light = Light(id: device.id, deviceName: device.deviceName, intensity: intensity, mode : mode)
                    self.lights.append(light)
                }
                
            case "Heater" :
                if let temperature = device.temperature, let mode = device.mode?.lowercased()  {
                    let heater = Heater(id: device.id, deviceName: device.deviceName, temp: temperature, mode : mode)
                    self.heaters.append(heater)
                }

            case "RollerShutter" :
                if let position = device.position {
                    let rollerShutter = RollerShutter(id: device.id, deviceName: device.deviceName, position: position)
                    self.rollerShutters.append(rollerShutter)
                }

            default :
                break
            }
        }
        completion()
    }
    
    func updateLight(_ id : Int, withState state : String?, withIntensity intensity : Int?){
        if let state = state?.lowercased() {
            self.lights[id].mode = state
        }
        if let intensity = intensity {
            self.lights[id].intensity = intensity
        }
        NotificationCenter.default.post(changeDeviceStateNotification)
    }
    
    func updateHeater(_ id : Int, withState state : String?, withTemperature temperature : Float?){
        if let state = state?.lowercased() {
            self.heaters[id].mode = state
        }
        if let temp = temperature {
            self.heaters[id].temperature = temp
        }
        NotificationCenter.default.post(changeDeviceStateNotification)
    }
    
    func updateShutterRoller(_ id : Int, withPosition newPos: Int){
        self.rollerShutters[id].position = newPos
        NotificationCenter.default.post(changeDeviceStateNotification)
    }
    
    func countDevices() -> Int {
        return self.lights.count + self.heaters.count + self.rollerShutters.count
    }
}
