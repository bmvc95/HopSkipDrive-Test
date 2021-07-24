//
//  MyRidesViewController.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import UIKit

class MyRidesViewController: UIViewController {
    @IBOutlet weak var ridesTableView: UITableView!
    var rides: [[Ride]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ridesTableView.estimatedRowHeight = 64
        ridesTableView.rowHeight = UITableView.automaticDimension
        ridesTableView.delegate = self
        ridesTableView.dataSource = self
        retrieveRides()
    }
    
    /* FUNCTION THAT CALLS THE MY RIDES API TO LOAD SCHEDULED RIDES */
    private func retrieveRides() {
        Api.Rides.retrieveRides { [weak self] rides in
            /* HERE WE WANT TO USE [WEAK SELF] FOR SURE BECAUSE
            MAYBE THIS CONTROLLER DOESNT EXIST BY THE TIME THE CLOSURE IS CALLED */
            guard let self = self else { return }
            if let rides = rides {
                self.rides = rides
                self.ridesTableView.reloadData()
            } else {
                print("You have no rides")
            }
        }
    }
}

extension MyRidesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myRideCell") as? MyRideTableViewCell else {
            fatalError("There is no class by the name of MyRideTableViewCell")
        }
        cell.delegate = self
        cell.ride = rides[indexPath.section][indexPath.row]
        /* CLEAN UP THE UI BY SPACING OUT THE CELLS FROM EACH OTHER
         EXCEPT FOR THE LAST CELL */
        if rides[indexPath.section].count - 1 == indexPath.row {
            cell.viewHolderBottomAnchor.constant = 16
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rides.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rideHeader = RideHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        rideHeader.rides = rides[section]
        return rideHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1))
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }
}

/* PROTOCOL FUNCTION CALL THAT PUSHES RIDE DETAILS TO THE NAVIGATION STACK */
extension MyRidesViewController: MyRideTableViewCellDelegate {
    func showRideDetails(ride: Ride) {
        if let controller = UIStoryboard(name: "RideDetails", bundle: nil).instantiateViewController(withIdentifier: "rideDetailsController") as? RideDetailsViewController {
            controller.ride = ride
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
