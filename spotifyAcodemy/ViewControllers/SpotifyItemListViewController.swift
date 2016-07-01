//
//  SpotifyItemListViewController.swift
//  spotifyAcodemy
//
//  Created by Tomasz Mędryk on 29/06/16.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation
import UIKit

class SpotifyItemListViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!

	let artistSection = SpotifyItemSection<Artist>(title: "Artists:", itemType: .Artist, limit: 4,
	                                               segueIdentifier: "showArtist", cellHeight: 45)

	let albumSection = SpotifyItemSection<Album>(title: "Albums:", itemType: .Album, limit: 4,
	                                             segueIdentifier: "showAlbum", cellHeight: 60)

	let trackSection = SpotifyItemSection<Track>(title: "Tracks:", itemType: .Track, limit: 8,
	                                             segueIdentifier: "showPlayer", cellHeight: 45)

	lazy var sections: [SpotifyItemSectionType] = [self.artistSection, self.albumSection, self.trackSection]

	private(set) var selectedIndexPath: NSIndexPath?

	// MARK: ViewController Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
	}

	// MARK: Private Methods

	private func setupTableView() {
		tableView.registerReusableCell(SearchResultTableViewCell)
		tableView.registerReusableCell(TrackResultTableViewCell)
		tableView.registerReusableHeaderFooterView(MoreResultsFooterView)
		tableView.setTableViewBackgroundGradient(UIColor.darklyDark(), UIColor.blackColor())
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -45, right: 0)
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.frame), height: 45))
	}

	// MARK: Navigation

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		clearAllNotice()

		guard let selectedRow = selectedIndexPath?.row else { return }
		selectedIndexPath = nil

		if let vc = segue.destinationViewController as? AlbumViewController {
			vc.album = albumSection.items[selectedRow]
		} else if let vc = segue.destinationViewController as? ArtistViewController {
			vc.artist = artistSection.items[selectedRow]
		} else if let vc = segue.destinationViewController as? PlayerViewController {
			let track = trackSection.items[selectedRow]
			vc.track = track
			vc.album = track.album
		}
	}
}

extension SpotifyItemListViewController: UITableViewDataSource {

	// MARK: UITableViewDataSource

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return sections.count
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].numberOfItems
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let feedSection = sections[indexPath.section]
		switch feedSection.itemType {
		case .Album: return createAlbumCellAtIndexPath(indexPath)
		case .Artist: return createArtistCellAtIndexPath(indexPath)
		case .Track: return createTrackCellAtIndexPath(indexPath)
		}
	}

	private func createAlbumCellAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
		let album = albumSection.items[indexPath.row]
		let cell: SearchResultTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
		cell.configure(name: album.name, images: album.images)
		return cell
	}

	private func createArtistCellAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
		let artist = artistSection.items[indexPath.row]
		let cell: SearchResultTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
		cell.configure(name: artist.name, images: artist.images)
		return cell
	}

	private func createTrackCellAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
		let track = trackSection.items[indexPath.row]
		let cell: TrackResultTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
		cell.configure(trackName: track.name, artistName: track.artists.first?.name, albumName: track.album?.name)
		return cell
	}
}

extension SpotifyItemListViewController: UITableViewDelegate {

	// MARK: UITableViewDelegate

	func reloadSection(section: Int) {
		tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Fade)
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return sections[indexPath.section].cellHeight
	}

	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return sections[section].hasMore ? 45.0 : CGFloat.min
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)

		selectedIndexPath = indexPath
		let section = sections[indexPath.section]
		performSegueWithIdentifier(section.segueIdentifier, sender: nil)
	}

	func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		guard sections[section].hasMore else { return nil }

		let footerView: MoreResultsFooterView? = tableView.dequeueReusableHeaderFooterView()
		footerView?.tapAction = { [unowned self] in
			self.sections[section].expanded = true
			self.reloadSection(section)
		}

		return footerView
	}

	func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int ) {
		let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
		header.contentView.backgroundColor = UIColor.darklyDark()
		header.textLabel!.textColor = UIColor.whiteColor()
		header.textLabel?.font = UIFont.boldSystemFontOfSize(12)
		header.textLabel?.textAlignment = .Left
		header.alpha = 1
	}

	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sections[section].title
	}
}
