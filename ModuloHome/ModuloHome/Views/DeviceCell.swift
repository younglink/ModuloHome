//
//  DeviceCell.swift
//  ModuloHome
//
//  Created by Toto on 16/01/2023.
//

import Foundation
import UIKit

class DeviceCell: UITableViewCell {
    
    //MARK: - Parameters
    let title = UILabel()
    
    //MARK: - Init functions
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initSubviews()
        self.initConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initSubviews()
        self.initConstraints()
    }
    
    private func initSubviews() {
        self.contentView.addSubview(self.title)
        self.contentView.backgroundColor = UIColor(named: "LightSteelBlue")
        self.title.font = UIFont(name: "QuicksandBold", size: 14)
        self.title.textColor = UIColor(named: "DarkGray")
//        self.title.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    private func initConstraints() {
        self.title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.title.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.title.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.title.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -10),
            self.title.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20)
            
        ])
    }
    
    //MARK: - Control functions
    public func setUp(title: String) {
        self.contentView.layoutIfNeeded()
        self.title.text = title
    }
    
}
