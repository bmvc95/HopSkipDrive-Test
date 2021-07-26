//
//  Passenger.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import Foundation
import UIKit

class Passenger: Hashable, Equatable {

    var id: Int?
    var boosterSeat: Bool?
    var fistName: String?
    var image: UIImage?
    var imageURL: String? // I THINK THIS WOULD BE NEET, HELP CARE DRIVERS DISTINQUSH BETWEEN CHILD AND DROP OFF
    
    static func == (lhs: Passenger, rhs: Passenger) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {}
}

extension Passenger {
    static func transformData(data: [String: Any]) -> Passenger {
        let passenger = Passenger()
        passenger.id = (data["id"] as? Int) ?? 0
        passenger.boosterSeat = (data["booster_seat"] as? Bool) ?? false
        passenger.fistName = (data["first_name"] as? String) ?? "Anonymous"
        passenger.imageURL = data["first_name"] as? String
        passenger.image = UIImage(named: "kid\(passenger.id ?? 0)")
        return passenger
    }
}
