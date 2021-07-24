//
//  MyRideApi.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import Foundation

class RidesApi {
    
    /* NORMALLY WHEN WE ARE RETRIEVING DATA LIKE THIS, BASED ON THE DATA SET SIZE,
     WE WOULD WANT TO QUERY 10 AT TIME, PREFERABLY BASED OFF EPOCH OR SOME UID,
     BUT FOR THIS PROJECT, THE DATA SET IS LIMITED AND SMALL. TOO MUCH NETWORK TRAFFIC
     WILL BOG DOWN THE DEVICE AND DECREASE UX */
    
    
    /* FUNCTION TO RETRIEVE RIDE DETAILS FOR A GIVEN USER */
    func retrieveRides(complete: @escaping([[Ride]]?) -> Void) {
        if let url = URL(string: "https://storage.googleapis.com/hsd-interview-resources/simplified_my_rides_response.json") {
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    // ALWAYS GOOD TO USE WEAK SELF, BUT ONE INSTANCE OF MYRIDEAPI WILL EVER EXIST
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        let myRides = self.parseMyRideData(dataString: dataString)
                        complete(myRides)
                    } else {
                        complete(nil)
                    }
                }
            }
            task.resume()
        } else {
            print("problem with url")
            complete(nil)
        }
    }
    
    /* PARSING FUNCTION TO HELP CONVERT THE DATA INTO AN ARRAY OF RIDE OBJECTS */
    func parseMyRideData(dataString: String) -> [[Ride]]? {
        if let dict = dataString.convertToDict() {
            if let ridesArray = dict["rides"] as? NSArray {
                var myRides: [Ride] = []
                for ride in ridesArray {
                    if let rideDict = ride as? [String: Any] {
                        let rideModel = Ride.transformData(data: rideDict)
                        myRides.append(rideModel)
                    }
                }
                myRides = myRides.sorted(by: {$0.startsAt?.epochFromIso() ?? 0 < $1.startsAt?.epochFromIso() ?? 0})
                return groupRidesOnDate(myRides)
            }
        }
        return nil
    }
    
    /* FUNCTION THAT CREATES TWO DIMENSION ARRAY OF RIDES TO ALLOW FOR
     EASIER SORTING */
    func groupRidesOnDate(_ myRides: [Ride]) -> [[Ride]] {
        var rides: [[Ride]] = []
        for i in 0..<myRides.count {
            let currentISODate = myRides[i].startsAt?.dateFromIso(format: "MM/dd/yy")
            if i != 0 {
                let previosISODate = myRides[i - 1].startsAt?.dateFromIso(format: "MM/dd/yy")
                if currentISODate != previosISODate {
                    rides.append([myRides[i]])
                } else {
                    rides[rides.count - 1].append(myRides[i])
                }
            } else {
                rides.append([myRides[i]])
            }
        }
        return rides
    }
}
