//
//  PlayerCellViewModel.swift
//  spotifyAcodemy
//
//  Created by Cezary Kopacz on 01.07.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation
import RxSwift

class PlayerCellViewModel {
    
    private let track: Track
    
    var artist = Variable<String>("")
    var album = Variable<String>("")
    var song = Variable<String>("")
    
    init(track: Track) {
        self.track = track
        artist.value = track.artists.first?.name ?? ""
        album.value = track.album?.name ?? ""
        song.value = track.name
    }
}