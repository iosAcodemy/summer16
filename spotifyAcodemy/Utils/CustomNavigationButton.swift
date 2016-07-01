//
//  CustomNavigationButton.swift
//
//  Created by Krzysztof Bogacz
//  Copyright (c) 2015 10clouds. All rights reserved.
//

import Foundation
import UIKit

enum LeftOrRight: String {
    case Left = "left"
    case Right = "right"
}

class CustomNavigationButton {
    func add(side: LeftOrRight, name: String, view: UIViewController, actionSelector: Selector, width: CGFloat,
             height: CGFloat, color: UIColor) {

        let buttonEdit: UIButton = UIButton(type: .Custom)
        buttonEdit.frame = CGRectMake(0, 0, width, height)
        buttonEdit.setTitle(name, forState: .Normal)
        buttonEdit.setTitleColor(color, forState: .Normal)
        buttonEdit.addTarget(view, action: actionSelector, forControlEvents: .TouchUpInside)
        let barButtonItemEdit: UIBarButtonItem = UIBarButtonItem(customView: buttonEdit)
        if side == .Left {
            view.navigationItem.leftBarButtonItem = barButtonItemEdit
        } else {
            view.navigationItem.rightBarButtonItem = barButtonItemEdit
        }
    }
}
