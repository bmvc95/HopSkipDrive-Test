//
//  RideDetailsViewController.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import UIKit
import MapKit

protocol RideDetailsViewControllerDelegate: AnyObject {
    func cancelRide(_ ride: Ride)
}

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
    
    @IBOutlet weak var showDirectionsButton: UIButton!
    var ride: Ride!
    weak var delegate: RideDetailsViewControllerDelegate?
    var addressView: AddressView?
    
    /* USED TO INCREASE THE HEIGHT OF TABLE VIEW TO FIT ITS CONTENT,
     THOUGHT IT WOULD BE BETTER UX */
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
    
    /* FUNCTION THAT MARKS PINS ON THE MAP BASED ON WAYPOINT
     COORDINATES AND THEN CENTERS THE MAP ON PICK UP LOCATION */
    private func setupMapView() {
        mapView.clipsToBounds = false
        mapView.showsUserLocation = true
        mapView.delegate = self
        if let waypoints = ride.orderedWaypoints {
            mapView.addAnnotations(waypoints: waypoints)
        }
    }
    
    /* FUNCTIONALITY THAT SHOWS OR HIDES THE SERIES LABEL BASED ON BOOL */
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
    
    /* FUNCTIONALITY TO SETUP FOOTER VIEW UI WITH ITS COORESPONDING DATA */
    private func setupFooterView() {
        if let tripID = ride.tripID,
           let miles = ride.estimatedRideMiles,
           let time = ride.estimatedRideMinutes {
            tripIDLabel.text = "Trip ID: \(tripID) · \(miles) mi · \(time) min"
        }
    }
    
    /* SHOWS THE DIRECTIONS BETWEEN PICK UP AND DROP OFF LOCATIONS */
    @IBAction func showDirections(_ sender: Any) {
        deleteAddressView { }
        mapView.removeOverlays(mapView.overlays)
        if let waypoints = ride.orderedWaypoints {
            if let pickUp = waypoints.filter({$0.anchor}).first?.location?.annotation?.coordinate {
                let currentLocation = CLLocation(latitude: pickUp.latitude, longitude: pickUp.longitude)
                let loading = RouteLoadingView(frame: UIScreen.main.bounds)
                view.addSubview(loading)
                mapView.showQuickestRoute(loadingView: loading, currentLocation: currentLocation, waypoints: waypoints)
            }
        }
    }
    
    /* SETTING UP HEADER VIEW WITH TIME AND COST ATTRIBUTES */
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
    
    /* FUNCTIONALITY TO CANCEL THE CURRENT TRIP, WE SHOW AN ALERT TO DOUBLE
     CHECK WITH THE USER IF THIS IS WHAT THEY WISH TO DO */
    @IBAction func cancelTrip(_ sender: Any) {
        let alertView = UIAlertController(title: "Cancel Trip", message: "Are you sure you wish to cancel this trip?", preferredStyle: .actionSheet)
        alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
            self.delegate?.cancelRide(self.ride)
        }))
        alertView.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
    /* FUNCTIONALITY TO CREATE THE BACK ARROW FOR THE NAVIGATION BAR */
    private func createBackButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back-arrow")?.withTintColor(.white), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItems = [barButton]
    }
    
    /* FUNCTIONALITY TO POP THE USER BACK TO THEIR RIDES VIEW */
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    /* FUNCTION THAT DELETES THE ADDRESS VIEW WITH STYLE */
    private func deleteAddressView(complete: @escaping() -> ()) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.addressView?.alpha = 0
        } completion: { [weak self] _ in
            self?.addressView?.removeFromSuperview()
            complete()
        }
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
        cell.delegate = self
        return cell
    }
    
    /* CALLING VIEWWILLLAYOUTSUBVIEWS HERE TO
     EXPAND THE TABLEVIEW HEIGHT DYNAMICALLY */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
}

/* FUNCTIONALITY TO CENTER THE TAPPED ADDRESS ON THE MAP VIEW
THIS WILL MAKE UX BETTER */
extension RideDetailsViewController: RideDetailDelegate {
    func goToPin(location: MKAnnotation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01,
                                    longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        if let address = location.title as? String {
            deleteAddressView { [weak self] in
                guard let self = self else { return }
                let addressView = AddressView(frame: self.mapView.frame,
                                              address: address)
                self.addressView = addressView
                self.mapView.addSubview(addressView)
            }
        }
    }
}

/* FUNCTIONALITY TO MARK THE WAYPOINTS ON THE MAP AND TO APPLY THE
 APPROPIATE BACKGROUND COLOR BASED ON PICK UP OR DROP OFF */
extension RideDetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        let identifier = "identifier"
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.frame.size = CGSize(width: 40, height: 40)
        let pinView = PinView(annotation: annotation,
                              ride: ride,
                              frame: CGRect(x: 0,
                                            y: 0,
                                            width: 30,
                                            height: 30))
        annotationView.addSubview(pinView)
        annotationView.isUserInteractionEnabled = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let coords = view.annotation {
            goToPin(location: coords)
        }
    }
    
    /* HIDES THE ADDRESS VIEW ON THE MAP TO GIVE USER BACK FULL VIEW ACCESS */
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if mapView.regionChangeFromUserInteraction() {
            deleteAddressView {}
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.systemTeal
        renderer.lineWidth = 5
        return renderer
    }
}


