//
//  MapViewController.swift
//  GoogleWeather
//
//  Created by Dmitry Seliverstov on 01.10.2021.
//

import UIKit
import GoogleMaps
import Combine

fileprivate var mapWeather: AnyCancellable?

class MapViewController: UIViewController {
    
    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet private weak var weatherView: WeatherView!
    @IBOutlet private weak var pinImageVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mapTimeLabel: UILabel!

    private let locationManager = CLLocationManager()
    private var zoom: Float = 5
}

// MARK: - Lifecycle

extension MapViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.delegate = self
        weatherView.category = .map
        
        mapTimeLabel.text = String(describing: Date(timeIntervalSince1970: Double(UserDefaults.mapTime)))

        mapWeather = WeatherData.shared.$mapWeather.sink { [weak self] value in
            guard let vc = self else {
                return
            }
            guard let response = value else {
                DispatchQueue.main.async {
                    vc.weatherView.isHidden = true
                    vc.mapTimeLabel.text = String(describing: Date(timeIntervalSince1970: Double(UserDefaults.mapTime)))
                }
                return
            }
            DispatchQueue.main.async {
                vc.weatherView.isHidden = false
                vc.weatherView.response = response
                let timeText = String(describing: Date(timeIntervalSince1970: Double(UserDefaults.mapTime)))
                if vc.mapTimeLabel.text != timeText {
                    vc.mapTimeLabel.text = timeText
                }
            }
        }
    }
}

// MARK: - Actions

extension MapViewController {
    
    @IBAction func refreshPlaces(_ sender: Any) {
        fetchPlaces(near: mapView.camera.target)
    }
    
    func fetchPlaces(near coordinate: CLLocationCoordinate2D) {
        mapView.clear()
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard
                let address = response?.firstResult(),
                let _ = address.lines
            else {
                return
            }
            //self.addressLabel.text = lines.joined(separator: "\n")
            let labelHeight: CGFloat = 20 // self.addressLabel.intrinsicContentSize.height
            let topInset = self.view.safeAreaInsets.top
            self.mapView.padding = UIEdgeInsets(
                top: topInset,
                left: 0,
                bottom: labelHeight,
                right: 0)
            UIView.animate(withDuration: 0.25) {
                self.pinImageVerticalConstraint.constant = (labelHeight - topInset) * 0.5
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.requestLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _ = locations.first else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - GMSMapViewDelegate

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        WeatherData.shared.tappedCoordinate = coordinate
        mapView.camera = GMSCameraPosition(
            target: coordinate,
            zoom: zoom,
            bearing: 0,
            viewingAngle: 0)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        zoom = position.zoom
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocode(coordinate: position.target)
    }

    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        return false
    }
}
