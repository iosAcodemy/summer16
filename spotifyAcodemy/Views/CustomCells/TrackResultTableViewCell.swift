//
//  TrackResultTableViewCell.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 06.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit

class TrackResultTableViewCell: UITableViewCell {

    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!

    func configure(trackName trackName: String, artistName: String?, albumName: String?) {
        trackNameLabel.text = trackName
        artistLabel.text = artistName
        albumLabel.text = albumName ?? "No Album Data"
    }
}

extension TrackResultTableViewCell: Reusable { }
