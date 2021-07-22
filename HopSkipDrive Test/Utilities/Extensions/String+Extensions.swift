//
//  String+Extensions.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import Foundation

extension String {
    
    /* FUNCTION THAT CONVERTS THE JSON STRING TO AND INTERABLE DICTIONARY */
    func convertToDict() -> [String: Any]? {
        if let data = data(using: .utf8), let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return dict
        }
        return nil
    }
    
    /* FUNCTION THAT GETS THE HOURS, MINUTES AND TIME OF DAY AND RETURNS THE STRING */
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
    
    /* FUNCTION THE TURNS THE ISO TIME INTO EPOCH,
     THIS ALLOWS FOR EASIER SORTING */
    func epochFromIso() -> Double {
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let isoDate = isoFormatter.date(from: self)
        let epochTime = isoDate?.timeIntervalSince1970 ?? 0
        return epochTime
    }
    
    /* FUNCTION THAT GRABS A STRING DATE BASED ON THE DATE FORMAT
     PASSED THROUGH*/
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
