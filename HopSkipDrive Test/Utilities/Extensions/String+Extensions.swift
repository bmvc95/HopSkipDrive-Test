//
//  String+Extensions.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import Foundation

extension String {
    func convertToDict() -> [String: Any]? {
        if let data = data(using: .utf8), let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return dict
        }
        return nil
    }
}
