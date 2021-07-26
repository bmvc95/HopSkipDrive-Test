//
//  SplashView.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/24/21.
//

import UIKit

class SplashView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        createView()
        animateView()
    }
    
    /* ANIMATES THE LOGO VISIBILITY */
    private func animateView() {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut) { [weak self] in
            self?.splashImage.alpha = 1
        } completion: { [weak self] complete in
            self?.removeWithSlide()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createView() {
        addSubview(splashImage)
        addConstraints([
            splashImage.widthAnchor.constraint(equalToConstant: frame.width / 1.5),
            splashImage.heightAnchor.constraint(equalToConstant: 200),
            splashImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            splashImage.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    let splashImage: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        return imageView
    }()
}
