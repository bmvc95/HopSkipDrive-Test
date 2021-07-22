//
//  Location.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import Foundation
import MapKit

class Location {
    var address: String?
    var lat: Double?
    var long: Double?
    var annotation: MKPointAnnotation?
}

extension Location {
    
    static func transformData(data: [String: Any]) -> Location {
        let location = Location()
        location.address = (data["address"] as? String) ?? ""
        location.lat = (data["lat"] as? Double) ?? 0
        location.long = (data["lng"] as? Double) ?? 0
        if let lat = location.lat, let long = location.long {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            location.annotation = annotation
        }
        return location
    }
}
