//
//  WeatherManager.swift
//  Clima
//
//  Created by Victor Batista on 25/02/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    let locationManager = CLLocationManager()

    var weatherManager: WeatherManager {
        let weatherManager = WeatherManager.init(delegate: self)
        return weatherManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        askLocationPermission()
        setupSearchTextField()
    }
    
    @IBAction func requestWeatherLocationPressed(_ sender: UIButton) {
        requestLocation()
    }
    
    func askLocationPermission(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        requestLocation()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func setupSearchTextField(){
        searchTextField.delegate = self
    }
    
    func peformSearch() {
        closeKeyboard()
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
    }
    
    func closeKeyboard(){
        searchTextField.endEditing(true)
    }

    func updateView(weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.name
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    
}

//MARK: - UITextFiledDelegate


extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        peformSearch()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        peformSearch()
        searchTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        peformSearch()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.text = ""
            return false
        }
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        updateView(weather: weather)
    }
    
    func didFailWithError(with error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            weatherManager.fetchWeather(lat, long)			
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
