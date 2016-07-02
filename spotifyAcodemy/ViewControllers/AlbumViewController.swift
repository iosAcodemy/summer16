//
//  AlbumViewController.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 07.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties

    @IBOutlet private weak var tableView: UITableView!
    
    var album: Album?

    private var albumId: String {
        return album?.id ?? ""
    }
    private let itemService = SpotifyItemService()
    private var tableSectionsCount: Int {
        return album != nil ? 2 : 0
    }
    private var numberOfTracks: Int {
        return album?.tracks?.items.count ?? 0
    }
    private var tracks:[Track]? {
         return album?.tracks?.items ?? nil
    }

    //MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getAlbum()
    }

    //MARK: - Private Methods
    
    private func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.addNib(.AlbumCoverTableViewCell)
        tableView.addNib(.AlbumTrackTableViewCell)
        tableView.setTableViewBackgroundGradient(UIColor.darklyDark(), UIColor.blackColor())
    }

    private func getAlbum() {
        pleaseWait()
        itemService.getItem(albumId) { (response: Response<Album>) in
            switch response {
            case .Success(let album):
                self.showAlbum(album)
            case .Error(let error):
                self.showError(error)
            }
        }
    }

    private func showAlbum(album: Album) {
        self.album = album
        clearAllNotice {
            self.title = self.album!.name
            self.tableView.reloadData()
        }
    }

    private func showError(error: NSError?) {
        clearAllNotice {
            self.showAlertOK("Error", msg: error?.localizedDescription ?? "something went wrong...")
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        clearAllNotice()
        
        if let vc = segue.destinationViewController as? ArtistViewController {
            vc.artist = album?.artists?.first
        }
    
        if let vc = segue.destinationViewController as? PlayerViewController {
            if let row = sender as? Int {
                vc.track = tracks?[row]
                vc.album = album
            }
        }
    }

    //MARK: - Table

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section

        switch (section,row) {
        case (0,0):
            let cell = tableView.dequeueReusableCellWithIdentifier(CustomCell.AlbumCoverTableViewCell.rawValue, forIndexPath: indexPath) as! AlbumCoverTableViewCell
            cell.configure(album!)
            return cell

        case (1,0...numberOfTracks - 1):
            let cell = tableView.dequeueReusableCellWithIdentifier(CustomCell.AlbumTrackTableViewCell.rawValue, forIndexPath: indexPath) as! AlbumTrackTableViewCell
            cell.configure(track: tracks![row])
            return cell

        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(CustomCell.TrackResultTableViewCell.rawValue, forIndexPath: indexPath) as! TrackResultTableViewCell
            return cell
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableSectionsCount
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = tableView.cellForRowAtIndexPath(indexPath) as? AlbumCoverTableViewCell {
            performSegueWithIdentifier("showArtist", sender: nil)
        }
        if let _ = tableView.cellForRowAtIndexPath(indexPath) as? AlbumTrackTableViewCell {
            performSegueWithIdentifier("showPlayer", sender: indexPath.row)
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return numberOfTracks
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case 0:
            return screenSize.width / 1.4
        case 1:
            return 50
        default:
            return 0
        }
    }
}
