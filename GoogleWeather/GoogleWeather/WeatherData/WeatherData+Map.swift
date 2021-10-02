//
//  WeatherData+Map.swift
//  GoogleWeather
//
//  Created by Dmitry Seliverstov on 02.10.2021.
//

import Foundation
import CoreLocation

import WeatherCore

extension WeatherData {
    
    func subscribeMapTouch() {
        cancellableMap = $tappedCoordinate.sink { value in
            guard let coordinate = value else { return }
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            print(location)
            var region: CLCircularRegion?
            self.regionsSet.forEach { reg in
                if reg.contains(coordinate) {
                    region = reg
                }
            }
            if let region = region {
                DispatchQueue.main.async {
                    self.mapWeather = self.regions[region]
                }
            } else {
                WeatherAPI.Request.requestWithLocation(location) { result in
                    switch result {
                    case .failure(let error):
                        print("\nERROR_WeatherAPI_Request_requestWithLocation \(error)")
                    case .success(let response):
                        let circularRegion = CLCircularRegion(
                            center: coordinate, radius: CLLocationDistance(10000),
                            identifier: response.location?.name ?? UUID().uuidString)
                        var weather = self.regions[circularRegion]
                        if weather == nil {
                            weather = (nil, response)
                        } else {
                            weather?.weatherAPI = response
                        }
                        DispatchQueue.main.async {
                            self.regions[circularRegion] = weather
                            self.mapWeather = weather
                        }
                    }
                }
                DarkSky.Request.requestWithLocation(location) { result in
                    switch result {
                    case .failure(let error):
                        print("\nERROR_DarkSky_Request_requestWithLocation \(error)")
                    case .success(let response):
                        let identifier = String(response.latitude) + "_" + String(response.longitude)
                        let circularRegion = CLCircularRegion(
                            center: coordinate, radius: CLLocationDistance(10000),
                            identifier: identifier)
                        var weather = self.regions[circularRegion]
                        if weather == nil {
                            weather = (response, nil)
                        } else {
                            weather?.darkSky = response
                        }
                        DispatchQueue.main.async {
                            self.regions[circularRegion] = weather
                            self.mapWeather = weather
                        }
                        if let darkSky = weather?.darkSky {
                            UserDefaults.mapWeather = darkSky
                            UserDefaults.mapTime = Int(Date().timeIntervalSince1970)
                        }
                    }
                }
            }
        }
    }
}
