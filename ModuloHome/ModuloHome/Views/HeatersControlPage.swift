//
//  HeatersControlPage.swift
//  ModuloHome
//
//  Created by Toto on 18/01/2023.
//

import Foundation
import UIKit

class HeaterControl : UIViewController {
    
    //MARK: - Parameters
    private var deviceID : Int = 0
    private var temperature : Float = 0
    private var btnControl : Bool = false {
        didSet {
            let heaterIsON = btnControl ? "on" : "off"
            self.stateBtn.setTitle(heaterIsON.uppercased(), for: .normal)
            DevicesViewModel.shared.updateHeater(self.deviceID, withState : heaterIsON, withTemperature: nil)
        }
    }
    
    //MARK: - View components
    private var nameLabel : UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(40)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var stateBtn : UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "Brown"), for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(40)
        button.backgroundColor = .white
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(named: "Brown")?.cgColor
        button.layer.shadowColor = UIColor(named: "Black")?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 1
        button.layer.shadowOpacity = 0.5
        button.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
        return button
    }()
    
    private var databrightLabel : UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(40)
        label.textAlignment = .center
        label.text = ""
        label.textColor = UIColor(named: "Brown")
        return label
    }()
    
    private var brightLabel : UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(25)
        label.textAlignment = .center
        label.text = "Brightness"
        label.textColor = UIColor(named: "Brown")
        return label
    }()
    
    // Images
    private var heaterOffIcon : UIImageView = {
        let image = UIImageView(image: UIImage(named: "DeviceHeaterOffIcon"))
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private var heaterOnIcon : UIImageView = {
        let image = UIImageView(image: UIImage(named: "DeviceHeaterOnIcon"))
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private var slider = CircularSlider()
    
    // Containers
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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateValueView(withValue: self.temperature, animated: false)
    }
    private func initView() {
        
        self.view.backgroundColor = UIColor(named: "LightSteelBlue")
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.sliderView)
        self.view.addSubview(self.stateBtn)
        self.view.addSubview(self.databrightLabel)
        self.view.addSubview(self.brightLabel)
        self.view.addSubview(self.heaterOffIcon)
        self.view.addSubview(self.heaterOnIcon)
    }
    
    private func initConstraints() {
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.sliderView.translatesAutoresizingMaskIntoConstraints = false
        self.stateBtn.translatesAutoresizingMaskIntoConstraints = false
        self.databrightLabel.translatesAutoresizingMaskIntoConstraints = false
        self.brightLabel.translatesAutoresizingMaskIntoConstraints = false
        self.heaterOffIcon.translatesAutoresizingMaskIntoConstraints = false
        self.heaterOnIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.sliderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.sliderView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.sliderView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/3),
            self.sliderView.widthAnchor.constraint(equalTo: self.sliderView.heightAnchor),
            
            
            self.nameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant : 40),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.sliderView.topAnchor),
            self.nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant : 20),
            
            self.stateBtn.centerXAnchor.constraint(equalTo: self.sliderView.centerXAnchor),
            self.stateBtn.centerYAnchor.constraint(equalTo: self.sliderView.centerYAnchor),
            self.stateBtn.heightAnchor.constraint(equalTo: self.stateBtn.widthAnchor),
            self.stateBtn.widthAnchor.constraint(equalToConstant: 100),
            
            
            self.databrightLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.databrightLabel.bottomAnchor.constraint(equalTo: self.sliderView.bottomAnchor),
            
            self.brightLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.brightLabel.topAnchor.constraint(equalTo: self.databrightLabel.bottomAnchor),
            
            self.heaterOffIcon.leadingAnchor.constraint(equalTo: self.sliderView.leadingAnchor),
            self.heaterOffIcon.bottomAnchor.constraint(equalTo: self.sliderView.bottomAnchor),
            self.heaterOffIcon.heightAnchor.constraint(equalTo: self.heaterOffIcon.widthAnchor),
            self.heaterOffIcon.heightAnchor.constraint(equalToConstant: 50),
            
            self.heaterOnIcon.trailingAnchor.constraint(equalTo: self.sliderView.trailingAnchor),
            self.heaterOnIcon.bottomAnchor.constraint(equalTo: self.heaterOffIcon.bottomAnchor),
            self.heaterOnIcon.heightAnchor.constraint(equalTo: self.heaterOffIcon.heightAnchor),
            self.heaterOnIcon.widthAnchor.constraint(equalTo: self.heaterOffIcon.widthAnchor),
        ])
    }
    
    // Init slider view
    private func initSlider(){
        
        self.view.layoutIfNeeded()
        let frame = CGRect(x: 0, y: 0, width: self.sliderView.frame.width-30, height: self.sliderView.frame.height-30)
        self.slider = CircularSlider(frame: frame)
        
        // Setup target to watch for value change
        self.slider.addTarget(self, action: #selector(sliderChanged), for: UIControl.Event.valueChanged)
        self.slider.maximumAngle = 270.0
        self.slider.unfilledArcLineCap = .round
        self.slider.filledArcLineCap = .round
        self.slider.minimumValue = 0
        self.slider.maximumValue = 42
        
        self.slider.lineWidth = 30
        if let color = UIColor(named: "Brown") {
            self.slider.filledColor = color
        }
        
        self.sliderView.addSubview(self.slider)
        
        // Transform to rotate the arc so the white space is centered at the bottom
        self.slider.transform = self.slider.getRotationalTransform()
        
    }
    
    //MARK: - parameters setting functions
    func setUp(title: String?, id: Int, state: Bool, temp: Float){
        self.nameLabel.text = title
        self.deviceID = id
        self.btnControl = state
        self.temperature = 2 * temp - 14
    }
    
    // Called function when new value is set with the slider
    @objc private func sliderChanged(_ sender: CircularSlider) {
        self.temperature = round(sender.currentValue)
        
        self.updateValueView(withValue: self.temperature, animated: true)
        // Update ViewModel
        DevicesViewModel.shared.updateHeater(self.deviceID, withState : nil, withTemperature: (self.temperature+14)/2)
    }
    
    // Called function when state is set by the button
    @objc private func btnPressed(_ sender: UIButton) {
        self.btnControl = !btnControl
    }
    
    private func updateValueView(withValue value: Float, animated: Bool){
        self.slider.currentValue = Float(value)
        self.databrightLabel.text = String((value+14)/2) + " °C"
    }

}
