//
//  APIService.swift
//  ModuloHome
//
//  Created by Toto on 16/01/2023.
//

import Foundation

class APIService : NSObject {
    
    private let sourcesURL = URL(string: "http://storage42.com/modulotest/data.json")
    
    func getDevicesData(completion: @escaping ([APIDevice]) -> ()) {
        
        guard let url = sourcesURL else {
            // TODO: handle no response from API case
            print("No response from url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                // TODO: handle response error case
                print("Error response")
                return
            }
            
            guard let responseJSON = try? JSONDecoder().decode(APIDevices.self, from: data) else {
                // TODO: handle response parsing error case
                print("Error decoding")
                return
            }
            
            guard !responseJSON.devices.isEmpty else {
                // TODO: handle empty devices list case
                print("No devices get")
                return
            }
            
            completion(responseJSON.devices)
            
        }.resume()
    }
}
