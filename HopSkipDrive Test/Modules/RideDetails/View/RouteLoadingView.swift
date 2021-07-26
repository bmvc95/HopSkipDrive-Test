//
//  RouteLoadingView.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/25/21.
//

import Foundation
import UIKit

class RouteLoadingView: UIActivityIndicatorView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        startAnimating()
        layoutIfNeeded()
        addSubview(message)
        addConstraints([
            message.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100),
            message.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let message: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Fetching quickest route between\npick up and drop-off's"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
}
