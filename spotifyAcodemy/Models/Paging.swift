//
//  Paging.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 04.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation

struct Paging {
    let href: String
    let items: [Track]
    let limit: Int
    let next: String?
    let previous: String?
    let offset: Int
    let total: Int
}

extension Paging: JSONDecodable {
    static func decodeJSONObject(object: AnyObject) throws -> Paging {
        guard let dict = object as? [String: AnyObject],
            href = dict["href"] as? String,
            items = try Array<Track>.decodeOptionalJSONObject(dict["items"]),
            limit = dict["limit"] as? Int,
            offset = dict["offset"] as? Int,
            total = dict["total"] as? Int else {

            throw JSONDecodingError(object: object)
        }

        let previous = dict["previous"] as? String
        let next = dict["next"] as? String

        return Paging(href: href, items: items, limit: limit, next: next,
                previous: previous, offset: offset, total: total)
    }
}
