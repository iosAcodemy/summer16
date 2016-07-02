//
//  UITableViewFake.swift
//  spotifyAcodemy
//
//  Created by Patryk Mierzejewski on 30.06.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation
import UIKit

class UITableViewFake: UITableView {
    
    var reloadDataCalled: Bool? = nil
    
    override func reloadData() {
        reloadDataCalled = true
    }
}
