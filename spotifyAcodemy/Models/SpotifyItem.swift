//
// Created by Tomasz Mędryk on 07/04/16.
// Copyright (c) 2016 10Clouds. All rights reserved.
//

import Foundation

enum SpotifyItemType: String {
    case Album = "album"
    case Artist = "artist"
    case Track = "track"    
}

protocol SpotifyItem: JSONDecodable {
    static var type: SpotifyItemType { get }
    
    var itemId: String { get }
}
