//
//  Followers.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 04.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation

struct Followers {
    let href: String?
    let total: Int
}

extension Followers: JSONDecodable {
    static func decodeJSONObject(object: AnyObject) throws -> Followers {
        guard let dict = object as? [String: AnyObject],
            total = dict["total"] as? Int else {

            throw JSONDecodingError(object: object)
        }

        let href = dict["href"] as? String

        return Followers(href: href, total: total)
    }
}
