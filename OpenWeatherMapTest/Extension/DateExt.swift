//
//  DateExt.swift
//  OpenWeatherMapTest
//
//  Created by sycheon on 2021/03/28.
//

import Foundation

extension Date {
    var string: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}
