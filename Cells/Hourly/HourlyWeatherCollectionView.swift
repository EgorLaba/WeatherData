
import UIKit

class HourlyWeatherCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    var hourlyWeatherData: [WeatherParams] = []
    var degrees = "°"

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
    }
    
    // MARK: - Collection
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCell", for: indexPath) as! HourlyWeatherCell
        let hourlyWeather = hourlyWeatherData[indexPath.row].temp
        cell.weatherTemp.text = String(Int(hourlyWeather)) + degrees
        
        cell.hourlyIcon.image = nil
        if let iconHourly = (hourlyWeatherData[indexPath.row].weather.allObjects.first as? WeatherDescription)?.icon {
            cell.hour.text = hourlyWeatherData[indexPath.row].dt.hourlyData()
            cell.hourlyIcon.image = UIImage(named: iconHourly)
        }
        return cell
    }
}


