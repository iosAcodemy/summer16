//
//  SpotifyItemSection.swift
//  spotifyAcodemy
//
//  Created by Tomasz Mędryk on 29/06/16.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation
import UIKit

protocol SpotifyItemSectionType {
	var title: String { get }
	var itemType: SpotifyItemType { get }
	var limit: Int { get }
	var expanded: Bool { get set }
	var numberOfItems: Int { get }
	var segueIdentifier: String { get }
	var cellHeight: CGFloat { get }
	var hasMore: Bool { get }
}

class SpotifyItemSection<T: SpotifyItem>: SpotifyItemSectionType {
	let title: String
	let itemType: SpotifyItemType
	var items: [T] = []
	let limit: Int
	var expanded: Bool = false
	let segueIdentifier: String
	let cellHeight: CGFloat

	var numberOfItems: Int {
		return expanded ? items.count : min(limit, items.count)
	}

	var hasMore: Bool {
		return !expanded && items.count > 0 && items.count > limit
	}

	init(title: String, itemType: SpotifyItemType, limit: Int, segueIdentifier: String, cellHeight: CGFloat) {
		self.title = title
		self.itemType = itemType
		self.limit = limit
		self.segueIdentifier = segueIdentifier
		self.cellHeight = cellHeight
	}
}
