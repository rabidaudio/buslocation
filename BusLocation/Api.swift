//
//  Api.swift
//  BusLocation
//
//  Created by Charles Julian Knight on 11/7/16.
//  Copyright © 2016 FIXD Automotive Inc. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Alamofire
import RxAlamofire

class Api {
    
    static let baseUrl = URL(string: "http://developer.itsmarta.com/BRDRestService/RestBusRealTimeService/GetBusByRoute/")!
    
    func getBusInfo(route: String) -> Observable<[BusLocation]> {
        return rJSONDeserializableArray(.get, URL(string: route, relativeTo: Api.baseUrl)!)
    }
}


enum JSONError: Error {
    case SerializationError
}

fileprivate func responseJSON(_ method: Alamofire.HTTPMethod, _ url: URLConvertible, parameters: [String : Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, headers: [String : String]? = nil) -> RxSwift.Observable<(HTTPURLResponse, JSON)> {
    return RxAlamofire.requestString(method, url, parameters: parameters, encoding: encoding, headers: headers).map { res, string in
        return (res, JSON.parse(string))
    }
}

fileprivate func rJSONDeserializable<T: JSONDeserializable>(_ method: Alamofire.HTTPMethod, _ url: URLConvertible, parameters: [String : Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, headers: [String : String]? = nil) -> RxSwift.Observable<T> {
    return responseJSON(method, url, parameters: parameters, encoding: encoding, headers: headers).flatMap { res, json -> Observable<T> in
        if let t = T.init(json: json) {
            return RxSwift.Observable.just(t)
        }else{
            return RxSwift.Observable.error(JSONError.SerializationError)
        }
    }
}

fileprivate func rJSONDeserializableArray<T: JSONDeserializable>(_ method: Alamofire.HTTPMethod, _ url: URLConvertible, parameters: [String : Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, headers: [String : String]? = nil) -> RxSwift.Observable<[T]> {
    return responseJSON(method, url, parameters: parameters, encoding: encoding, headers: headers).flatMap { res, json -> Observable<[T]> in
        if let a = json.array {
            var results = [T]()
            for item in a {
                if let t = T.init(json: item) {
                    results.append(t)
                }
            }
            return RxSwift.Observable.just(results)
        }else{
            return RxSwift.Observable.error(JSONError.SerializationError)
        }
    }
}
