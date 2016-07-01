//
//  FeedViewController.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 06.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit

class FeedViewController: SpotifyItemListViewController {

    // MARK: Properties

	private lazy var searchController: UISearchController = {
		let searchController = UISearchController(searchResultsController: self.searchResultsViewController)
		searchController.searchResultsUpdater = self.searchResultsViewController
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.searchBar.placeholder = "Search"
		searchController.searchBar.barTintColor = UIColor.darklyDark()
		searchController.searchBar.tintColor = UIColor.gold()
		searchController.searchBar.delegate = self.searchResultsViewController
		return searchController
	}()

	private lazy var searchResultsViewController: SearchResultsViewController = {
		let viewController = SearchResultsViewController()
		viewController.delegate = self
		return viewController
	}()

    private let itemService = SpotifyItemService()

    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		setupSearchController()
    }

    // MARK: Private Methods

	private func setupSearchController() {
		view.addSubview(searchController.searchBar)
	}

    // MARK: Search API

    private func performSearch(query: String) {
		search(query, populateSection: artistSection)
		search(query, populateSection: albumSection)
		search(query, populateSection: trackSection)
    }

	private func search<T: SpotifyItem>(query: String, populateSection section: SpotifyItemSection<T>) {
		itemService.searchFor(query) { (response: Response<[T]>) in
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

extension FeedViewController: SearchResultsViewControllerDelegate {

	func didSelectResult(viewController: SearchResultsViewController, result: String) {
		searchController.active = false
        LastQueries.addQuery(result)
		performSearch(result)
	}
}
