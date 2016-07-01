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
		return Track(id: "", name: "", popularity: nil, previewUrl: nil, trackNumber: 0, artists: [], album: nil, durationMs: 0, href: "", typeRaw: "", uri: "")
    }
}
