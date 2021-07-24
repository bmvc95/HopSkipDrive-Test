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
            self?.removeView()
        }

    }
    
    /* REMOVES VIEW BY SLIDING DOWN AND SETTING ALPHA TO 0, VIEW IS DEALLOCATED AFTERWARDS */
    private func removeView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
            guard let self = self else { return }
            self.frame.origin.y += self.frame.height
            self.alpha = 0
        } completion: { [weak self] complete in
            self?.removeFromSuperview()
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
