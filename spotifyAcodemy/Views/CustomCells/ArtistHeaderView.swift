//
//  ArtistHeaderTableViewCell.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 07.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit

protocol ArtistHeaderViewDelegate: class {
    func didTapAddToFavorites()
    func didTapRemoveFromFavorites()
}

class ArtistHeaderView: UIView {

    // MARK: Properties

    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var favoritesButton: UIButton! {
        didSet{ setupFavoritesButton() }
    }

    weak var delegate: ArtistHeaderViewDelegate?

    // MARK: Public API

    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func configure(artist: Artist, isInFavorites: Bool) {
        if let imageUrl = artist.images?.first?.url {
            artistImage.setImageFromURL(imageUrl)
            artistImage.circleImage()
        }
        favoritesButton.selected = isInFavorites
    }

    @IBAction func addToFavorites(sender: AnyObject) {
        if favoritesButton.selected  {
            delegate?.didTapRemoveFromFavorites()
            favoritesButton.selected = false
        } else {
            delegate?.didTapAddToFavorites()
            favoritesButton.selected = true
        }
    }
    
    // MARK: Private Methods

    private func setupFavoritesButton() {
        favoritesButton.setTitle("Remove from Favorites", forState: .Selected)
        favoritesButton.setTitle("Add to Favorites", forState: .Normal)
    }
}
