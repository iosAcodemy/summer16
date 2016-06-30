//
//  SearchResultTableViewCell.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 06.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    // MARK: Properties

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!

    // MARK: Public API

    func configure(name name: String, images: [Image]?) {
        nameLabel.text = name
        var thumbURL = "placeholder"
        if let images = images where images.count > 1 {
            thumbURL = images[1].url
        }
        thumbImageView.setImageFromURL(thumbURL)
        thumbImageView.circleImage()
    }
}

extension SearchResultTableViewCell: Reusable { }
