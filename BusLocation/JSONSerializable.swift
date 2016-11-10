//
//  JSONSerializable.swift
//  BusLocation
//
//  Created by Charles Julian Knight on 11/7/16.
//  Copyright © 2016 FIXD Automotive Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONSerializable {
    var JSON: JSON { get }
}

protocol JSONDeserializable {
    init?(json: JSON)
}

protocol JSONConvertible: JSONSerializable, JSONDeserializable {}

// protocol JSONRepresentable {
//     var JSONRepresentation: Any { get }
// }

// protocol RawJSONRepresentable: JSONRepresentable {}
// extension RawJSONRepresentable {
//     var JSONRepresentation: Any {
//         return self
//     }
// }

// extension NSString: RawJSONRepresentable {}
// extension NSNumber: RawJSONRepresentable {}
// extension NSNull: RawJSONRepresentable {}
// extension NSArray: RawJSONRepresentable {}
// extension NSDictionary: RawJSONRepresentable {}

// extension String: JSONRepresentable {
//     var JSONRepresentation: Any {
//         return NSString(string: self) //as AnyObject
//     }
// }

// fileprivate protocol NSNuberConvertible {
//     var toNSNumber: NSNumber { get }
// }
// extension Int:    NSNuberConvertible { var toNSNumber: NSNumber { return NSNumber(value: self) } }
// extension Double: NSNuberConvertible { var toNSNumber: NSNumber { return NSNumber(value: self) } }
// extension Float:  NSNuberConvertible { var toNSNumber: NSNumber { return NSNumber(value: self) } }
// extension Int8:   NSNuberConvertible { var toNSNumber: NSNumber { return NSNumber(value: self) } }
// extension Int16:  NSNuberConvertible { var toNSNumber: NSNumber { return NSNumber(value: self) } }
// extension Int32:  NSNuberConvertible { var toNSNumber: NSNumber { return NSNumber(value: self) } }
// extension Int64:  NSNuberConvertible { var toNSNumber: NSNumber { return NSNumber(value: self) } }
// extension UInt:   NSNuberConvertible { var toNSNumber: NSNumber { return NSNumber(value: self) } }
// extension UInt8:  NSNuberConvertible { var toNSNumber: NSNumber { return NSNumber(value: self) } }
// extension UInt16: NSNuberConvertible { var toNSNumber: NSNumber { return NSNumber(value: self) } }
// extension UInt32: NSNuberConvertible { var toNSNumber: NSNumber { return NSNumber(value: self) } }
// extension UInt64: NSNuberConvertible { var toNSNumber: NSNumber { return NSNumber(value: self) } }
// extension Bool:   NSNuberConvertible { var toNSNumber: NSNumber { return NSNumber(value: self) } }

// extension NSNuberConvertible: JSONRepresentable {
//     var JSONRepresentation: Any {
//         return toNSNumber
//     }
// }

// protocol SerializeMapping {
//     var JSONKey: String { get }
//     var serializer: ((Any) -> Any) { get }
// }

// extension String {
//     fileprivate func loweredFirstLetter() -> String {
//         var clone = String(self.characters)
//         let firstLetter = clone.remove(at: clone.startIndex)
//         return String(firstLetter).lowercased() + clone
//     }
//     fileprivate func snakeCased() -> String {
//         var result = ""
//         for c in self.loweredFirstLetter().characters {
//             let sc = String(c)
//             if sc == sc.lowercased() {
//                 result += sc
//             }else{
//                 result += "_\(sc.lowercased())"
//             }
//         }
//         return result
//     }
// }

// fileprivate let NO_OP: (Any) -> Any = { $0 }

// fileprivate class DefaultSerializeMapping: SerializeMapping {
//     let JSONKey: String
//     let serializer: ((Any) -> Any) = NO_OP
    
//     init(field: String){
//         self.JSONKey = field.snakeCased()
//     }
// }

// protocol JSONSerializable: JSONRepresentable {
//     var serializeMappings: [String: SerializeMapping] { get }
// }

// extension JSONSerializable {
    
//     var serializeMappings: [String: SerializeMapping] {
//         var mappings = [String: SerializeMapping]()
//         for case let (label?, _) in Mirror(reflecting: self).children {
//             mappings[label] = DefaultSerializeMapping(field: label)
//         }
//         return mappings
//     }
    
//     var JSONRepresentation: Any {
//         var representation = [String: Any]()
        
//         let mappings = self.serializeMappings
        
//         for case let (label?, value) in Mirror(reflecting: self).children {
//             switch value {
//             case let value as JSONRepresentable:
//                 if let mapping = mappings[label] {
//                     representation[mapping.JSONKey] = mapping.serializer(value.JSONRepresentation)
//                 }
//             default:
//                 // Ignore any unserializable properties
//                 break
//             }
//         }
        
//         return representation
//     }
// }

// extension JSONRepresentable {
//     var JSON: String? {
//         guard JSONSerialization.isValidJSONObject(self) else {
//             return nil
//         }
//         do {
//             let data = try JSONSerialization.data(withJSONObject: self, options: [])
//             return String(data: data, encoding: String.Encoding.utf8)
//         } catch {
//             return nil
//         }
//     }
// }

//extension JSONSerializable {
//    func toJSON() -> String? {
//        let representation = JSONRepresentation
//        
//        guard JSONSerialization.isValidJSONObject(representation) else {
//            return nil
//        }
//        
//        do {
//            let data = try JSONSerialization.data(withJSONObject: representation, options: [])
//            return String(data: data, encoding: String.Encoding.utf8)
//        } catch {
//            return nil
//        }
//    }
//}

