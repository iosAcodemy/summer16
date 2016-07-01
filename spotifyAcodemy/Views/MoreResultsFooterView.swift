//
//  MoreResultsFooterView.swift
//  spotifyAcodemy
//
//  Created by Tomasz Mędryk on 29/06/16.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit

class MoreResultsFooterView: UITableViewHeaderFooterView {

	@IBOutlet private weak var moreButton: UIButton!
	@IBOutlet private weak var arrowImageView: UIImageView!

	override var contentView: UIView {
		return subviews.first!
	}

	var tapAction: (() -> Void)?

	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		tapAction = nil
	}

	@IBAction func handleTap() {
		tapAction?()
	}
}

extension MoreResultsFooterView: Reusable { }
