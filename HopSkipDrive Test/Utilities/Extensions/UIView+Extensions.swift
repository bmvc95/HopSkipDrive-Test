//
//  UIView+Extensions.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/25/21.
//

import Foundation
import UIKit

extension UIView {
    /* REMOVES VIEW BY SLIDING DOWN AND SETTING ALPHA TO 0, VIEW IS DEALLOCATED AFTERWARDS */
    func removeWithSlide() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
            guard let self = self else { return }
            self.frame.origin.y += self.frame.height
            self.alpha = 0
        } completion: { [weak self] complete in
            self?.removeFromSuperview()
        }
    }
}
