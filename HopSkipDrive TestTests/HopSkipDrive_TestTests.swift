//
//  HopSkipDrive_TestTests.swift
//  HopSkipDrive TestTests
//
//  Created by Benjamin VanCleave on 7/20/21.
//

import XCTest
@testable import HopSkipDrive_Test

class HopSkipDrive_TestTests: XCTestCase {
    var rides: [[Ride]]!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        if let testData = getRideTestDataFromFile() {
            rides = Api.Rides.parseMyRideData(dataString: testData)
        }
    }
    
    func testIfRideObjectNotNil() {
        XCTAssertFalse(rides.isEmpty, "Rides are empty, something went wrong when parsing data")
    }
    
    func testRideGroupingOnDay() {
        XCTAssertEqual(rides.count, 2, "Rides were group incorrectly based on days")
        XCTAssertEqual(rides.first?.count, 3, "Rides for that given day are off count")
    }
    
    func testUniquePassengers() {
        if let firstRide = rides.first?.first {
            let passengers = firstRide.getUniquePassengers()
            let ids = passengers.map({$0.id})
            XCTAssertEqual(ids, [123,121], "There was an issue getting unique passengers based on ID")
        }
    }
    
    override func tearDownWithError() throws {
        rides?.removeAll()
        rides = nil
        try super.tearDownWithError()
    }
    
    /* GETTING RIDE TEST DATA FROM JSON FILE */
    func getRideTestDataFromFile() -> String? {
        if let rideFile = Bundle.main.path(forResource: "ride_data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: rideFile), options: .mappedIfSafe)
                let dataString = String(data: data, encoding: .utf8)
                return dataString
            } catch {
                print(error)
            }
        }
        return nil
    }
}
