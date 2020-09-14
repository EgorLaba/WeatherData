
import UIKit

// MARK: - Enums

enum Rows: Int, CaseIterable {
    case sunrise
    case sunset
    case humidity
    case wind
    case fellsLike
    case pressure
}

// MARK: - Classes

class CurrentlyWeatherTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    let percent = "%"
    let degrees = "°"
    var currentlyWeatherData: WeatherParams?
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
        dataSource = self
    }
        
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentlyWeatherCell", for: indexPath) as! CurrentlyWeatherCell
        let row = Rows(rawValue: indexPath.row)
        switch row {
        case .sunrise:
            cell.descriptionLabel.text = "SUNRISE"
            if let sunrise = currentlyWeatherData?.sunrise {
                cell.dataLabel.text = sunrise.currentlyData()
            }
        case .sunset:
            cell.descriptionLabel.text = "SUNSET"
            if let sunset = currentlyWeatherData?.sunset {
                cell.dataLabel.text = sunset.currentlyData()
            }
        case .humidity:
            cell.descriptionLabel.text = "HUMIDITY"
            if let humidity = currentlyWeatherData?.humidity {
                cell.dataLabel.text = String(humidity) + percent
            }
        case .wind:
            cell.descriptionLabel.text = "WIND"
            if let windSpeed = currentlyWeatherData?.wind_speed, let windDeg = currentlyWeatherData?.wind_deg {
                let windDirection = Utils.getWindDirection(windDeg)
                cell.dataLabel.text = ("\(windDirection) \(Int(windSpeed)) km/h")
            }
        case .fellsLike:
            cell.descriptionLabel.text = "FEELS LIKE"
            if let feelsLike = currentlyWeatherData?.feels_like {
                cell.dataLabel.text = String(Int(feelsLike)) + degrees
            }
        case .pressure:
            cell.descriptionLabel.text = "PRESSURE"
            if let pressure = currentlyWeatherData?.pressure {
                cell.dataLabel.text = String("\(pressure) hPA")
            }
        case .none:
            break
        }
        return cell
    }
}
