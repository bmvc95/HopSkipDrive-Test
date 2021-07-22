//
//  RideDetailsViewController.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import UIKit

class RideDetailsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ride Details"
        createBackButton()
    }
    
    private func createBackButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back-arrow")?.withTintColor(.white), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItems = [barButton]
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
