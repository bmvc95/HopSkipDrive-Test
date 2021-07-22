//
//  RideDetailTableViewCell.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/22/21.
//

import UIKit

class RideDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var anchorLabel: UILabel!
    @IBOutlet weak var anchorImage: UIImageView!
    
    var detail: Waypoint! {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        if let address = detail.location?.address {
            addressLabel.text = address
        }
        setupAnchorUI()
    }
    
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
