//
//  CitiesViewController.swift
//  GoogleWeather
//
//  Created by Dmitry Seliverstov on 01.10.2021.
//

import UIKit
import Combine

fileprivate var cityWeather: AnyCancellable?

class CitiesViewController: UIViewController {
    
    @IBOutlet weak var weatherView: WeatherView!
    
    @IBOutlet weak var citiesCollectionView: UICollectionView!
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    @IBOutlet weak var cityTimeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherData.shared.width = view.frame.width
                
        citiesCollectionView.dataSource = WeatherData.shared
        citiesCollectionView.delegate = WeatherData.shared
        
        weatherTableView.dataSource = WeatherData.shared
        weatherTableView.delegate = WeatherData.shared
        
        weatherView.category = .cities
        
        cityTimeLabel.text = String(describing: Date(timeIntervalSince1970: Double(UserDefaults.cityTime)))
        
        cityWeather = WeatherData.shared.$cityWeather.sink { [weak self] value in
            guard let vc = self, let response = value else {
                return
            }
            DispatchQueue.main.async {
                vc.weatherView.response = response
                vc.weatherView.setNeedsDisplay()
                vc.weatherTableView.reloadData()
                let timeText = String(describing: Date(timeIntervalSince1970: Double(UserDefaults.cityTime)))
                if vc.cityTimeLabel.text != timeText {
                    vc.cityTimeLabel.text = timeText
                }
            }
        }
    }
}
