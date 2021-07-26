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
    var childImages: [UIImage] = []
    
    init(annotation: MKAnnotation, ride: Ride, frame: CGRect) {
        super.init(frame: frame)
        if let passengers = ride.orderedWaypoints?
            .filter({$0.location?.annotation?.title == annotation.title})
            .first?.passengers {
            for child in passengers where child.image != nil {
                childImages.append(child.image!) // NORMALLY NOT GOOD TO FORCE UPWRAP BUT WE CHECK ABOVE IN THE WHERE STATEMENT
            }
        }
        self.anchor = ride.orderedWaypoints?
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
        createPassengerImages()
    }
    
    private func createPassengerImages() {
        if !childImages.isEmpty {
            let childImageView = UIImageView(frame: CGRect(x: 2.5, y: 2.5, width: 25, height: 25))
            addSubview(childImageView)
            childImageView.contentMode = .scaleAspectFill
            childImageView.image = childImages.first
            childImageView.layer.cornerRadius = childImageView.frame.width / 2
            childImageView.clipsToBounds = true
            if childImages.count > 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.animateChildImages(imageView: childImageView, index: 1)
                }
            }
        }
    }
    
    /* FUNCTION THAT CREATES A SLIDESHOW OF THE CHILDREN IMAGES AT A GIVEN WAYPOINT*/
    private func animateChildImages(imageView: UIImageView, index: Int) {
        UIView.transition(with: imageView, duration: 1, options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            imageView.image = self.childImages[index]
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                guard let self = self else { return }
                index < self.childImages.count - 1
                    ? self.animateChildImages(imageView: imageView, index: index + 1)
                    : self.animateChildImages(imageView: imageView, index: 0)
            }
        }
    }
}
