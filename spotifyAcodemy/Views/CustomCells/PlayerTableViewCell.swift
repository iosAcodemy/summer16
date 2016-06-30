//
//  PlayerTableViewCell.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 08.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit
import AVFoundation

var currentTime = 0

typealias PlayerPauseTime = (time: Int) -> ()

protocol PlayerCellDelegate {
    func pause(currentTime: PlayerPauseTime)
    func playerPlay()
    func playTrack()
}

enum ButtonMode {
    case Play
    case Pause
}

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var playerButton: UIButton!
    @IBOutlet weak var progress: KDCircularProgress!

    private var track: Track?
    private var isPlaying = false
    private var resume = false
    private var currentTime = 0
    private var delegate: PlayerCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        NSNotificationCenter.defaultCenter()
            .addObserver(self,
                         selector: #selector(PlayerTableViewCell.playerDidFinishPlaying(_:)),
                         name: "playerDidFinishPlaying",
                         object: nil)
    }

    func setupProgressBar() {
        progress.startAngle = -90
        progress.progressThickness = 0.1
        progress.trackThickness = 0.1
        progress.clockwise = true
        progress.roundedCorners = false
        progress.setColors(UIColor(red: 162.0/255.0, green: 125.0/255.0, blue: 80.0/255.0, alpha: 1))
    }

    func configure(track: Track, album: Album, delegate: PlayerCellDelegate) {
        songNameLabel.text = track.name
        artistLabel.text = track.artists.first?.name
        albumNameLabel.text = album.name

        self.track = track
        self.delegate = delegate

        setupProgressBar()
    }

    @IBAction func playerButtonTapped(sender: AnyObject) {
        isPlaying ? pause() : resumeOrStartPlaying()
    }

    func setupButtonModeOn(mode:ButtonMode) {
        isPlaying = mode != .Play

        if mode == .Play {
            playerButton.setImage(UIImage(named: "playButtonBlack"), forState: .Normal)
            progress.pauseAnimation()
        } else {
            playerButton.setImage(UIImage(named: "pauseButtonBlack"), forState: .Normal)
        }
    }

    func animateCirlce() {
        let a1 = (currentTime * 12) / 10
        let a2 = ((currentTime + 300) * 12) / 10
        progress.animateFromAngle(a1, toAngle: a2, duration: 30.0, completion: nil)
    }

    //MARK: - Player

    func pause() {
        delegate?.pause { (time) in
            self.currentTime = time
        }
        setupButtonModeOn(.Play)
    }

    func resumeOrStartPlaying() {
        setupButtonModeOn(.Pause)
        if resume {
            delegate?.playerPlay()
            animateCirlce()
        } else {
            delegate?.playTrack()
            animateCirlce()
            resume = true
        }
    }

    func playerDidFinishPlaying(note: NSNotification) {
        resume = false
        currentTime = 0
        setupButtonModeOn(.Play)
    }
}
