//
//  MyRideTableViewCell.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import UIKit

/* PROTOCOL TO INHERIT FOR SUBSCIBED INSTANCES */
protocol MyRideTableViewCellDelegate: AnyObject {
    func showRideDetails(ride: MyRide)
}

class MyRideTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewHolderBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var viewHolder: UIView!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var estimatedCostLabel: UILabel!
    @IBOutlet weak var riderCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    weak var delegate: MyRideTableViewCellDelegate? //MUST BE WEAK OR RETAINED CYCLE WILL OCCUR
    var ride: MyRide! {
        didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBorderShadow()
        // Initialization code
    }
    
    /* RESETS THE CONSTRAINT AS THE CELL IS DEQUEUED FOR REUSE */
    override func prepareForReuse() {
        super.prepareForReuse()
        viewHolderBottomAnchor.constant = 0
    }
    
    /* FUNCTION TO SETUP UI WITH COORESPONDING DATA */
    private func setupView() {
        if let waypoints = ride.orderedWaypoints {
            setupDirectionsLabel(waypoints)
            setupRiderLabel(waypoints)
            setupEstimatedCostLabel()
            setupTimeLabel()
            addHolderGesture()
        }
    }
    
    /* FUNCTION TO ADD TAP GESTURE TO CONTENTVIEW */
    private func addHolderGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToDetails))
        viewHolder.addGestureRecognizer(tap)
        viewHolder.isUserInteractionEnabled = true
    }
    
    /* FUNCTION THAT CALLS DELEGATE FUNCTION TO SHOW RIDE DETAILS */
    @objc private func goToDetails() {
        delegate?.showRideDetails(ride: ride)
    }
    
    /* FUNCTION THAT SETUPS THE CARD UI */
    private func setupBorderShadow() {
        // ADDING BORDER TO VIEW
        viewHolder.layer.cornerRadius = 5
        viewHolder.layer.borderWidth = 1
        viewHolder.layer.borderColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor

        // ADDING SHADOW TO VIEW
        viewHolder.layer.masksToBounds = false
        viewHolder.layer.shadowColor = UIColor.black.cgColor
        viewHolder.layer.shadowOffset = CGSize(width: 0, height: 1)
        viewHolder.layer.shadowOpacity = 0.2
        viewHolder.layer.shadowRadius = 1
    }
    
    /* FUNCTION THAT COMBINES THE WAYPOINT ADDRESS'S INTO A STRING
     TO DISPLAY ON THE UI */
    private func setupDirectionsLabel(_ waypoints: [Waypoint]) {
        var directionsString = ""
        for i in 0..<waypoints.count {
            if let address = waypoints[i].location?.address {
                directionsString += "\(i + 1). \(address)"
                directionsString += i != waypoints.count ? "\n" : ""
            }
        }
        directionsLabel.text = directionsString
    }
    
    /* FUNCTION THAT GETS THE UNIQUE PASSENGERS BETWEEN THE WAYPOINTS
     AND UPDATES UI ABOUT PASSENGER COUNT AND BOOSTER SEAT COUNT */
    private func setupRiderLabel(_ waypoints: [Waypoint]) {
        let uniquePassengers = ride.getUniquePassengers()
        let boosterSeatCount = uniquePassengers.filter({$0.boosterSeat != false}).count
        let boosterText = boosterSeatCount != 0 ? " • \(boosterSeatCount) booster\(boosterSeatCount > 1 ? "s" : "")" : ""
        riderCountLabel.text = "(\(uniquePassengers.count) rider\(uniquePassengers.count > 1 ? "s" : "")\(boosterText))"
    }
    
    /* FUNCTION THAT SETUPS THE COST LABEL UI WITH THE COORESPONDING DATA
     BY CONVERTING CENTS TO DOLLARS */
    private func setupEstimatedCostLabel() {
        if let cents = ride.estimatedEarningCents {
            let mutableSting = NSMutableAttributedString(string: "est. \(cents.convertToDollarString())")
            let range = NSRange(location: 0, length: 3)
            if let font = estimatedCostLabel.font, let newFont = UIFont(name: font.fontName, size: 12) {
                mutableSting.addAttribute(.font, value: newFont, range: range)
                estimatedCostLabel.attributedText = mutableSting
            }
        }
    }
    
    /* FUNCTION THAT SETUPS TIME LABEL TO SHOW THE START TIME AND END TIME */
    private func setupTimeLabel() {
        if let startsAt = ride.startsAt, let endsAt = ride.endsAt {
            let startTime = startsAt.timeFromIso()
            let endTime = endsAt.timeFromIso()
            let mutableString = NSMutableAttributedString(string: "\(startTime) - \(endTime)")
            let range = NSRange(location: 0, length: startTime.count + 2)
            mutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: timeLabel.font.pointSize, weight: .bold), range: range)
            timeLabel.attributedText = mutableString
        }
    }
}
