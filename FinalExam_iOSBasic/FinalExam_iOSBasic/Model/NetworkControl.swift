//
//  NetworkControl.swift
//  FinalExam_iOSBasic
//
//  Created by Khoa Dai on 27/02/2023.
//

import Foundation
import UIKit

protocol NetworkControlProtocol {
    // func fetchAPIFromURL(_ url: String, completionHandler: @escaping (String?, String?) -> Void)
    func didUpdateForecastData(_ networkControl: NetworkControl, weatherData: WeatherData?)
    func didFailWithError(error: Error)
}

class NetworkControl {

    let baseURL = "https://api.openweathermap.org/data/2.5/forecast?appid="
    let baseAPI = "9a22ed91d6856a3cbb9cada352f93def"
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?

    var delegate: NetworkControlProtocol?

    func getForecast(in cityName: String) {
        let city = cityName.replacingOccurrences(of: " ", with: "+")
        let url = "\(baseURL)\(baseAPI)&q=\(city)&units=metric"
        fetchForecastData(from: url)
    }

    func fetchForecastData(from urlString: String) {
        if let url = URL(string: urlString) {
            dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, _, error) in
                if let error = error {
                    self.delegate?.didFailWithError(error: error)
                    return
                }

                if let safeData = data {
                    if let forecastData = self.parseJSON(safeData) {
                        self.delegate?.didUpdateForecastData(self, weatherData: forecastData)
                    }
                }
            })
        }
        dataTask?.resume()
    }

    func parseJSON(_ weatherData: Data) -> WeatherData? {
        let decoder = JSONDecoder()
        do {
            let forecast = try decoder.decode(WeatherData.self, from: weatherData)
            return forecast
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

extension NetworkControl {
    func fetchAPIFromURL(_ url: String, completionHandler: @escaping (String?, String?) -> Void) {
        guard let url = URL(string: url) else {
            completionHandler(nil, "URL incorrect")
            return
        }
        dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            if let error = error?.localizedDescription {
                completionHandler(nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completionHandler(nil, "Server failed")
                return
            }
            guard let data = data else {
                return
            }
            let string = String(data: data, encoding: .utf8)
            completionHandler(string, nil)
        }
        dataTask?.resume()
    }
}
