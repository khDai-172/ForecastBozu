//
//  CurrentWeather.swift
//  FinalExam_iOSBasic
//
//  Created by Khoa Dai on 20/06/2023.
//

import Foundation

struct CurrentWeather: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
}
