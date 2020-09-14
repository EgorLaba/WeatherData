
import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    // MARK: - Variables
    
    var degrees = "°"
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var currentDayLabel: UILabel!
    @IBOutlet weak var dayTemperatureLabel: UILabel!
    @IBOutlet weak var nightTemperatureLabel: UILabel!
    @IBOutlet weak var todayDescriptionLabel: UILabel!
    
    @IBOutlet weak var dailyWeatherTableView: DailyWeatherTableView!
    @IBOutlet weak var hourlyWeatherCollectionView: HourlyWeatherCollectionView!
        
    // MARK: - Properties
    
    var weather: Weather?
    var city: String?
    
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.start { (currentLocation, city) in
            let longitude = currentLocation.coordinate.longitude
            let latitude = currentLocation.coordinate.latitude
            self.city = city
            LocationManager.shared.stop()
            
            self.loadWeather(longitude, latitude)
        }
    }
    
    private func loadWeather(_ longitude: Double, _ latitude: Double) {
        Networking.shared.getCurrentWeather(
            longitude: longitude,
            latitude: latitude,
            okHandler: { [weak self] model in
                self?.weather = model
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            },
            errorHandler: { [weak self] error in
                DispatchQueue.main.async {
                    self?.handleError(error)
                }
        })
    }
    
    private func handleError(_ error: Error) {
        let title = "Error"
        let message = error.localizedDescription
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    private func updateUI() {
        descriptionLabel.text = weather?.current.weather[0].description
        cityLabel.text = city
        
        if let temp = weather?.current.temp {
            temperatureLabel.text = String(Int(temp)) + degrees
        }
        
        if let hourlyWeather = weather?.hourly {
            hourlyWeatherCollectionView.hourlyWeatherData = hourlyWeather
            hourlyWeatherCollectionView.reloadData()
        }
        
        if let dailyWeather = weather?.daily {
            dailyWeatherTableView.dailyWeatherData = dailyWeather
            dailyWeatherTableView.reloadData()
        }
        
        if let nightTemperature = self.weather?.daily[0].temp.night, let dayTemperature = self.weather?.daily[0].temp.day, let currentDay = weather?.daily[0].dt {
            dayTemperatureLabel.text = String(Int(dayTemperature))
            nightTemperatureLabel.text = String(Int(nightTemperature))
            currentDayLabel.text = currentDay.dayOfWeek()
        }
        
        if let currentTemp = weather?.current.temp, let maxTemp = weather?.daily[0].temp.max, let description = weather?.daily[0].weather[0].description {
            todayDescriptionLabel.text = "Today: \(description). It's \(Int(currentTemp))\(degrees); the high will be \(Int(maxTemp)) \(degrees)."
        }
    }
}
