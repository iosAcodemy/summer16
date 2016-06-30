//
// Created by Tomasz Mędryk on 06/04/16.
// Copyright (c) 2016 10Clouds. All rights reserved.
//

import Foundation

protocol URLEncodable {

    var encoded: String { get }

}

extension Array: URLEncodable {

    var encoded: String { return (map { "\($0)" }).joinWithSeparator(",") }

}
