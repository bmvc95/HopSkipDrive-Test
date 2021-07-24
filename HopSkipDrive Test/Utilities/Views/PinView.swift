//
//  PinView.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/24/21.
//

import UIKit
import MapKit

class PinView: UIView {
    
    var anchor: Bool = false
    var pinColor = UIColor.systemGreen
    
    init(annotation: MKAnnotation, ride: Ride, frame: CGRect) {
        super.init(frame: frame)
        anchor = ride.orderedWaypoints?
            .filter({$0.location?.annotation?.title == annotation.title})
            .first?.anchor ?? false
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        pinColor = anchor ? pinColor : .systemRed
        backgroundColor = pinColor
        layer.cornerRadius = frame.width / 2
        let pinPulse = PinPulse(pulseCount: .infinity, radius: frame.height, position: center)
        pinPulse.animationDuration = 1
        pinPulse.backgroundColor = pinColor.cgColor
        layer.insertSublayer(pinPulse, below: layer)
    }
}
