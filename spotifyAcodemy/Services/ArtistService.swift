//
// Created by Tomasz Mędryk on 05/04/16.
// Copyright (c) 2016 10Clouds. All rights reserved.
//

import Foundation

class ArtistService {

    func getAlbums(id: String, completionHandler: (Response<[Album]>) -> Void) {
        api.requestObjects(.ArtistAlbums(id: id), completionHandler: completionHandler)
    }

    func getTopTracks(id: String, countryCode: String, completionHandler: (Response<[Track]>) -> Void) {
        api.requestObjects(.ArtistTopTracks(id: id, countryCode: countryCode), completionHandler: completionHandler)
    }

    func getRelatedArtists(id: String, completionHandler: (Response<[Artist]>) -> Void) {
        api.requestObjects(.ArtistRelatedArtists(id: id), completionHandler: completionHandler)
    }

}
