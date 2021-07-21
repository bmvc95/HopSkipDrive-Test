//
//  MyRideApi.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import Foundation

class MyRideApi {
    
    func retrieveRides(complete: @escaping([MyRide]?) -> Void) {
        if let url = URL(string: "https://storage.googleapis.com/hsd-interview-resources/simplified_my_rides_response.json") {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self else { return }
                // ALWAYS GOOD TO USE WEAK SELF, BUT ONE INSTANCE OF MYRIDEAPI WILL EVER EXIST
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    let myRides = self.parseMyRideData(dataString: dataString)
                    complete(myRides)
                } else {
                    complete(nil)
                }
            }
            task.resume()
        } else {
            print("problem with url")
            complete(nil)
        }
    }
    
    private func parseMyRideData(dataString: String) -> [MyRide]? {
        if let dict = dataString.convertToDict() {
            if let ridesArray = dict["rides"] as? NSArray {
                var myRides: [MyRide] = []
                for ride in ridesArray {
                    if let rideDict = ride as? [String: Any] {
                        let rideModel = MyRide.transformData(data: rideDict)
                        myRides.append(rideModel)
                    }
                }
                return myRides
            }
        }
        return nil
    }
}
