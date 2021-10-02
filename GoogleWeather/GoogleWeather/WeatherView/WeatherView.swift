//
//  WeatherView.swift
//  GoogleWeather
//
//  Created by Dmitry Seliverstov on 01.10.2021.
//

import UIKit

import WeatherCore

@IBDesignable
class WeatherView: UIView {
    
    enum Category {
        case cities
        case map
    }
    
    @IBOutlet weak var skyImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    
    var category = Category.cities
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    var response: WeatherResponse? {
        didSet {
            updateViews()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    func configureViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
        updateViews()
    }

    func updateViews() {
        guard let response = response else {
            if category == .cities {
                self.skyImageView.image = nil
                self.temperatureLabel.text = ""
                self.cloudsLabel.text = "Выберите город"
            }
            return
        }
        if let currently = response.darkSky?.currently {
            self.temperatureLabel.text = currently.celsiusCurrentTempString
            self.cloudsLabel.text = currently.summary
            if let image = WeatherData.shared.images[currently.icon] {
                skyImageView.image = image
            } else {
                if let icon = DarkSky.Icon(rawValue: currently.icon) {
                    skyImageView.image = icon.image
                }
            }
        }
    }
    
    fileprivate func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WeatherView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first! as! UIView
        return view
    }
}
