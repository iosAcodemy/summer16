//
//  ArtistViewController.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 07.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController {

    // MARK: Properties

    @IBOutlet private  weak var tableView: UITableView!
    
    var artist: Artist!
    
    private let albumSection = SpotifyItemSection<Album>(title: "Albums:", itemType: .Album, limit: 4,
                                                 segueIdentifier: "", cellHeight: 60)
    
    private let trackSection = SpotifyItemSection<Track>(title: "Tracks:", itemType: .Track, limit: 8,
                                                 segueIdentifier: "", cellHeight: 45)
    
    private lazy var sections: [SpotifyItemSectionType] = [self.albumSection, self.trackSection]
    private let artistService = ArtistService()
    private let itemService = SpotifyItemService()
    private let favoritesService = FavoriteItemsService()

    //MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getArtistData()
    }

    //MARK: - Private Methods

    private func setupUI() {
        customTitle(artist.name, down: "Followers: \(artist.followers!.total)")
        setupTableView()
    }

    private func customTitle(up: String, down: String) {
        let titleView = CustomTitleView.createView(view.frame.width / 2, up: up, down: down)
        navigationItem.titleView = titleView
    }

    private func setupTableView() {
        tableView.registerReusableCell(AlbumTrackTableViewCell)
        tableView.registerReusableCell(SearchResultTableViewCell)
        tableView.registerReusableHeaderFooterView(MoreResultsFooterView)
        
        tableView.setTableViewBackgroundGradient(UIColor.darklyDark(), UIColor.blackColor())
        
        tableView.tableHeaderView = {
            let headerView = NSBundle.mainBundle().loadNibNamed("ArtistHeaderView", owner: tableView, options: nil).first!
                as! ArtistHeaderView
            
            headerView.frame = CGRect(x: 0, y: 0, width: 0, height: 225)
            headerView.configure(artist, isInFavorites: favoritesService.isInFavorites(artist))
            headerView.delegate = self
            return headerView
        }()
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -45, right: 0)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.frame), height: 45))
    }
    
    private func getArtistData() {
        getAlbums(artist, populateSection: albumSection)
        getTopTracks(artist, populateSection: trackSection)
    }

    private func getAlbums(artist: Artist, populateSection section: SpotifyItemSection<Album>) {
        artistService.getAlbums(artist.id) { (response: Response) in
            switch response {
            case .Success(let albums):
                section.typedItems = albums ?? []
                section.expanded = false
                self.clearAllNotice {
                    self.tableView.reloadData()
                }
            case .Error(let error):
                self.showError(error)
            }
        }
    }
    
    private func getTopTracks(artist: Artist, populateSection section: SpotifyItemSection<Track>) {
        artistService.getTopTracks(artist.id, countryCode: "PL") { (response: Response) in
            switch response {
            case .Success(let tracks):
                section.typedItems = tracks
                section.expanded = false
                self.clearAllNotice {
                    self.tableView.reloadData()
                }
            case .Error(let error):
                self.showError(error)
            }
        }
    }
    
    private func createAlbumCellAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let album = albumSection.typedItems[indexPath.row]
        let cell: SearchResultTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(name: album.name, images: album.images)
        return cell
    }
    
    private func createTrackCellAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        let track = trackSection.typedItems[indexPath.row]
        let cell: AlbumTrackTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(track: track)
        return cell
    }

    private func showError(error: NSError?) {
        clearAllNotice {
            self.showAlertOK("Error", msg: error?.localizedDescription ?? "something went wrong...")
        }
    }
    
    private func pushAlbumViewController(album: Album) {
        let storyboard = UIStoryboard(name: "Album", bundle: nil)
        let vcontroller = storyboard.instantiateViewControllerWithIdentifier("albumViewController") as! AlbumViewController
        vcontroller.album = album
        navigationController?.pushViewController(vcontroller, animated: true)
    }
    
    private func pushPlayerViewController(track: Track) {
        let storyboard = UIStoryboard(name: "Player", bundle: nil)
        let vcontroller = storyboard.instantiateViewControllerWithIdentifier("PlayerViewController") as! PlayerViewController
        vcontroller.track = track
        vcontroller.album = track.album
        navigationController?.pushViewController(vcontroller, animated: true)
    }
}

// MARK: - UITableViewDataSource
    
extension ArtistViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let feedSection = sections[indexPath.section]
        switch feedSection.itemType {
        case .Album: return createAlbumCellAtIndexPath(indexPath)
        case .Track: return createTrackCellAtIndexPath(indexPath)
        case .Artist: fatalError("Artist section should not appear in \(self)")
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfItems
    }
}

// MARK: - UITableViewDelegate

extension ArtistViewController: UITableViewDelegate {

    func reloadSection(section: Int) {
        tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Fade)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let feedSection = sections[indexPath.section]
        switch feedSection.itemType {
        case .Album: return pushAlbumViewController(albumSection.typedItems[indexPath.row])
        case .Track: return pushPlayerViewController(trackSection.typedItems[indexPath.row])
        case .Artist: fatalError("Artist section should not appear in \(self)")
        }
    }

    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int ) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.darklyDark()
        header.textLabel?.textColor = UIColor.whiteColor()
        header.textLabel?.font = UIFont.boldSystemFontOfSize(12)
        header.textLabel?.textAlignment = .Left
        header.alpha = 1
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].hasMore ? 45.0 : CGFloat.min
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return sections[indexPath.section].cellHeight
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
}

// MARK: - ArtistHeaderCellDelegate

extension ArtistViewController: ArtistHeaderViewDelegate {
    
    func didTapAddToFavorites() {
        favoritesService.addToFavorites(artist)
    }
    
    func didTapRemoveFromFavorites() {
        favoritesService.removeFromFavorites(artist)
    }
}
