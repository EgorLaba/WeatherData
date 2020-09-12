
import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables
    
    var degrees = "°"
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var currentlyWeather: UILabel!
    
        
    // MARK: - Properties
    
    var weather: Weather?
    var city: String?
    
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        self.weatherDescription.text = self.weather?.current.weather[0].description
        cityName.text = self.city
        
        if let temp = self.weather?.current.temp {
            currentlyWeather.text = String(Int(temp)) + degrees
        }
        self.tableView.reloadData()
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentCell", for: indexPath) as! CurrentCell
            if let nightTemperature = self.weather?.daily[indexPath.row].temp.night, let dayTemperature = self.weather?.daily[indexPath.row].temp.day, let currentDay = weather?.daily[indexPath.row].dt  {
                cell.nightTemperature.text = String(Int(nightTemperature))
                cell.dayTemperature.text = String(Int(dayTemperature))
                cell.day.text = Date.dayOfWeek(currentDay)
                return cell
            }
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyWeatherCell", for: indexPath) as! HourlyWeatherCell
            if let hourlyWeather =  weather?.hourly {
                cell.hourlyWeatherData = hourlyWeather
                cell.hourlyWeatherCollectionView.reloadData()
            }
            return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyCell
            if let dayTemp = self.weather?.daily[indexPath.row].temp.day, let nightTemp = self.weather?.daily[indexPath.row].temp.night, let day = weather?.daily[indexPath.row].dt {
                cell.dayTemp.text = String(Int(dayTemp))
                cell.nightTemp.text = String(Int(dayTemp))
                cell.today.text = Date.dayOfWeek(day)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height : CGFloat
        if indexPath.row == 1 {
            height = 120.0
        } else{
            height = 50.0
        }
        return height
    }
}

