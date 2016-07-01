//
//  UITableExtension.swift
//
//  Created by Krzysztof
//  Copyright © 2015 10Clouds. All rights reserved.
//

import UIKit

enum CustomCell: String {
    case SearchResultTableViewCell = "SearchResultTableViewCell"
    case MoreResultsTableViewCell = "MoreResultsTableViewCell"
    case TrackResultTableViewCell = "TrackResultTableViewCell"
    case AlbumCoverTableViewCell = "AlbumCoverTableViewCell"
    case AlbumTrackTableViewCell = "AlbumTrackTableViewCell"
    case ArtistHeaderTableViewCell = "ArtistHeaderTableViewCell"
    case PlayerTableViewCell = "PlayerTableViewCell"
    case LastSearchTableViewCell = "LastSearchTableViewCell"
}

protocol Reusable: class {
	static var reuseIdentifier: String { get }
	static var nib: UINib? { get }
}

extension Reusable {
	static var reuseIdentifier: String { return String(Self) }
	static var nib: UINib? { return UINib(nibName: String(Self), bundle: nil) }
}

extension UITableView {

	func registerCustomCellNib(nibName: String, cellReuseIdentifier: String) {
		let nib = UINib(nibName: nibName, bundle: nil)
		self.registerNib(nib, forCellReuseIdentifier:cellReuseIdentifier)
	}

	func addNib(cell: CustomCell) {
		registerCustomCellNib(cell.rawValue, cellReuseIdentifier:cell.rawValue)
	}

	func registerReusableCell<T: UITableViewCell where T: Reusable>(_: T.Type) {
		if let nib = T.nib {
			registerNib(nib, forCellReuseIdentifier: T.reuseIdentifier)
		} else {
			registerClass(T.self, forCellReuseIdentifier: T.reuseIdentifier)
		}
	}

	func dequeueReusableCell<T: UITableViewCell where T: Reusable>(indexPath indexPath: NSIndexPath) -> T {
		return dequeueReusableCellWithIdentifier(T.reuseIdentifier, forIndexPath: indexPath) as! T
	}

	func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView where T: Reusable>(_: T.Type) {
		if let nib = T.nib {
			registerNib(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
		} else {
			registerClass(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
		}
	}

	func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView where T: Reusable>() -> T? {
		return dequeueReusableHeaderFooterViewWithIdentifier(T.reuseIdentifier) as! T?
	}

    func setTableViewBackgroundGradient(topColor:UIColor, _ bottomColor:UIColor) {
        let gradientBackgroundColors = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations = [0.0, 1.0]

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations

        gradientLayer.frame = self.bounds
        let backgroundView = UIView(frame: self.frame)
        backgroundView.layer.insertSublayer(gradientLayer, atIndex: 0)
        self.backgroundView = backgroundView
    }
}
