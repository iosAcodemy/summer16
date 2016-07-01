//
//  AlbumTrackTableViewCell.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 07.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit

class AlbumTrackTableViewCell: UITableViewCell {

    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    func configure(track: Track) {
        songNameLabel.text = track.name
        let time = Utils.getTimeFromMs(track.durationMs)
        durationLabel.text = time
    }
}

extension AlbumTrackTableViewCell: Reusable { }
