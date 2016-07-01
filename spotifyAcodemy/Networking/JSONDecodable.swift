//
// Created by Tomasz Mędryk on 12/04/16.
// Copyright (c) 2016 10Clouds. All rights reserved.
//

import Foundation

struct JSONDecodingError: ErrorType, CustomDebugStringConvertible {
    let object: AnyObject

    var debugDescription: String {
        return "JSON decoding failed \(object)"
    }
}

typealias JSON = [String: AnyObject]

protocol JSONDecodable {
    static func decodeJSONObject(object: AnyObject) throws -> Self
    static func decodeOptionalJSONObject(optionalObject: AnyObject?) throws -> Self?
}

extension JSONDecodable {
    static func decodeOptionalJSONObject(optionalObject: AnyObject?) throws -> Self? {
        guard let object = optionalObject else {
            return nil
        }

        return try decodeJSONObject(object)
    }
}

extension Array where Element: JSONDecodable {
    static func decodeJSONObject(object: AnyObject) throws -> [Element] {
        guard let jsonArray = object as? [AnyObject] else {
            throw JSONDecodingError(object: object)
        }

        return try jsonArray.map { try Element.decodeJSONObject($0) }
    }

    static func decodeOptionalJSONObject(optionalObject: AnyObject?) throws -> [Element]? {
        guard let object = optionalObject as? [AnyObject] else {
            return nil
        }

        return try decodeJSONObject(object)
    }
}
