//
//  RideDetailTableViewCell.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/22/21.
//

import UIKit
import MapKit

/* PROTOCOL TO INHERIT FOR SUBSCIBED INSTANCES */
protocol RideDetailTableViewCellDelegate: AnyObject {
    func goToPin(location: CLLocationCoordinate2D)
}

class RideDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var anchorLabel: UILabel!
    @IBOutlet weak var anchorImage: UIImageView!
    
    weak var delegate: RideDetailTableViewCellDelegate?
    var detail: Waypoint! {
        didSet {
            updateView()
        }
    }
    
    /* FUNCTION THAT UPDATES THE UI WITH COORESPONDING DATA */
    private func updateView() {
        if let address = detail.location?.address {
            addressLabel.text = address
        }
        setupAnchorUI()
        setupTapGesture()
    }
    
    /* FUNCTION ADDING TAP GESTURE TO CONTENT VIEW */
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToCoords))
        contentView.addGestureRecognizer(tap)
        contentView.isUserInteractionEnabled = true
    }
    
    /* FUNCTION THAT CALLS DELEGATE TO CENTER PIN ON MAP VIEW */
    @objc private func goToCoords() {
        if let location = detail.location?.annotation?.coordinate {
            delegate?.goToPin(location: location)
        }
    }
    
    /* FUNCTION THAT SETUPS THE DROP OFF/PICKUP UI BASED ON ANCHOR */
    private func setupAnchorUI() {
        if detail.anchor == true {
            anchorLabel.text = "Pickup"
            anchorImage.image = UIImage(systemName: "diamond.fill")
        } else {
            anchorLabel.text = "Drop-off"
            anchorImage.image = UIImage(systemName: "circle.fill")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
