//
//  devicesModel.swift
//  ModuloHome
//
//  Created by Toto on 16/01/2023.
//

import Foundation

// Data structure model for JSON objects
struct APIDevices: Decodable {
    let devices: [APIDevice]
}

struct APIDevice : Decodable {
    let id : Int
    let deviceName : String
    let temperature : Float?
    let mode : String?
    let intensity : Int?
    let position : Int?
    let productType: String
}

// Dedicated classes for each device type
class Device {
    let id : Int
    let deviceName : String
    
    init(id : Int, deviceName: String) {
        self.id = id
        self.deviceName = deviceName
    }
}

class Heater : Device {
    var temperature : Float
    var mode : String
    
    init(id : Int, deviceName: String, temp: Float, mode: String) {
        self.temperature = temp
        self.mode = mode
        super.init(id: id, deviceName: deviceName)
    }
}

class Light : Device {
    var intensity : Int
    var mode : String
    
    init(id : Int, deviceName: String, intensity: Int, mode: String) {
        self.intensity = intensity
        self.mode = mode
        super.init(id: id, deviceName: deviceName)
    }
}

class RollerShutter : Device {
    var position : Int
    
    init(id : Int, deviceName: String, position: Int) {
        self.position = position
        super.init(id: id, deviceName: deviceName)
    }
}
