//
//  MyRidesViewController.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import UIKit

class MyRidesViewController: UIViewController {
    @IBOutlet weak var ridesTableView: UITableView!
    var rides: [MyRide] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        ridesTableView.estimatedRowHeight = 64
        ridesTableView.rowHeight = UITableView.automaticDimension
        ridesTableView.delegate = self
        ridesTableView.dataSource = self
        Api.myRides.retrieveRides { [weak self] rides in
            /* HERE WE WANT TO USE [WEAK SELF] FOR SURE BECAUSE
            MAYBE THIS CONTROLLER DOESNT EXIST BY THE TIME THE CLOSURE IS CALLED */
            guard let self = self else { return }
            if let rides = rides {
                self.rides = rides
                self.ridesTableView.reloadData()
                print("RIDES: \(rides)")
            } else {
                print("You have no rides")
            }
        }
        // Do any additional setup after loading the view.
    }
}

extension MyRidesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myRideCell") as? MyRideTableViewCell else {
            
            fatalError("There is no class by the name of MyRideTableViewCell")
        }
        cell.ride = rides[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
