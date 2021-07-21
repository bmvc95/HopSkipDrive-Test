//
//  ViewController.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/20/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        title = "My Rides"
        createMenuButton()
    }
    
    private func createMenuButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "menu")?.withTintColor(.white), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItems = [barButton]
    }
    
    @objc func openMenu() {
        print("slide menu out")
    }
}

