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
    
    func timeFromIso() -> String {
        let epochTime = epochFromIso()
        
        let date = Date(timeIntervalSince1970: epochTime)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "h:mma"
        var localDate = dateFormatter.string(from: date).lowercased()
        _ = localDate.popLast()
        return localDate
    }
    
    func epochFromIso() -> Double {
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let isoDate = isoFormatter.date(from: self)
        let epochTime = isoDate?.timeIntervalSince1970 ?? 0
        return epochTime
    }
    
    func dateFromIso(format: String) -> String {
        let epochTime = epochFromIso()
        let date = Date(timeIntervalSince1970: epochTime)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = format
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
}
