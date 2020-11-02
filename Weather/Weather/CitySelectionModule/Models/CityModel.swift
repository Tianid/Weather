//
//  CityModel.swift
//  Weather
//
//  Created by Tianid on 30.10.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

import Foundation

struct CityModel: Codable {
    let id: Int
    let name: String
    let state: String
    let country: String
    var presentName: String {
        if state.isEmpty && country.isEmpty {
            return "\(name)"
        }
        
        let _country = country.isEmpty ? country : "country: \(country)"
        let _state = state.isEmpty ? state : "state: \(state)"
        return "\(name) ( \(_country) \(_state) )"
    }
}
