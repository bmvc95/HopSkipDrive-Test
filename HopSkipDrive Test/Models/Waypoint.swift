//
//  Waypoint.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import Foundation

class Waypoint {
    var id: Int?
    var anchor: Bool = false
    var passengers: [Passenger]?
    var location: Location?
}

extension Waypoint {
    static func transformData(data: [String: Any]) -> Waypoint {
        let waypoint = Waypoint()
        waypoint.id = (data["id"] as? Int) ?? 0
        waypoint.anchor = (data["anchor"] as? Bool) ?? false
        if let passengers = data["passengers"] as? NSArray {
            waypoint.passengers = passengers.map({Passenger.transformData(data: $0 as? [String: Any] ?? [:])})
        } else {
            waypoint.passengers = []
        }
        waypoint.location = Location.transformData(data: data["location"] as? [String: Any] ?? [:])
        return waypoint
    }
}
