//
//  WeatherViewModel.swift
//  MVVMOpenWeatherAPI
//
//  Created by Tai Chin Huang on 2022/6/1.
//

import Foundation

class WeatherViewModel {
    let cities = ["New York",
                  "Seattle",
                  "Vancouver",
                  "Toronto",
                  "London",
                  "Paris",
                  "Berlin",
                  "Tokyo"
    ]
    /// 初始化需要抓資料，需要建立APIService物件
    let apiService: APIServiceProtocol
    /// 負責連接model - WeatherMain
    private var weather: WeatherMain?
    /// 負責串連UI - WeatherCellViewModel(WeatherCellViewModel在串起cell UI)
    private var cellViewModels: [WeatherCellViewModel] = [WeatherCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var reloadTableViewClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var showAlertClosure: (() -> ())?
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func initFetch() {
        self.isLoading = true
        cities.forEach { city in
//            print(#function)
//            print(city)
            apiService.fetchWeatherData(cityName: city, apiKey: Global.apiKey) { [weak self] (success, weather, error) in
                self?.isLoading = false
                if let error = error {
                    self?.alertMessage = error.rawValue
                } else {
                    self?.processWeatherData(weather: weather!)
                }
            }
        }
        print(#function)
        print(cellViewModels)
    }
    
    func createWeatherCellViewModel(weather: WeatherMain) -> WeatherCellViewModel {
        let tempCel: Double = weather.main.temp - 273.15
        let tempCelStr = String(format: "%.2f", tempCel)
        return WeatherCellViewModel(cityNameText: weather.name,
                                    tempText: tempCelStr,
                                    descriptionText: weather.weather.first!.main)
    }
    private func processWeatherData(weather: WeatherMain) {
        self.weather = weather
//        var vms = [WeatherCellViewModel]()
//        vms.append(createWeatherCellViewModel(weather: weather))
//        self.cellViewModels = vms
        self.cellViewModels.append(createWeatherCellViewModel(weather: weather))
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> WeatherCellViewModel {
        return cellViewModels[indexPath.row]
    }
}
