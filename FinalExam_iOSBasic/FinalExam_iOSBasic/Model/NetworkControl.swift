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
    func didUpdateWeatherData(_ networkControl: NetworkControl, weatherData: CurrentWeather?)
    func didUpdateForecastData(_ networkControl: NetworkControl, forecastData: WeatherData?)
    func didFailWithError(error: Error)
}

class NetworkControl {

    let forecastURL = "https://api.openweathermap.org/data/2.5/forecast?units=metric&lang=vi&appid="
    let currentURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&lang=vi&appid="
    let baseAPI = Key.APIKey
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?

    var delegate: NetworkControlProtocol?

    func getForecast(in cityName: String) {
        let city = cityName.replacingOccurrences(of: " ", with: "+")
        let url = "\(forecastURL)\(baseAPI)&q=\(city)"
        print(url)
        fetchForecastData(from: url)
    }

    func getCurrent(in cityName: String) {
        let city = cityName.replacingOccurrences(of: " ", with: "+")
        let url = "\(currentURL)\(baseAPI)&q=\(city)"
        print(url)
        fetchWeatherData(from: url)
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
                        self.delegate?.didUpdateForecastData(NetworkControl(), forecastData: forecastData)
                    }
                }
            })
        }
        dataTask?.resume()
    }

    func parseJSON(_ forecastData: Data) -> WeatherData? {
        let decoder = JSONDecoder()
        do {
            let decodedForecast = try decoder.decode(WeatherData.self, from: forecastData)
            print(decodedForecast)
            return decodedForecast
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

    func fetchWeatherData(from urlString: String) {

        if let url = URL(string: urlString) {

            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { (data, response, error) in

                // Handle networking error
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }

                if let httpsResponse = response as? HTTPURLResponse, (200...299).contains(httpsResponse.statusCode) {
                    print("Request was successfull!")
                } else {
                    print("Request failed!")
                }

                // optional binding data object
                if let safeData = data {
                    if let weather = self.parseWeatherJSON(safeData) {
                        self.delegate?.didUpdateWeatherData(self, weatherData: weather)
                    }
                }
            }
            // 4. Start the Task:
            task.resume()
        }
    }

    // Convert requested data to local data
    func parseWeatherJSON(_ weatherData: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let decodedClimate = try decoder.decode(CurrentWeather.self, from: weatherData)
            return decodedClimate
        } catch {

            // Catch decoding error
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
