//
//  PlayerViewController.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 07.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    // MARK: Properties

    @IBOutlet private weak var tableView: UITableView!

    var album: Album!
    var track: Track!

    private var player = AVPlayer()
    private var isPlaying = false
    private var trackId: String {
        return track?.id ?? ""
    }
    private let itemService = SpotifyItemService()
    private var tableSections: Int {
        return track != nil ? 2 : 0
    }
    private var currentPlayerItem: AVPlayerItem {
        return  player.currentItem!
    }
    private var duration: CMTime  {
        return currentPlayerItem.asset.duration
    }
    private var currentTime: CMTime {
        return player.currentTime()
    }

    //MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NSNotificationCenter.defaultCenter()
            .addObserver(self,
                         selector: #selector(PlayerViewController.playerDidFinishPlaying(_:)),
                         name: AVPlayerItemDidPlayToEndTimeNotification,
                         object: player.currentItem)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        NSNotificationCenter.defaultCenter().removeObserver(self)
        player.pause()
    }
    
    // MARK: Public API

    func playerDidFinishPlaying(note: NSNotification) {
        NSNotificationCenter.defaultCenter().postNotificationName("playerDidFinishPlaying", object: nil)
    }
    
    //MARK: - Private Methods

    private func setupUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        title = track?.name
        setupTableView()
    }

    private  func setupTableView() {
        tableView.addNib(CustomCell.AlbumCoverTableViewCell)
        tableView.addNib(CustomCell.PlayerTableViewCell)

        tableView.setTableViewBackgroundGradient(UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 29.0/255.0, alpha: 1.0), UIColor.blackColor())
    }
    
    private func getTrack() {
        pleaseWait()
        itemService.getItem(trackId) { (response: Response<Track>) in
            switch response {
            case .Success(let track):
                self.showTrack(track)
            case .Error(let error):
                self.showError(error)
            }
        }
    }

    private func showTrack(track: Track) {
        self.track = track
        clearAllNotice {
            self.title = track.name
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

    // MARK: Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? AlbumViewController {
            vc.album = track?.album
        }
    }
}

extension PlayerViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        switch (section,row) {
        case (0,0):
            let cell = tableView.dequeueReusableCellWithIdentifier(CustomCell.AlbumCoverTableViewCell.rawValue, forIndexPath: indexPath) as! AlbumCoverTableViewCell
            cell.configure(album!)
            return cell
        case(1,0):
            let cell = tableView.dequeueReusableCellWithIdentifier(CustomCell.PlayerTableViewCell.rawValue, forIndexPath: indexPath) as! PlayerTableViewCell
            cell.viewModel = PlayerCellViewModel(track: track)
            cell.delegate = self
            return cell

        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(CustomCell.AlbumCoverTableViewCell.rawValue, forIndexPath: indexPath) as! AlbumCoverTableViewCell
            cell.configure(album!)
            return cell
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            performSegueWithIdentifier("showAlbum", sender: nil)
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0...1:
            return 1
        default:
            return 0
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableSections
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case 0:
            return screenSize.width / 1.4
        case 1:
            return screenSize.height - screenSize.width / 1.4
        default:
            return 0
        }
    }
}

extension PlayerViewController: PlayerCellDelegate  {

    func pause(currentTime: (time: Int) -> ()) {
        player.pause()

        let floatTime = Int(Float(10 * CMTimeGetSeconds(player.currentTime())))
        currentTime(time: floatTime)
    }

    func playerPlay() {
        player.play()
    }

    func playTrack() {
        guard let track = track,
            url = track.previewUrl,
            sound = NSURL(string: url)
            else { return }

        let playerItem = AVPlayerItem(URL: sound)
        player = AVPlayer(playerItem: playerItem)
        player.rate = 1.0;
        player.play()
    }
}
