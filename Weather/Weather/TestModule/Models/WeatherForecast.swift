//
//  WeatherForecast.swift
//  Weather
//
//  Created by Tianid on 28.10.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

import Foundation

struct WeatherForecast: Codable {
    var list: [WeatherBundle]
}

struct WeatherBundle: Codable {
    let dt: Date
    let main: Main
    let weather: [MWeather]
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case dtTxt = "dt_txt"
    }
}

struct MWeather: Codable {
    let id: Int
    let main: String
    let description: String
}


struct Main: Codable {
    let temp: Double
    var tempMin: Double?
    var tempMax: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}
