//
//  RideDetailsViewController.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import UIKit
import MapKit

class RideDetailsViewController: UIViewController {
    
    @IBOutlet weak var detailsTableHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var estimatedPriceLabel: PaddingLabel!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cancelTripButton: UIButton!
    @IBOutlet weak var tripIDLabel: PaddingLabel!
    @IBOutlet weak var seriesLabel: PaddingLabel!
    
    var ride: MyRide!
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.detailsTableHeightAnchor.constant = self.detailsTableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ride Details"
        createBackButton()
        estimatedPriceLabel.layer.cornerRadius = estimatedPriceLabel.frame.height / 2
        setupTableView()
        setupHeaderView()
        setupFooterView()
        setupSeriesLabel()
        setupMapView()
    }
    
    private func setupMapView() {
        mapView.showsUserLocation = true
        if let waypoints = ride.orderedWaypoints {
            for waypoint in waypoints {
                if let annotation = waypoint.location?.annotation {
                    mapView.addAnnotation(annotation)
                }
            }
        }
    }
    private func setupSeriesLabel() {
        if let series = ride.inSeries, series {
            seriesLabel.text = "This trip is part of series"
            seriesLabel.topInset = 16
            seriesLabel.bottomInset = 16
        } else {
            seriesLabel.text = ""
            seriesLabel.topInset = 0
            seriesLabel.bottomInset = 0
        }
    }
    
    private func setupTableView() {
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        detailsTableView.reloadData()
    }
    
    private func setupFooterView() {
        if let tripID = ride.tripID,
           let miles = ride.estimatedRideMiles,
           let time = ride.estimatedRideMinutes {
            tripIDLabel.text = "Trip ID: \(tripID) · \(miles) mi · \(time) min"
        }
    }
    
    private func setupHeaderView() {
        if let date = ride.startsAt?.dateFromIso(format: "E MM/dd") {
            dateLabel.text = date
        }
        if let startTime = ride.startsAt?.timeFromIso(), let endTime = ride.endsAt?.timeFromIso() {
            let mutableString = NSMutableAttributedString(string: " · \(startTime) - \(endTime)")
            let range = NSRange(location: 0, length: 5 + startTime.count)
            mutableString.addAttribute(.font,
                                       value: UIFont.systemFont(ofSize: timeLabel.font.pointSize, weight: .regular),
                                       range: range)
            timeLabel.attributedText = mutableString
        }
        if let price = ride.estimatedEarningCents?.convertToDollarString() {
            estimatedPriceLabel.text = price
        }
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

extension RideDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ride?.orderedWaypoints?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "rideDetailCell", for: indexPath) as? RideDetailTableViewCell else {
            fatalError("There is no class by the name of RideDetailTableViewCell")
        }
        cell.detail = ride.orderedWaypoints?[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
}
