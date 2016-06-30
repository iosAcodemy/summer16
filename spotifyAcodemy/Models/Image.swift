//
//  Image.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 04.04.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation

struct Image {
    let width: Int
    let height: Int
    let url: String
}

extension Image: JSONDecodable {
    static func decodeJSONObject(object: AnyObject) throws -> Image {
        guard let dict = object as? [String: AnyObject],
            width = dict["width"] as? Int,
            height = dict["height"] as? Int,
            url = dict["url"] as? String else {
                
            throw JSONDecodingError(object: object)
        }
        
        return Image(width: width, height: height, url: url)
    }
}
