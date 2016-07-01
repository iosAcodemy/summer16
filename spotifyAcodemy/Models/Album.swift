//
//  Album.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 04.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation

enum AlbumType: String {
    case Album = "album"
    case Single = "single"
    case Compilation = "compilation"
}

struct Album {
    let id: String
    let name: String
    let href: String
    let albumTypeRaw: String
    let images: [Image]
    let artists: [Artist]?
    let genres: [String]?
    let popularity: Int?
    let releaseDate: NSDate?
    let tracks: Paging?
    let typeRaw: String
    let uri: String

    var albumType: AlbumType {
        return AlbumType(rawValue: albumTypeRaw) ?? .Album
    }
}

extension Album: SpotifyItem {
    static var type: SpotifyItemType { return .Album }
    
    var itemId: String {
        return self.id
    }
}

extension Album {
    static func decodeJSONObject(object: AnyObject) throws -> Album {
        guard let dict = object as? [String: AnyObject],
            id = dict["id"] as? String,
            name = dict["name"] as? String,
            href = dict["href"] as? String,
            albumTypeRaw = dict["album_type"] as? String,
            typeRaw = dict["type"] as? String,
            uri = dict["uri"] as? String else {

            throw JSONDecodingError(object: object)
        }

        let images = try Array<Image>.decodeOptionalJSONObject(dict["images"]) ?? []
        let artists = try Array<Artist>.decodeOptionalJSONObject(dict["artists"])
        let genres = dict["genres"] as? [String]
        let popularity = dict["popularity"] as? Int
        let releaseDate = Utils.decodeOptionalDateFromString(dict["releaseDate"] as? String)
        let tracks = try Paging.decodeOptionalJSONObject(dict["tracks"])

        return Album(id: id, name: name, href: href, albumTypeRaw: albumTypeRaw,
                images: images, artists: artists, genres: genres, popularity: popularity,
                releaseDate: releaseDate, tracks: tracks, typeRaw: typeRaw, uri: uri)
    }
}
