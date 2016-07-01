//
// Created by Tomasz Mędryk on 08/04/16.
// Copyright (c) 2016 10Clouds. All rights reserved.
//

import Foundation

class SpotifyItemService {

    func getItems<T: SpotifyItem>(ids: [String], completionHandler: (Response<[T]>) -> Void) {
        let endpoint: API.Endpoint

        switch T.type {
        case .Track:
            endpoint = .Tracks(ids: ids)
        case .Album:
            endpoint = .Albums(ids: ids)
        case .Artist:
            endpoint = .Artists(ids: ids)
		}

        api.requestObjects(endpoint, completionHandler: completionHandler)
    }

    func getItem<T: SpotifyItem>(id: String, completionHandler: (Response<T>) -> Void) {
        let endpoint: API.Endpoint

        switch T.type {
        case .Track:
            endpoint = .Track(id: id)
        case .Album:
            endpoint = .Album(id: id)
        case .Artist:
            endpoint = .Artist(id: id)
        }

        api.requestObject(endpoint, completionHandler: completionHandler)
    }

    func searchFor<T: SpotifyItem>(query: String, completionHandler: (Response<[T]>) -> Void) {
        api.requestObjects(.Search(query: query, type: T.type), completionHandler: completionHandler)
    }

}
