//
// Created by Tomasz Mędryk on 13/04/16.
// Copyright (c) 2016 10Clouds. All rights reserved.
//

import Foundation

struct Utils {
    
    static var apiDateFormatter: NSDateFormatter = {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    static func decodeOptionalDateFromString(string: String?) -> NSDate? {
        guard let string = string else {
            return nil
        }
        
        return apiDateFormatter.dateFromString(string)
    }
    
    static func getTimeFromMs(durationMs: Int) -> String {
        var seconds = durationMs / 1000
        let minutes = seconds / 60
        seconds %= 60;
        let sec = seconds < 10 ? "0\(seconds)"  : "\(seconds)"
        return " \(minutes):\(sec)"
    }

}
