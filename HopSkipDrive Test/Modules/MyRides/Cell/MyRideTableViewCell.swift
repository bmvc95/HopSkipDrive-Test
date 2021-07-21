//
//  MyRideTableViewCell.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import UIKit

class MyRideTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewHolder: UIView!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var estimatedCostLabel: UILabel!
    @IBOutlet weak var riderCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var ride: MyRide! {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
