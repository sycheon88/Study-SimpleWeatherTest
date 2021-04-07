//
//  OpenWeatherResponse.swift
//  OpenWeatherMapTest
//
//  Created by sycheon on 2021/03/26.
//

import Foundation


struct OpenWeatherResponse : Codable {
    var coord : coordnate?
    var weather : [weatherInfo]?
    var base : String?
    var main : mainInfo?
    var visibility : Int?
    var wind : windInfo?
    var clouds : cloudsInfo?
    var dt : Int?
    var sys : sysInfo?
    var timezone : Int?
    var id : Int?
    var name : String?
    var cod : Int?
}

struct weatherInfo: Codable {
    var id : Int?
    var main : String?
    var description : String?
    var icon : String?
 
}

struct mainInfo: Codable {
    var temp : Double?
    var feels_like : Double?
    var temp_min : Double?
    var temp_max : Double?
    var pressure : Int?
    var humidity : Int?
}

struct windInfo: Codable {
    var speed : Double?
    var deg : Int?
    var gust : Double?
}

struct cloudsInfo: Codable {
    var all : Int?
}

struct sysInfo: Codable {
    var type : Int?
    var id : Int?
    var country : String?
    var sunrise : Int?
    var sunset : Int?
    
}
