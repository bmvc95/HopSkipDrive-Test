//
//  MyRidesViewController.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import UIKit

class MyRidesViewController: UIViewController {
    var rides: [MyRide] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        Api.myRides.retrieveRides { [weak self] rides in
            /* HERE WE WANT TO USE [WEAK SELF] FOR SURE BECAUSE
            MAYBE THIS CONTROLLER DOESNT EXIST BY THE TIME THE CLOSURE IS CALLED */
            guard let self = self else { return }
            if let rides = rides {
                self.rides = rides
                print("RIDES: \(rides)")
            } else {
                print("You have no rides")
            }
        }
        // Do any additional setup after loading the view.
    }
}
