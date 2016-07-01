//
//  ArtistViewController.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 07.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties

    @IBOutlet private  weak var tableView: UITableView!
    
    var artist: Artist!
    
    private let artistService = ArtistService()
    private let itemService = SpotifyItemService()
    private let favoritesService = FavoriteItemsService()

    private var albums = [Album]()
    private var topTracks = [Track]()
    private var relatedArtists = [Artist]()

    //MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getData()
    }

    //MARK: - Private Methods

    private func customTitle(up: String, down: String) {
        let titleView = CustomTitleView.createView(view.frame.width / 2, up: up, down: down)
        navigationItem.titleView =  titleView
    }

    private func setupUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        setupTableView()
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


    private func getData() {
        getArtist()
        getAlbums()
        getTopTracks()
        getRelatedArtists()
    }

    private func getArtist() {
        pleaseWait()
        itemService.getItem(artist.id) { (response: Response<Artist>) in
            switch response {
            case .Success(let artist):
                self.showArtist(artist)
            case .Error(let error):
                self.showError(error)
            }
        }
    }

    private func getAlbums() {
        pleaseWait()
        artistService.getAlbums(artist.id) { (response: Response) in
            switch response {
            case .Success(let albums):
                self.showAlbums(albums)
            case .Error(let error):
                self.showError(error)
            }
        }
    }

    private func getTopTracks() {
        pleaseWait()
        artistService.getTopTracks(artist.id, countryCode: "PL") { (response: Response) in
            switch response {
            case .Success(let tracks):
                self.showTopTracks(tracks)
            case .Error(let error):
                self.showError(error)
            }
        }
    }

    private func getRelatedArtists() {
        pleaseWait()
        artistService.getRelatedArtists(artist.id) { (response: Response) in
            switch response {
            case .Success(let relatedArtists):
                self.showRelatedArtists(relatedArtists)
            case .Error(let error):
                self.showError(error)
            }
        }
    }

    private func showArtist(artist: Artist) {
        self.artist = artist
        clearAllNotice {
            self.customTitle(artist.name, down: "Followers: \(artist.followers!.total)")
            self.tableView.reloadData()
        }
    }

    private func showAlbums(albums: [Album]) {
        self.albums = albums
        clearAllNotice {
            self.tableView.reloadData()
        }
    }

    private func showTopTracks(tracks: [Track]) {
        topTracks = tracks
        clearAllNotice {
            self.tableView.reloadData()
        }
    }

    private func showRelatedArtists(artists: [Artist]) {
        relatedArtists = artists
        clearAllNotice {
            self.tableView.reloadData()
        }
    }

    private func showError(error: NSError?) {
        clearAllNotice {
            if let msg =  error?.localizedDescription {
                self.showAlertOK("Error", msg: msg)
            } else {
                self.showAlertOK("Error", msg: "something went wrong...")
            }
        }
    }

    //MARK: - Table

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section

        switch (section,row) {
        case (0,0...albums.count - 1):
            let cell = tableView.dequeueReusableCellWithIdentifier(CustomCell.SearchResultTableViewCell.rawValue, forIndexPath: indexPath) as! SearchResultTableViewCell
            cell.configure(name: albums[row].name, images: albums[row].images)
            return cell
        case (1,0...topTracks.count - 1):
            let cell = tableView.dequeueReusableCellWithIdentifier(CustomCell.AlbumTrackTableViewCell.rawValue, forIndexPath: indexPath) as! AlbumTrackTableViewCell
            cell.configure(topTracks[row])
            return cell
        case (2,0...relatedArtists.count - 1):
            let cell = tableView.dequeueReusableCellWithIdentifier(CustomCell.SearchResultTableViewCell.rawValue, forIndexPath: indexPath) as! SearchResultTableViewCell
            cell.configure(name: relatedArtists[row].name, images: relatedArtists[row].images!)
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(CustomCell.AlbumTrackTableViewCell.rawValue, forIndexPath: indexPath) as! AlbumTrackTableViewCell
            return cell
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return albums.count
        case 1:
            return topTracks.count
        case 2:
            return relatedArtists.count
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let section = indexPath.section

        switch section {
        case 0 :
            let storyboard = UIStoryboard(name: "Album", bundle: nil)
            let vcontroller = storyboard.instantiateViewControllerWithIdentifier("albumViewController") as! AlbumViewController
            vcontroller.album = albums[row]
            navigationController?.pushViewController(vcontroller, animated: true)
        case 1 :
            let storyboard = UIStoryboard(name: "Player", bundle: nil)
            let vcontroller = storyboard.instantiateViewControllerWithIdentifier("PlayerViewController") as! PlayerViewController
            vcontroller.track = topTracks[row]
            navigationController?.pushViewController(vcontroller, animated: true)
        case 2 :
            let storyboard = UIStoryboard(name: "Artist", bundle: nil)
            let vcontroller = storyboard.instantiateViewControllerWithIdentifier("ArtistViewController") as! ArtistViewController
            vcontroller.artist = relatedArtists[row]
            navigationController?.pushViewController(vcontroller, animated: true)
        default:
            return
        }
    }

    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int ) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 29.0/255.0, alpha: 1)
        header.textLabel!.textColor = UIColor.whiteColor()
        header.textLabel?.font = UIFont.boldSystemFontOfSize(12)
        header.textLabel?.textAlignment = .Left
        header.alpha = 1
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Albums:"
        case 1:
            return "Top Tracks:"
        case 2:
            return "Related Artists:"
        default:
            return ""
        }
    }
    

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case 0:
            return 60
        case 1:
            return 45
        case 2:
            return 60
        default:
            return 0
        }
    }
}

extension ArtistViewController: ArtistHeaderViewDelegate {
    
    func didTapAddToFavorites() {
        guard let artist = artist else { return }
        favoritesService.addToFavorites(artist)
    }
    
    func didTapRemoveFromFavorites() {
        guard let artist = artist else { return }
        favoritesService.removeFromFavorites(artist)
    }
}
