//
//  LastQueries.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 04.05.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation
import UIKit

struct LastQueries {

    static func addQuery(query: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var lastQueries = getLastQueries()
        lastQueries.insert(query, atIndex: 0)
        defaults.setObject(lastQueries, forKey: "QueryArray")
        defaults.synchronize()
    }

    static func getLastQueries() -> [String] {
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastQueries = defaults.objectForKey("QueryArray") as? [String] ?? [String]()
        return Array(lastQueries.prefix(20))
    }
}
