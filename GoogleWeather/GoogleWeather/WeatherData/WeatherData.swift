//
//  WeatherData.swift
//  GoogleWeather
//
//  Created by Dmitry Seliverstov on 01.10.2021.
//

import UIKit
import CoreLocation
import Combine

import WeatherCore

typealias WeatherResponse = (darkSky: DarkSky.Response?, weatherAPI: WeatherAPI.Response?)

let cities: [String: (Double, Double)] = [
    "Москва": (55.753913, 37.620836),
    "Санкт-Петербург": (59.950015, 30.316599),
    "Новосибирск": (82.916670, 55.016670),
    "Нью-Йорк": (40.757911, -73.969877),
]

class WeatherData : NSObject, ObservableObject {
    
    static let shared = WeatherData()
    
    var images: [String: UIImage] = [:]
    
    @Published var citySelected: String = "Москва"
    @Published var citiesTitles: [String] = ["Москва", "Санкт-Петербург", "Новосибирск", "Нью-Йорк"]
    @Published var citiesWeather: [String: WeatherResponse] = [:] {
        didSet {
            var dict: [String: DarkSky.Response] = [:]
            citiesWeather.forEach { key, value in
                if let darkSky = value.darkSky {
                    dict[key] = darkSky
                }
            }
        }
    }
    @Published var cityTime: Int
    
    @Published var cityWeather: WeatherResponse?
    
    @Published var regions: [CLCircularRegion: WeatherResponse] = [:]
    public var regionsSet: Set<CLCircularRegion> {
        return Set(regions.map({ $0.key }))
    }
    
    @Published var tappedCoordinate: CLLocationCoordinate2D?

    @Published var mapTime: Int

    @Published var mapWeather: WeatherResponse?
    
    var cancellableCity: AnyCancellable?
    var cancellableMap: AnyCancellable?
    
    var width: CGFloat = 0

    override init() {
        self.cityTime = UserDefaults.cityTime
        self.mapTime = UserDefaults.mapTime
        super.init()
        DarkSky_Key = "3e7e519ea86c8e3fcf67c0f4870513d7"
        WeatherAPI_Key = "2295c373bbab466390384959210110"
        
        let nowMinusHourTime = Int(Calendar.current.date(byAdding: Calendar.Component.hour, value: -1, to: Date())!.timeIntervalSince1970)
        if UserDefaults.cityTime > nowMinusHourTime {
            var dict: [String: WeatherResponse] = [:]
            UserDefaults.citiesWeather.forEach { city, darkSky in
                dict[city] = (darkSky, nil)
            }
            citiesWeather = dict
            cityWeather = (UserDefaults.cityWeather, nil)
        }
        if UserDefaults.mapTime > nowMinusHourTime {
            mapWeather = (UserDefaults.mapWeather, nil)
        }
        subscribeCitySelected()
        subscribeMapTouch()
    }
}
