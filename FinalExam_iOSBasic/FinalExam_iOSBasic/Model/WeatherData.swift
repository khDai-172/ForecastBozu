//
//  Weather.swift
//  FinalExam_iOSBasic
//
//  Created by Khoa Dai on 27/02/2023.

import Foundation

struct WeatherData: Codable {
    let cod: String
    let message: Int
    let list: [ClassList]
    let city: City
    let cnt: Int

    func tempString(_ temp: Double) -> String {
        let temperatureString = String(format: "%.1f", temp)
        return temperatureString
    }

    func presString(_ pres: Double) -> String {
        let pressureString = String(format: "%.0f pAh", pres)
        return pressureString
    }

    func humString(_ hum: Double) -> String {
        let humidString = String(format: "%.0f", hum)
        return humidString
    }

    func dateFormatting(_ date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateformatted = dateFormatter.date(from: date)
        return dateformatted
    }

    func switchConditCase(description: String) -> String {
        let uppercase = String(description.prefix(1)).uppercased()
        let remain = String(description.dropFirst())
        return uppercase + remain
    }
}

struct ClassList: Codable {
    let main: Main
    let weather: [Weather]
    let timeStamp: String?
    enum CodingKeys: String, CodingKey {
        case main, weather
        case timeStamp = "dt_txt"
    }
}

struct Main: Codable {
    let temp: Double?
    let tempMin: Double?
    let tempMax: Double?
    let humidity: Double?
    let pressure: Double?
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
        case pressure
    }
}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct City: Codable {
    let id: Int
    let name: String
    let country: String
}
