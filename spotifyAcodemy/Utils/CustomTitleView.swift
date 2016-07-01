//
//  CustomTitleView.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 24.05.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation
import UIKit

struct CustomTitleView {

    static func labelFactory(title: String, width: CGFloat, height: CGFloat) -> UILabel {
        let label = UILabel(frame: CGRectMake(0, 0, width, height))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Center
        label.text = title
        return label
    }

    static func createView(screenWidth: CGFloat, up: String, down: String) -> UIView {
        let width = screenWidth
        let height: CGFloat = 44.00
        let titleView = UIView(frame: CGRectMake(0, 0, width, height))
        titleView.backgroundColor = UIColor.clearColor()

        let label = labelFactory(up, width: width, height: height / 2)
        label.center = CGPointMake(width / 2 , 10)
        label.font = UIFont.systemFontOfSize(14)

        let label2 = labelFactory(down, width: width, height: height / 2)
        label2.center = CGPointMake(width / 2 , 30)
        label2.font = UIFont.systemFontOfSize(10)
        titleView.addSubview(label)
        titleView.addSubview(label2)
        return titleView
    }
}
