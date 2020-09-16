
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
    @IBOutlet weak var currentlyWeatherTableView: CurrentlyWeatherTableView!
        
    // MARK: - Properties
    
    var city: String?
    
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        LocationManager.shared.start { (currentLocation, city) in
            let longitude = currentLocation.coordinate.longitude
            let latitude = currentLocation.coordinate.latitude
            self.city = city
            LocationManager.shared.stop()

            self.loadWeather(longitude, latitude)
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private
    
    private func loadWeather(_ longitude: Double, _ latitude: Double) {
        Networking.shared.getCurrentWeather(
            longitude: longitude,
            latitude: latitude,
            okHandler: { [weak self] in
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
        guard let weather = CoreDataManager.sharedInstance.getWeather() else { return }
        
        cityLabel.text = city
        descriptionLabel.text = (weather.current.weather.allObjects.first as? WeatherDescription)?.info
        
        temperatureLabel.text = String(Int(weather.current.temp)) + degrees
        
        if let hourlyWeather = (weather.hourly as? Set<WeatherParams>)?.sorted(by: { $0.dt < $1.dt }) {
            hourlyWeatherCollectionView.hourlyWeatherData = hourlyWeather
            hourlyWeatherCollectionView.reloadData()
        }
        
        if let dailyWeather = (weather.daily as? Set<Daily>)?.sorted(by: { $0.dt < $1.dt }) {
            dailyWeatherTableView.dailyWeatherData = dailyWeather
            dailyWeatherTableView.reloadData()
        }
        
        if let dailyWeather = (weather.daily as? Set<Daily>)?.sorted(by: { $0.dt < $1.dt }).first {
            dayTemperatureLabel.text = String(Int(dailyWeather.temp.day))
            nightTemperatureLabel.text = String(Int(dailyWeather.temp.night))
        }
        
        currentDayLabel.text = weather.current.dt.dayOfWeek()
        
        if let info = (weather.current.weather.allObjects.first as? WeatherDescription)?.info {
            todayDescriptionLabel.text = "Today: \(info). It's \(Int(weather.current.temp))\(degrees)"
        }
        
        currentlyWeatherTableView.currentlyWeatherData = weather.current
        currentlyWeatherTableView.reloadData()
    }
}
