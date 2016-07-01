//
//  Track.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 04.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation

struct Track {
    let id: String
    let name: String
    let popularity: Int?
    let previewUrl: String?
    let trackNumber: Int
    let artists: [Artist]
    let album: Album?
    let durationMs: Int
    let href: String
    let typeRaw: String
    let uri: String
}

extension Track: SpotifyItem {
    static var type: SpotifyItemType { return .Track }
    
    var itemId: String {
        return self.id
    }
}

extension Track {
    static func decodeJSONObject(object: AnyObject) throws -> Track {
		//Module 1 - Task 5
		guard let dict = object as? [String: AnyObject],
			id = dict["id"] as? String,
			name = dict["name"] as? String,
			trackNumber = dict["track_number"] as? Int,
			durationMs = dict["duration_ms"] as? Int,
			href = dict["href"] as? String,
			typeRaw = dict["type"] as? String,
			uri = dict["uri"] as? String else {

				throw JSONDecodingError(object: object)
		}

		let popularity = dict["popularity"] as? Int
		let previewUrl = dict["preview_url"] as? String
		let artists = try Array<Artist>.decodeOptionalJSONObject(dict["artists"]) ?? []
		let album = try Album.decodeOptionalJSONObject(dict["album"])

		return Track(id: id, name: name, popularity: popularity, previewUrl: previewUrl,
		             trackNumber: trackNumber, artists: artists, album: album, durationMs: durationMs,
		             href: href, typeRaw: typeRaw, uri: uri)
    }
}
