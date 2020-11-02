//
//  ModelExtractro.swift
//  Weather
//
//  Created by Tianid on 02.11.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

import Foundation

class ModelExtractor {
    
    var model: [CityModel]!
    static let shared = ModelExtractor()
    
    private init() { }
    
    func makeCityList() {
        guard let urlPath = Bundle.main.url(forResource: "city.list", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: urlPath)
            let model = transformDataToJSON(data: data)
            sortModel(model: model)
        } catch {
            print(error)
        }
    }
    
    func transformDataToJSON(data: Data) -> [CityModel] {
        do {
            let model = try JSONDecoder().decode([CityModel].self, from: data)
            return model
        } catch {
            print(error)
            return []
        }
    }
    
    func sortModel(model: [CityModel]) {
        
        let dateForm = DateFormatter()
        dateForm.dateFormat = "HH:mm:ss"
        dateForm.string(from: Date())
        
        print("start sort \(dateForm.string(from: Date()))")
        self.model = model.sorted { (first, second) -> Bool in
            first.name > second.name
        }
        print("end sort \(dateForm.string(from: Date()))")
    }
}
