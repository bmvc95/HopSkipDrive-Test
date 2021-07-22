//
//  Int+Extensions.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import Foundation

extension Int {
    func convertToDollarString() -> String {
        return "$" + String(format: "%.2f", (Double(self) / 100))
    }
}
