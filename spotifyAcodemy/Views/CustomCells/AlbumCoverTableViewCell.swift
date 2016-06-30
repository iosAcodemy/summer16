//
//  AlbumCoverTableViewCell.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 07.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit

class AlbumCoverTableViewCell: UITableViewCell {

    @IBOutlet weak var albumCoverImage: UIImageView!

    func configure(album: Album) {
        albumCoverImage.setImageFromURL(album.images.first!.url)
    }
}
