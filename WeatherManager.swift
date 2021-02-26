//
//  WeatherManager.swift
//  Clima
//
//  Created by Victor Batista on 25/02/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=c3229a9662367b238d43e87d85bc59ba&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        peformRequest(with: urlString)
    }
    
    func fetchWeather(_ lat:CLLocationDegrees,_ long:CLLocationDegrees ){
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(long)"
        peformRequest(with: urlString)
    }
    
    func peformRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(with: error!)
                    return
                }
                if let safeData = data {
                    if let weather  = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let name = decodeData.name
            let temp = decodeData.main.temp
            let weather = WeatherModel(conditionId: id, name: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(with: error)
            return nil
        }
    }
    
}
