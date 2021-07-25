//
//  RideDetailProcols.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/24/21.
//

import Foundation
import MapKit

/* PROTOCOL TO INHERIT FOR SUBSCIBED INSTANCES */
protocol RideDetailDelegate: AnyObject {
    func goToPin(location: MKAnnotation)
}
