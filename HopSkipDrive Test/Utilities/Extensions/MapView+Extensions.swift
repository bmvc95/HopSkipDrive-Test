//
//  MapView+Extensions.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/24/21.
//

import Foundation
import MapKit

extension MKMapView {
    
    /* FUNCTION TO ADD PICK UP AND DROP OFF PINS ON THE MAP */
    func addAnnotations(waypoints: [Waypoint]) {
        var annotations: [MKAnnotation] = []
        for waypoint in waypoints {
            if let annotation = waypoint.location?.annotation { annotations.append(annotation)
            }
        }
        showAnnotations(annotations, animated: true)
    }
    
    /* FUNCTION THAT DETERMINES WHEHER THE USER HAS MOVED THE MAP,
     THIS IS TO PREVENT THE ADDRESS VIEW FROM DISAPPEARING WHEN SELECTINHG A
     PIN OR TABLEVIEW CELL */
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
    
    /* RECURSIVE FUNCTION THAT LISTS THE SHORTEST ROUTES BETWEEN WAYPOINTS TO
     ENSURE THE CARE DRIVERS HAVE THE BEST EXPERIENCE, I USE TO DELIVER PIZZA'S
     SO I KNOW THIS WOULD HELP */
    func showQuickestRoute(loadingView: RouteLoadingView, currentLocation: CLLocation, locations: [CLLocation]) {
        var locations = locations
        if let closest = locations.min(by: {$0.distance(from: currentLocation) < $1.distance(from: currentLocation)}) {
            Api.Rides.getRoute(pickUp: currentLocation.coordinate, dropOff: closest.coordinate) { [weak self] route in
                if let route = route {
                    self?.addOverlay(route.polyline)
                }
                if let index = locations.firstIndex(of: closest) {
                    locations.remove(at: index)
                }
                locations.isEmpty
                    ? loadingView.removeWithSlide()
                    : self?.showQuickestRoute(loadingView: loadingView, currentLocation: closest, locations: locations)
            }
        }
    }
}
