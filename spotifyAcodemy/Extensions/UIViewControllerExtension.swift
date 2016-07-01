//
//  UIViewControllerExtension.swift
//
//  Created by Krzysztof 
//  Copyright © 2015 10Clouds. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //MARK: - Alerts
    
    func showAlertOK(title: String, msg: String,  actionOK: (() -> Void)? = nil ) {
        let alertView = UIAlertController(title: title, message: msg , preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction!) -> Void in
            actionOK?()
        })
        alertView.addAction(okButton)
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func clearAllNotice(closure: () ->()) {
        dispatch_async(dispatch_get_main_queue()) {
            self.clearAllNotice()
            closure()
        }
    }
}
