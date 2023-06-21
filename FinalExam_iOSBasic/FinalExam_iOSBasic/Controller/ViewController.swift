//
//  ViewController.swift
//  FinalExam_iOSBasic
//
//  Created by Khoa Dai on 27/02/2023.
//

import UIKit
import AlamofirePack
import Alamofire

class ViewController: UIViewController {

    // MARK: - IBOulet
    @IBOutlet weak var tempLowest: UILabel!
    @IBOutlet weak var tempHighest: UILabel!
    @IBOutlet weak var pressureNow: UILabel!
    @IBOutlet weak var humidNow: UILabel!
    @IBOutlet weak var cityNow: UILabel!
    @IBOutlet weak var conditNow: UILabel!
    @IBOutlet weak var iconNow: UIImageView!
    @IBOutlet weak var tempBold: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!

    // MARK: - Initiate constants
    var weatherData: WeatherData?
    private let networkControl = NetworkControl()
    private var listForecast = [WeatherData]()
    static var cityCall: String?
    let myUrl = "https://api.openweathermap.org/data/2.5/forecast?appid=9a22ed91d6856a3cbb9cada352f93def"

    override func viewDidLoad() {
        super.viewDidLoad()
        // setForecastForTable()
        networkControl.delegate = self
        setUpWeatherTable()
        getCurrentData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getForecastData()
        forecastTableView.reloadData()
    }

    @IBAction func moveToSearch(_ sender: Any) {
        guard let searchScreen
                = storyboard?.instantiateViewController(withIdentifier: Const.searchVC)
                as? SearchViewController else {
            return
        }
        self.navigationController?.pushViewController(searchScreen, animated: true)
    }

    private func setUpWeatherTable() {
        forecastTableView.register(UINib(nibName: Const.cellIdentifier, bundle: nil),
                                   forCellReuseIdentifier: Const.cellIdentifier)
        forecastTableView.dataSource = self
        forecastTableView.delegate = self
    }
}

// MARK: - NetworkControlProtocol

extension ViewController: NetworkControlProtocol {
    func didUpdateWeatherData(_ networkControl: NetworkControl, weatherData: CurrentWeather?) {
        DispatchQueue.main.async {
            self.cityNow.text = weatherData?.name
            self.tempLowest.text = String().tempString(weatherData?.main.tempMin ?? 0.0)
            self.tempHighest.text = String().tempString(weatherData?.main.tempMax ?? 0.0)
            self.pressureNow.text = String().presString(weatherData?.main.pressure ?? 0.0)
            self.humidNow.text = String().humString(weatherData?.main.humidity ?? 1.0) + Const.humUnit
            self.conditNow.text = String().switchConditCase(weatherData?.weather[0].description ?? "")
            self.iconNow.image = UIImage(named: weatherData?.weather[0].icon ?? "")
            self.tempBold.text = String(format: "%.1f", weatherData?.main.temp ?? "0.0")
        }
    }

    func didUpdateForecastData(_ networkControl: NetworkControl, forecastData: WeatherData?) {
        DispatchQueue.main.async {
            self.weatherData = forecastData
            self.forecastTableView.reloadData()
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - TableView DataSource and Delegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData?.list.count ?? 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellIdentifier,
                                                       for: indexPath) as? WeatherDetailCell
        else { return UITableViewCell() }

        guard let forecastData = weatherData else { return UITableViewCell() }

        cell.iconCell.image = UIImage(named: forecastData.list[indexPath.row].weather[0].icon ?? "")
        cell.tempCell.text = String().tempString(forecastData.list[indexPath.row].main.temp ?? 0.0)
        cell.conditCell.text = String().switchConditCase(forecastData.list[indexPath.row].weather[0].description ?? "")
        cell.timeCell.text = forecastData.list[indexPath.row].timeStamp ?? ""
        return cell
    }
}

// MARK: - API Connection setup:
extension ViewController {
    private func getForecastData() {
        if let cityCall = ViewController.cityCall {
            // let url = "\(myUrl)&q=\(cityCall)&lang=vi&units=metric"
            // decodeForecast(from: url)
            networkControl.getForecast(in: cityCall)
        } else {
            // let url = "\(myUrl)&q=Berlin&lang=vi&units=metric"
            // decodeForecast(from: url)
            networkControl.getForecast(in: "Berlin")
        }
    }

    private func getCurrentData() {
        if let cityName = ViewController.cityCall {
            networkControl.getCurrent(in: cityName)
        } else {
            networkControl.getCurrent(in: "Berlin")
        }
    }

    private func decodeForecast(from url: String) {
        AlamofirePack.fetchAPIuseAlamofire(from: url) { data in
            let decoder = JSONDecoder()
            do {
                guard let data = data.data(using: .utf8) else {
                    return
                }
                let forecastData = try decoder.decode(WeatherData.self, from: data)
                self.weatherData = forecastData
                print(forecastData)
                DispatchQueue.main.async {
                    self.forecastTableView.reloadData()
                    // self.setForecastForTable()
                }
            } catch {
                print(error)
            }
        } onFail: { error in
            print(error as Any)
        }
    }
}
