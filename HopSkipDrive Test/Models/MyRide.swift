//
//  MyRide.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import Foundation

class MyRide {
    var tripID: Int?
    var inSeries: Bool?
    var startsAt: String?
    var endsAt: String?
    var estimatedEarningCents: Int?
    var estimatedRideMinutes: Double?
    var estimatedRideMiles: Double?
    var orderedWaypoints: [Waypoint]?
}

extension MyRide {
    static func transformData(data: [String: Any]) -> MyRide {
        let ride = MyRide()
        ride.tripID = (data["trip_id"] as? Int) ?? 0
        ride.inSeries = (data["in_series"] as? Bool) ?? false
        ride.startsAt = (data["starts_at"] as? String) ?? ""
        ride.endsAt = (data["ends_at"] as? String) ?? ""
        ride.estimatedEarningCents = (data["estimated_earnings_cents"] as? Int) ?? 0
        ride.estimatedRideMinutes = (data["estimated_ride_minutes"] as? Double) ?? 0
        ride.estimatedRideMiles = (data["estimated_ride_miles"] as? Double) ?? 0
        if let waypoints = data["ordered_waypoints"] as? NSArray {
            ride.orderedWaypoints = waypoints.map({Waypoint.transformData(data: $0 as? [String: Any] ?? [:])})
        } else {
            ride.orderedWaypoints = []
        }
        return ride
    }
}
