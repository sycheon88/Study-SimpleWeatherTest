//
//  CityInfo.swift
//  OpenWeatherMapTest
//
//  Created by sycheon on 2021/03/25.
//

import Foundation

struct CityInfo : Codable {
    var id : Int
    var name : String
    var country : String
    var coord : coordnate
}

struct coordnate: Codable {
    var lon : Double
    var lat : Double
}
