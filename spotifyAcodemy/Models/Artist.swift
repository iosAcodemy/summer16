//
//  Artist.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 04.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation

struct Artist {
    let id: String
    let name: String
    let href: String
    let popularity: Int?
    let followers: Followers?
    let genres: [String]?
    let images: [Image]?
    let typeRaw: String
    let uri: String
}

extension Artist: SpotifyItem {
    static var type: SpotifyItemType { return .Artist }
    
    var itemId: String {
        return self.id
    }
}

extension Artist {
    static func decodeJSONObject(object: AnyObject) throws -> Artist {
        guard let dict = object as? [String: AnyObject],
            id = dict["id"] as? String,
            name = dict["name"] as? String,
            href = dict["href"] as? String,
            typeRaw = dict["type"] as? String,
            uri = dict["uri"] as? String else {

            throw JSONDecodingError(object: object)
        }

        let genres = dict["genres"] as? [String]
        let popularity = dict["popularity"] as? Int
        let followers = try Followers.decodeOptionalJSONObject(dict["followers"])
        let images = try Array<Image>.decodeOptionalJSONObject(dict["images"])

        return Artist(id: id, name: name, href: href, popularity: popularity,
                followers: followers, genres: genres, images: images, typeRaw: typeRaw, uri: uri)
    }
}
