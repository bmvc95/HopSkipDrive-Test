//
//  MyRidesViewController.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import UIKit

class MyRidesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Api.myRides.retrieveRides { rides in
            
        }
        // Do any additional setup after loading the view.
    }
}
