//
//  WeatherData+CollectionView.swift
//  GoogleWeather
//
//  Created by Dmitry Seliverstov on 01.10.2021.
//

import UIKit
import CoreLocation

extension WeatherData : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2 - 20, height: collectionView.frame.size.height - 20)
    }
}

extension WeatherData : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return citiesTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath)
        cell.contentView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        let cityTitle = citiesTitles[indexPath.row]
        label.text = cityTitle
        label.textAlignment = .center
        cell.contentView.addSubview(label)
        label.center = cell.contentView.center
        cell.contentView.backgroundColor = .cyan
        if citySelected == cityTitle {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        if cell.isSelected {
            cell.contentView.backgroundColor = .orange
        }
        return cell
    }
}

extension WeatherData : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        citySelected = WeatherData.shared.citiesTitles[indexPath.row]
        collectionView.reloadData()
    }
}
