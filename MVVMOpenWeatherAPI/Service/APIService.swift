//
//  APIService.swift
//  MVVMOpenWeatherAPI
//
//  Created by Tai Chin Huang on 2022/6/1.
//

import Foundation
import Alamofire

typealias Completion = ((_ success: Bool, _ response: AnyObject) -> ())

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

protocol APIServiceProtocol {
    func fetchWeatherData(cityName: String, apiKey: String, completion: @escaping (_ success: Bool, _ weather: WeatherMain?, _ error: APIError?) -> ())
}


class APIService: APIServiceProtocol {
    func fetchWeatherData(cityName: String, apiKey: String, completion: @escaping (Bool, WeatherMain?, APIError?) -> ()) {
        let url = Global.baseURL
        let parameters = [
            "q": cityName,
            "appid": apiKey
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: WeatherMain.self) { response in
            
            guard response.error == nil else {
                print(response.error)
                completion(false, nil, .noNetwork)
                return
            }
            
//            print(#function)
//            print(response.value)
            
            guard let weather = response.value else { return }
            completion(true, weather, nil)
        }
    }
}
