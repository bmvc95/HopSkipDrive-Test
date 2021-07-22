//
//  RideDetailsViewController.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import UIKit
import MapKit

class RideDetailsViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var estimatedPriceLabel: PaddingLabel!
    
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var cancelTripButton: UIButton!
    @IBOutlet weak var tripIDLabel: PaddingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ride Details"
        createBackButton()
    }
    
    @IBAction func cancelTrip(_ sender: Any) {
        
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
