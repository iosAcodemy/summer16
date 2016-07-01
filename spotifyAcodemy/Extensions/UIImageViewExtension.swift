//
//  UIImageViewExtension.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 06.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func circleImage() {
        layer.cornerRadius = 0.5 * bounds.width
        clipsToBounds = true
        contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    func setImageFromURL(url: String, placeHolder: String = "defaultPlaceholder") {
        if let placeholderImage = UIImage(named: placeHolder) {
            kf_setImageWithURL(NSURL(string:url)!, placeholderImage: placeholderImage)
        } else {
          kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "defaultPlaceholder"))
        }
    }
}

