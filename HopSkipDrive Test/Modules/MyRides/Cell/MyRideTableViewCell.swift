//
//  MyRideTableViewCell.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import UIKit

protocol MyRideTableViewCellDelegate: AnyObject {
    func showRideDetails()
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
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBorderShadow()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewHolderBottomAnchor.constant = 0
    }
    
    private func updateView() {
        if let waypoints = ride.orderedWaypoints {
            updateDirectionsLabel(waypoints)
            updateRiderLabel(waypoints)
            updateEstimatedCostLabel()
            updateTimeLabel()
        }
    }
    
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
    
    private func updateDirectionsLabel(_ waypoints: [Waypoint]) {
        var directionsString = ""
        for i in 0..<waypoints.count {
            if let address = waypoints[i].location?.address {
                directionsString += "\(i + 1). \(address)"
                directionsString += i != waypoints.count ? "\n" : ""
            }
        }
        directionsLabel.text = directionsString
    }
    
    private func updateRiderLabel(_ waypoints: [Waypoint]) {
        let uniquePassengers = ride.getUniquePassengers()
        let boosterSeatCount = uniquePassengers.filter({$0.boosterSeat != false}).count
        let boosterText = boosterSeatCount != 0 ? " • \(boosterSeatCount) booster\(boosterSeatCount > 1 ? "s" : "")" : ""
        riderCountLabel.text = "(\(uniquePassengers.count) rider\(uniquePassengers.count > 1 ? "s" : "")\(boosterText))"
    }
    
    private func updateEstimatedCostLabel() {
        if let cents = ride.estimatedEarningCents {
            let mutableSting = NSMutableAttributedString(string: "est. \(cents.convertToDollarString())")
            let range = NSRange(location: 0, length: 3)
            if let font = estimatedCostLabel.font, let newFont = UIFont(name: font.fontName, size: 12) {
                mutableSting.addAttribute(.font, value: newFont, range: range)
                estimatedCostLabel.attributedText = mutableSting
            }
        }
    }
    
    private func updateTimeLabel() {
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
