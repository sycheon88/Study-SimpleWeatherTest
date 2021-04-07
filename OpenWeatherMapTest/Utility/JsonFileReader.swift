//
//  JsonFileReader.swift
//  OpenWeatherMapTest
//
//  Created by sycheon on 2021/03/25.
//

import Foundation

enum FileError: Error {
    case unknown
    case readFailure
}

class JsonFileReader {
    func loadJsonFile() throws -> [CityInfo]? {
        if let path = Bundle.main.path(forResource: "citylist", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonData = try JSONDecoder().decode(Array<CityInfo>.self, from: data)
                
                return jsonData

            } catch {
                throw FileError.readFailure
            
            }
        }
        
        throw FileError.unknown
    }
}
