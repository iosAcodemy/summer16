//
//  ResultsLimit.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 04.05.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation

struct ResultsLimit {
    var artists = 4
    var albums = 4
    var tracks = 8

    mutating func reset() {
        artists = 4
        albums = 4
        tracks = 8
    }
}
