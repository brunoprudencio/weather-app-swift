//
//  WeatherManager.swift
//  weather-app
//
//  Created by Bruno Prudêncio on 08/03/22.
//

import Foundation
import CoreLocation

class WeatherManager {
    
    static let openWeatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    static let openWeatherToken = "e0e4f2dd22e2d1ac71fd96cd8e426ce8"
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: WeatherManager.openWeatherUrl
            .appending("&lat=\(latitude)")
            .appending("&lon=\(longitude)")
            .appending("&appid=\(WeatherManager.openWeatherToken)"))
        else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data") }
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        return decodedData
        
    }
}

struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse
    
    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }
    
    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }
    
    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}
