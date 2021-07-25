//
//  MapView+Extensions.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/24/21.
//

import Foundation
import MapKit

extension MKMapView {
    func regionChangeFromUserInteraction() -> Bool {
        if let view = subviews.first {
            if let gestures = view.gestureRecognizers {
                for gesture in gestures {
                    if(gesture.state == .began || gesture.state == .ended) {
                        return true
                    }
                }
            }
        }
        return false
    }
}
