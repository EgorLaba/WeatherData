
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
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)

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
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyCell

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
