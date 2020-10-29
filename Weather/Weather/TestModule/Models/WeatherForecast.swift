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
    
    func getImageName() -> String {
        switch id {
        case 200...232:
            return "11d"
        case 300...321:
            return "09d"
        case 500...531:
            return "10d"
        case 600...622:
            return "13d"
        case 701...781:
            return "50d"
        case 800:
            return "01d"
        case 801...804:
            return "02d"
        default:
            return ""
        }
    }
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
