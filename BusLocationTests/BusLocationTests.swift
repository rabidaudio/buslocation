//
//  BusLocationTests.swift
//  BusLocationTests
//
//  Created by Charles Julian Knight on 11/7/16.
//  Copyright © 2016 FIXD Automotive Inc. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import BusLocation

class BusLocationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUrl(){
        let s = "http://developer.itsmarta.com/BRDRestService/RestBusRealTimeService/GetBusByRoute/"
        
        let b = URL(string: s)!
        
        let r = URL(string: "21", relativeTo: b)!
        
        XCTAssertEqual(r.absoluteString, "\(s)21")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let json = "{\"ADHERENCE\": \"0\",\"BLOCKID\": \"333\",\"BLOCK_ABBR\": \"21-8\",\"DIRECTION\": \"Westbound\",\"LATITUDE\": \"33.7497523\",\"LONGITUDE\": \"-84.3851763\",\"MSGTIME\": \"11/7/2016 10:22:55 PM\", \"ROUTE\": \"21\", \"STOPID\": \"210431\", \"TIMEPOINT\": \"Georgia State Station\", \"TRIPID\": \"5330466\", \"VEHICLE\": \"1512\"}";
        
        let bus = BusLocation(json: JSON.parse(json))
        
        XCTAssert(bus != nil)
        
        XCTAssert(bus!.adherance.isOnTime)
        
        XCTAssert(bus!.blockId == "333")
        XCTAssert(bus!.blockAbr == "21-8")
        XCTAssert(bus!.direction == .westbound)
        XCTAssert(bus!.latitude == 33.7497523)
        XCTAssert(bus!.longitude == -84.3851763)
        XCTAssert(bus!.msgTime.timeIntervalSince1970 == 1478575375)
        XCTAssert(bus!.route == "21")
        XCTAssert(bus!.stopId == "210431")
        XCTAssert(bus!.timepoint == "Georgia State Station")
        XCTAssert(bus!.tripId == "5330466")
        XCTAssert(bus!.vehicle == "1512")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
