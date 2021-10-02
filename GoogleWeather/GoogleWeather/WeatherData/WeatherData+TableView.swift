//
//  WeatherData+TableView.swift
//  GoogleWeather
//
//  Created by Dmitry Seliverstov on 01.10.2021.
//

import UIKit
import WeatherCore

extension WeatherData : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let response = cityWeather, let weather = response.darkSky {
            return weather.daily.data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        if let response = cityWeather, let weather = response.darkSky {
            let day = weather.daily.data[indexPath.row]
            if let icon = DarkSky.Icon(rawValue: day.icon) {
                cell.imageView?.image = icon.image
            }
            cell.textLabel?.text = day.celsiusCurrentTempString
            cell.detailTextLabel?.text = "\(day.dateString)"
        }
        return cell
    }
}

extension WeatherData : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
