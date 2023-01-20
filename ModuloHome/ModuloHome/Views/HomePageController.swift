//
//  HomePageController.swift
//  ModuloHome
//
//  Created by Toto on 16/01/2023.
//

import UIKit

class HomePageController: UIViewController {

    private enum TypeOfDevice : Int, CaseIterable {
        case light = 0
        case heater = 1
        case rollerShutter = 2
    }
    
    //MARK: - Devices controllers
    lazy var lightPageControl = LightControl()
    lazy var rollerShutterPageControl = RollerShutterControl()
    lazy var heaterPageControl = HeaterControl()
    
    //MARK: - view components
    var devicesTableView : UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor(named: "LightSteelBlue")
        table.separatorStyle = .singleLine
        table.separatorColor = UIColor(named: "Brown")
        table.tableFooterView = UIView()
        return table
    }()
    
    //MARK: - Init functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initConstraints()
        self.callToVM()
    }
    
    private func initView() {
        self.devicesTableView.delegate = self
        self.devicesTableView.dataSource = self
        
        self.view.backgroundColor = UIColor(named: "LightSteelBlue")
        self.view.addSubview(self.devicesTableView)
        
        let notifName = Notification.Name(rawValue: "deviceStateChange")
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDevicesList), name: notifName, object: nil)
    }
    
    private func initConstraints() {
        self.devicesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.devicesTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            self.devicesTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -44),
            self.devicesTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.devicesTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }

    private func callToVM() {
        // Get devices data
        DevicesViewModel.shared.bindDevicesVMToController = {
            DispatchQueue.main.async {
                self.devicesTableView.reloadData()
            }
        }
        DevicesViewModel.shared.getData()
    }
    
    @objc private func refreshDevicesList(){
        self.devicesTableView.reloadData()
    }
}

//MARK: - TableView handling
extension HomePageController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case TypeOfDevice.light.rawValue :
            let light = DevicesViewModel.shared.lights[indexPath.row]
            self.lightPageControl = LightControl()
            self.lightPageControl.modalPresentationStyle = .automatic
            
            let isOn = (light.mode == "on" ? true : false)
            self.lightPageControl.setUp(title: light.deviceName, id: indexPath.row, state: isOn, intensity: light.intensity)
            self.present(self.lightPageControl, animated: true, completion: nil)
            
        case TypeOfDevice.heater.rawValue :
            let heater = DevicesViewModel.shared.heaters[indexPath.row]
            self.heaterPageControl = HeaterControl()
            self.heaterPageControl.modalPresentationStyle = .automatic
            
            let isOn = (heater.mode == "on" ? true : false)
            self.heaterPageControl.setUp(title: heater.deviceName, id: indexPath.row, state: isOn, temp: heater.temperature)
            self.present(self.heaterPageControl, animated: true, completion: nil)
            
        case TypeOfDevice.rollerShutter.rawValue:
            let rollerShutter = DevicesViewModel.shared.rollerShutters[indexPath.row]
            self.rollerShutterPageControl = RollerShutterControl()
            self.rollerShutterPageControl.modalPresentationStyle = .automatic
            self.rollerShutterPageControl.setUp(title: rollerShutter.deviceName, id: indexPath.row, position: rollerShutter.position)
            self.present(self.rollerShutterPageControl, animated: true, completion: nil)

        default: break
        }
    }
    
}

extension HomePageController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TypeOfDevice.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let deviceVM = DevicesViewModel.shared
        if section == TypeOfDevice.light.rawValue && deviceVM.lights.count != 0 {
            return "Lights"
        } else if section == TypeOfDevice.heater.rawValue && deviceVM.heaters.count != 0 {
            return "Heaters"
        } else if section == TypeOfDevice.rollerShutter.rawValue && deviceVM.rollerShutters.count != 0 {
            return "RollerShutters"
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case TypeOfDevice.light.rawValue :        return DevicesViewModel.shared.lights.count
        case TypeOfDevice.heater.rawValue :       return DevicesViewModel.shared.heaters.count
        case TypeOfDevice.rollerShutter.rawValue: return DevicesViewModel.shared.rollerShutters.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DeviceCell(style: .default, reuseIdentifier: nil)
        
        var title = ""
        
        switch indexPath.section {
        case TypeOfDevice.light.rawValue :
            let light = DevicesViewModel.shared.lights[indexPath.row]
            title =  "\(light.deviceName) is \(light.mode)"
            if light.mode == "on" {
                title += " at \(light.intensity)%"
            }
            
            
        case TypeOfDevice.heater.rawValue :
            let heater = DevicesViewModel.shared.heaters[indexPath.row]
            title =  "\(heater.deviceName) is \(heater.mode)"
            if heater.mode == "on" {
                title += " at \(heater.temperature)°C"
            }
            
        case TypeOfDevice.rollerShutter.rawValue:
            let rollerShutter = DevicesViewModel.shared.rollerShutters[indexPath.row]
            title =  "\(rollerShutter.deviceName) is "
            if rollerShutter.position == 0 {
                title += "closed"
            } else {
                title += "open at \(rollerShutter.position)%"
            }
            
        default: break
        }
        
        cell.setUp(title: title)
        return cell
    }
    
    
}

