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
    func showRoute(pickUp: CLLocationCoordinate2D, dropOff: CLLocationCoordinate2D) {
//        let coordArray = [pickUp, dropOff]
//        let polyline = MKPolyline(coordinates: coordArray, count: coordArray.count)
//        addOverlay(polyline)
        let pickUpPlacemark = MKPlacemark(coordinate: pickUp)
        let dropOffPlacemark = MKPlacemark(coordinate: dropOff)
        let pickUpItem = MKMapItem(placemark: pickUpPlacemark)
        let dropOffItem = MKMapItem(placemark: dropOffPlacemark)

        let directionRequest = MKDirections.Request()
        directionRequest.source = pickUpItem
        directionRequest.destination = dropOffItem
        directionRequest.transportType = .automobile
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else {
                if let error = error {
                    print("ERROR: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.addOverlay((route.polyline), level: .aboveLabels)
            let rect = route.polyline.boundingMapRect
            self.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
}
