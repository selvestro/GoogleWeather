//
//  WeatherData+Cities.swift
//  GoogleWeather
//
//  Created by Dmitry Seliverstov on 02.10.2021.
//

import Foundation
import CoreLocation

import WeatherCore

extension WeatherData {
    
    func subscribeCitySelected() {
        cancellableCity = $citySelected.sink { cityTitle in
            guard let city = cities[cityTitle], self.citiesWeather[cityTitle] == nil else {
                DispatchQueue.main.async {
                    self.cityWeather = self.citiesWeather[cityTitle]
                }
                return
            }
            let coordinate = CLLocationCoordinate2D(latitude: city.0, longitude: city.1)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            print(location)
            WeatherAPI.Request.requestWithLocation(location) { result in
                switch result {
                case .failure(let error):
                    print("\nERROR_WeatherAPI_Request_requestWithLocation \(error)")
                case .success(let response):
                    var weather = self.citiesWeather[cityTitle]
                    if weather == nil {
                        weather = (nil, response)
                    } else {
                        weather?.weatherAPI = response
                    }
                    DispatchQueue.main.async {
                        self.citiesWeather[cityTitle] = weather
                        self.cityWeather = weather
                    }
                }
            }
            DarkSky.Request.requestWithLocation(location) { result in
                switch result {
                case .failure(let error):
                    print("\nERROR_DarkSky_Request_requestWithLocation \(error)")
                case .success(let response):
                    var weather = self.citiesWeather[cityTitle]
                    if weather == nil {
                        weather = (response, nil)
                    } else {
                        weather?.darkSky = response
                    }
                    DispatchQueue.main.async {
                        self.citiesWeather[cityTitle] = weather
                        self.cityWeather = weather
                    }
                    if let darkSky = weather?.darkSky {
                        UserDefaults.cityWeather = darkSky
                        UserDefaults.cityTime = Int(Date().timeIntervalSince1970)
                    }
                }
            }
        }
    }
}
