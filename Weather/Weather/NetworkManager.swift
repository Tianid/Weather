//
//  NetworkManager.swift
//  Weather
//
//  Created by Tianid on 28.10.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static func makeRequest(cityName: String, method: HTTPMethod, complitionHandler: ((WeatherForecast) -> ())?) {
        let parameters = ["q": cityName, "appid": APIKey, "units":"metric"]
        makeRequest(method: method, parameters: parameters, complitionHandler: complitionHandler)
    }
    
    private static func makeRequest(method: HTTPMethod, parameters: [String: Any], complitionHandler: ((WeatherForecast) -> ())?) {
        AF.request(APIurl,
                   method: method,
                   parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(WeatherForecast.self, from: data)
                        complitionHandler?(model)
                    } catch {
                        print(error)
                    }
                
                case .failure(_):
//                    print(error)
                    break
                }
        }
    }
}
