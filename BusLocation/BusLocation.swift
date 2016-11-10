//
//  BusLocation.swift
//  BusLocation
//
//  Created by Charles Julian Knight on 11/7/16.
//  Copyright © 2016 FIXD Automotive Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

/*
 {
     "ADHERENCE": "0",
     "BLOCKID": "333",
     "BLOCK_ABBR": "21-8",
     "DIRECTION": "Westbound",
     "LATITUDE": "33.7497523",
     "LONGITUDE": "-84.3851763",
     "MSGTIME": "11/7/2016 10:22:55 PM",
     "ROUTE": "21",
     "STOPID": "210431",
     "TIMEPOINT": "Georgia State Station",
     "TRIPID": "5330466",
     "VEHICLE": "1512"
 }
 */
struct BusLocation: JSONDeserializable {
    
    private static let dateFormat: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "M/d/y h:m:s a"
        df.timeZone = TimeZone(identifier: "America/New_York")
        df.locale = Locale(identifier: "en-US")
        return df
    }()
    
    public typealias Adherance = Int
    
    enum Direction: String {
        case northbound = "Northbound"
        case southbound = "Southbound"
        case eastbound = "Eastbound"
        case westbound = "Westbound"
    }
    
    let adherance: Adherance
    let blockId: String
    let blockAbr: String
    let direction: Direction
    let latitude: Double
    let longitude: Double
    let msgTime: Date
    let route: String
    let stopId: String
    let timepoint: String
    let tripId: String
    let vehicle: String
    
    init?(json: JSON){
        guard
            let adheranceStr = json["ADHERENCE"].string,
            let adherance = Int(adheranceStr),
            let blockId = json["BLOCKID"].string,
            let blockAbr = json["BLOCK_ABBR"].string,
            let directionStr = json["DIRECTION"].string,
            let direction = Direction(rawValue: directionStr),
            let latitudeStr = json["LATITUDE"].string,
            let latitude = Double(latitudeStr),
            let longitudeStr = json["LONGITUDE"].string,
            let longitude = Double(longitudeStr),
            let msgTimeStr = json["MSGTIME"].string,
            let msgTime = BusLocation.dateFormat.date(from: msgTimeStr),
            let route = json["ROUTE"].string,
            let stopId = json["STOPID"].string,
            let timepoint = json["TIMEPOINT"].string,
            let tripId = json["TRIPID"].string,
            let vehicle = json["VEHICLE"].string
        else {
            return nil
        }
        self.adherance = adherance
        self.blockId = blockId
        self.blockAbr = blockAbr
        self.direction = direction
        self.latitude = latitude
        self.longitude = longitude
        self.msgTime = msgTime
        self.route = route
        self.stopId = stopId
        self.timepoint = timepoint
        self.tripId = tripId
        self.vehicle = vehicle
    }
}

extension BusLocation.Adherance {
    var isLate: Bool {
        return self < 0
    }
    
    var isEarly: Bool {
        return self > 0
    }
    
    var isOnTime: Bool {
        return self == 0
    }
}
