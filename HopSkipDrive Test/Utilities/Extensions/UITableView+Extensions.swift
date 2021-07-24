//
//  UITableView+Extensions.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/24/21.
//

import UIKit

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
           let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
           messageLabel.text = message
           messageLabel.textColor = .black
           messageLabel.numberOfLines = 0
           messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
           messageLabel.sizeToFit()
           self.backgroundView = messageLabel
           self.separatorStyle = .none
       }

       func restore() {
           self.backgroundView = nil
           self.separatorStyle = .singleLine
       }
}
