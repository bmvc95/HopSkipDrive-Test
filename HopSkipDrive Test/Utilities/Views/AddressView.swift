//
//  AddressView.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/24/21.
//

import Foundation
import UIKit

class AddressView: UIView {
    var address: String = ""
    init(frame: CGRect, address: String) {
        super.init(frame: frame)
        self.address = address
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        isUserInteractionEnabled = false
        addSubview(addressLabel)
        addConstraints([
            addressLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            addressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        addressLabel.text = address
        layoutIfNeeded()
        addressLabel.layer.cornerRadius = addressLabel.frame.height / 2
    }
    
    let addressLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topInset = 16
        label.leftInset = 16
        label.rightInset = 16
        label.bottomInset = 16
        label.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        label.textColor = .black
        label.backgroundColor = .white
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.borderWidth = 0.5
        label.numberOfLines = 0
        label.clipsToBounds = true
        return label
    }()
}
