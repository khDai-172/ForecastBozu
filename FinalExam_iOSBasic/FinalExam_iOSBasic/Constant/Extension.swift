//
//  Extension.swift
//  FinalExam_iOSBasic
//
//  Created by Khoa Dai on 20/06/2023.
//

import Foundation

extension String {

    func tempString(_ temp: Double) -> String {
        let temperatureString = String(format: "%.1f", temp)
        return temperatureString
    }

    func presString(_ pressure: Double) -> String {
        let pressureString = String(format: "%.0f pAh", pressure)
        return pressureString
    }

    func humString(_ humid: Double) -> String {
        let humidString = String(format: "%.0f", humid)
        return humidString
    }

    func switchConditCase(_ description: String) -> String {
        let uppercase = String(description.prefix(1)).uppercased()
        let remain = String(description.dropFirst())

        return uppercase + remain
    }
}
