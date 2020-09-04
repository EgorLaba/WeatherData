
import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var currentWeather: CurrentWeather?
    
    let locationManager = CLLocationManager()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupLocation()
    }
    
    // MARK: - Functions
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let longitude = location.coordinate.longitude
        let latitude = location.coordinate.latitude
        
        locationManager.stopUpdatingLocation()
        
        Networking.shared.getCurrentWeather(
            longitude: longitude,
            latitude: latitude,
            okHandler: { [weak self] (model: CurrentWeather) in
                self?.currentWeather = model
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            },
            errorHandler: { [weak self] in
                DispatchQueue.main.async {
                    self?.handleError()
                }
        })
    }
    
    private func handleError() {
        let title = "Error"
        var message = "Something went wrong!"
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        cell.cityLabel.text = currentWeather?.name
        cell.descriptionLabel.text = currentWeather?.weather[0].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
