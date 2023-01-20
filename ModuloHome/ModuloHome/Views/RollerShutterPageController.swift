//
//  RollerShutterPageController.swift
//  ModuloHome
//
//  Created by Toto on 18/01/2023.
//

import Foundation
import UIKit

class RollerShutterControl : UIViewController {
    
    //MARK: - Parameters
    private var valueSlider : Int = 0
    private var deviceID : Int = 0
    
    //MARK: - View components
    private var deviceName : UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(40)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var openLabel : UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(25)
        label.textAlignment = .center
        label.text = ""
        label.textColor = UIColor(named: "White")
        label.shadowColor = UIColor(named: "Black")
        label.shadowOffset = CGSize(width: 1, height: 1)
        return label
    }()
    

    // Image
    private var icon : UIImageView = {
        let view = UIImageView(image: UIImage(named: "DeviceRollerShutterIcon"))
        view.contentMode = .scaleAspectFill
        view.alpha = 0.5
        return view
    }()
    
    private var slider = UISlider()
    
    //Containers
    private var sliderView = UIView()
    private var stackView : UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        
        return view
    }()
    
    //MARK: - Init functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initConstraints()
        self.initSlider()
        self.updateView(withValue: self.valueSlider, animated: false)
    }
    
    private func initView() {
        self.view.backgroundColor = UIColor(named: "LightSteelBlue")
        self.view.addSubview(self.icon)
        self.view.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.deviceName)
        self.stackView.addArrangedSubview(self.openLabel)
        self.stackView.addArrangedSubview(self.sliderView)
    }
    
    private func initConstraints() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.openLabel.translatesAutoresizingMaskIntoConstraints = false
        self.sliderView.translatesAutoresizingMaskIntoConstraints = false
        self.icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant : 40),
            self.stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant : -100),
            self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant : 20),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant : -20),
            
            self.openLabel.heightAnchor.constraint(equalToConstant: 30),
            self.sliderView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/2),
            
            self.icon.centerXAnchor.constraint(equalTo: self.sliderView.centerXAnchor),
            self.icon.centerYAnchor.constraint(equalTo: self.sliderView.centerYAnchor),
            self.icon.heightAnchor.constraint(equalTo: self.sliderView.heightAnchor, constant : -30),
            self.icon.heightAnchor.constraint(equalTo: self.icon.widthAnchor),
        ])
    }
    
    private func initSlider(){
        self.slider = UISlider()
        self.slider.isContinuous = false
        // OPEN state
        self.slider.minimumValue = 0
        self.slider.maximumTrackTintColor = UIColor(named: "White")
        // CLOSED state
        self.slider.maximumValue = 100
        self.slider.minimumTrackTintColor = UIColor(named: "Black")
        // Actions
        self.slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        // View and constraints
        self.slider.translatesAutoresizingMaskIntoConstraints = false
        self.sliderView.addSubview(self.slider)
        //Slider rotation to have vertical descendant slider
        self.slider.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 0.5))
        
        NSLayoutConstraint.activate([
            self.slider.widthAnchor.constraint(equalTo: self.sliderView.heightAnchor),
            self.slider.centerYAnchor.constraint(equalTo: self.sliderView.centerYAnchor),
            self.slider.centerXAnchor.constraint(equalTo: self.sliderView.centerXAnchor),
        ])
    }
    
    //MARK: - parameters setting functions
    func setUp(title: String?, id: Int, position: Int){
        self.deviceName.text = title
        self.deviceID = id
        self.valueSlider = 100 - position //Transforms closing into opening
    }
    
    // Called function when new position is set with the slider
    @objc private func sliderChanged(sender: UISlider) {
        self.valueSlider = Int(round(sender.value))
        self.updateView(withValue: self.valueSlider, animated: true)
        // Update ViewModel
        let position = 100 - self.valueSlider
        DevicesViewModel.shared.updateShutterRoller(self.deviceID, withPosition: position)
    }
    
    private func updateView(withValue value: Int, animated: Bool){
        self.slider.setValue(Float(self.valueSlider), animated: animated)
        var textToPrint = ""
        if value == 100 {
            textToPrint = "CLOSED"
        } else if value == 0 {
            textToPrint = "OPEN"
        } else {
            textToPrint = "OPEN AT \(100 - value)%"
        }
        self.openLabel.text = textToPrint
    }
}
