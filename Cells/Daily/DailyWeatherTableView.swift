
import UIKit

class DailyWeatherTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    var dailyWeatherData: [Daily] = []
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
        dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyWeatherCell", for: indexPath) as! DailyWeatherCell
        let dailyWeather = dailyWeatherData[indexPath.row].temp
        cell.dayLabel.text = dailyWeatherData[indexPath.row].dt.dayOfWeek()
        cell.dayTempLabel.text = String(Int(dailyWeather.day))
        cell.nightTempLabel.text = String(Int(dailyWeather.night))
        cell.dailyIconImage.image = UIImage(named: dailyWeatherData[indexPath.row].weather[0].icon)
        return cell
    }
}


//let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyCell
//            if let dayTemp = weather?.daily[indexPath.row - 2].temp.day, let nightTemp = weather?.daily[indexPath.row - 2].temp.night, let today = weather?.daily[indexPath.row - 2].dt.dayOfWeek(), let dailyIcon = weather?.daily[indexPath.row - 2].weather[0].icon {
//                cell.dayTemp.text = String(Int(dayTemp))
//                cell.nightTemp.text = String(Int(nightTemp))
//                cell.today.text = today
//                cell.dailyIcon.image = UIImage(named: dailyIcon)
//            }
