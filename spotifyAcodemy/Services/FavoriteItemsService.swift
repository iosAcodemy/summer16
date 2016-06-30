//
//  FavoriteItemsService.swift
//  spotifyAcodemy
//
//  Created by Piotr Dudek on 23/06/16.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation

private enum FavoritesUserDefaultsKey: String {
    case artistsIds = "artistsIds"
    case albumsIds = "albumsIds"
    case tracksIds = "tracksIds"
}

class FavoriteItemsService {

    // MARK: Properties
    
    var favoriteArtistsIds: [String] {
        return itemsIds(.artistsIds)
    }
    var favoriteAlbumsIds: [String] {
        return itemsIds(.albumsIds)
    }
    var favoriteTracksIds: [String] {
        return itemsIds(.tracksIds)
    }
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: Public API
    
    func addToFavorites<T: SpotifyItem>(item: T) {
        switch T.type {
        case .Track:
            add(item, to: .tracksIds)
        case .Album:
            add(item, to: .albumsIds)
        case .Artist:
            add(item, to: .artistsIds)
        }
    }
    
    func removeFromFavorites<T: SpotifyItem>(item: T) {
        switch T.type {
        case .Track:
            remove(item, from: .tracksIds)
        case .Album:
            remove(item, from: .albumsIds)
        case .Artist:
            remove(item, from: .artistsIds)
        }
    }
    
    func isInFavorites<T: SpotifyItem>(item: T) -> Bool {
        switch T.type {
        case .Track:
            let items = itemsIds(.tracksIds)
            return items.contains(item.itemId)
        case .Album:
            let items = itemsIds(.albumsIds)
            return items.contains(item.itemId)
        case .Artist:
            let items = itemsIds(.artistsIds)
            return items.contains(item.itemId)
        }
    }
    
    // MARK: Private Methods
    
    private func add(item: SpotifyItem, to: FavoritesUserDefaultsKey) {
        let userDefaultsKey = to.rawValue
        
        defer {
            userDefaults.synchronize()
        }
    
        if let favoriteItemsIds = userDefaults.arrayForKey(userDefaultsKey) as? [String] {
            var itemsSet = Set(favoriteItemsIds)
            itemsSet.insert(item.itemId)
            userDefaults.setObject(Array(itemsSet), forKey: userDefaultsKey)
        } else {
            userDefaults.setObject([item.itemId], forKey: userDefaultsKey)
        }
    }
    
    private func remove(item: SpotifyItem, from: FavoritesUserDefaultsKey) {
        let userDefaultsKey = from.rawValue
        
        guard let favoriteItemsIds = userDefaults.arrayForKey(userDefaultsKey) as? [String] else {
            return
        }

        var itemsSet = Set(favoriteItemsIds)
        itemsSet.remove(item.itemId)
        userDefaults.setObject(Array(itemsSet), forKey: userDefaultsKey)
        userDefaults.synchronize()
    }
    
    private func itemsIds(forKey: FavoritesUserDefaultsKey) -> [String] {
        let userDefaultsKey = forKey.rawValue
        
        if let favoriteItemsIds = userDefaults.arrayForKey(userDefaultsKey) as? [String] {
            return favoriteItemsIds
        } else {
            return [String]()
        }
    }
}
