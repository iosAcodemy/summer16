//
// Created by Tomasz Mędryk on 05/04/16.
// Copyright (c) 2016 10Clouds. All rights reserved.
//

import Foundation

class AlbumService {

    func getTracks(id: String, completionHandler: (Response<[Track]>) -> Void) {
        api.requestObjects(.AlbumTracks(id: id), completionHandler: completionHandler)
    }

}
