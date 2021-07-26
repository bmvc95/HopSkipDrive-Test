//
//  Location.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import Foundation
import MapKit

class Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.address == rhs.address
    }
    
    var address: String?
    var lat: Double?
    var long: Double?
    var annotation: MKPointAnnotation!
}

extension Location {
    
    static func transformData(data: [String: Any]) -> Location {
        let location = Location()
        location.address = (data["address"] as? String) ?? ""
        location.lat = (data["lat"] as? Double) ?? 0
        location.long = (data["lng"] as? Double) ?? 0
        if let lat = location.lat,
           let long = location.long,
           let address = location.address {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            location.address?.coordsFromAddress(complete: { coords in
                if let coords = coords {
                    annotation.coordinate = coords
                }
            })
            annotation.title = address
            location.annotation = annotation
        }
        return location
    }
}
