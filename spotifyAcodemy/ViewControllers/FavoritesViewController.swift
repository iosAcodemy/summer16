//
//  FavoritesViewController.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 06.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit

class FavoritesViewController: SpotifyItemListViewController {

    // MARK: Properties

    private let favoriteService = FavoriteItemsService()
    private let itemService = SpotifyItemService()
    
    // MARK: ViewController Lifecycle

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
		fetchItems()
    }
    
    // MARK: Private Methods

	private func fetchItems() {
		fetchItems(favoriteService.favoriteArtistsIds, populateSection: artistSection)
		fetchItems(favoriteService.favoriteAlbumsIds, populateSection: albumSection)
		fetchItems(favoriteService.favoriteTracksIds, populateSection: trackSection)
	}

	private func fetchItems<T: SpotifyItem>(ids: [String], populateSection section: SpotifyItemSection<T>) {
		itemService.getItems(ids) { (response: Response<[T]>) in
			switch response {
			case .Success(let items):
				section.items = items ?? []
				section.expanded = false
				self.clearAllNotice {
					self.tableView.reloadData()
				}
			case .Error(let error):
				debugPrint(error)
			}
		}
	}
}
