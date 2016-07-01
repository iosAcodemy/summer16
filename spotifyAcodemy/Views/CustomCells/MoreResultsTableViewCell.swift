//
//  MoreResultsTableViewCell.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 06.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit

class MoreResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var moreResultsLabel: UILabel!

    var type = ""

    func configure(msg: String) {
        moreResultsLabel.text = "Click here to see all \(msg)"
        self.type = msg
    }
}
