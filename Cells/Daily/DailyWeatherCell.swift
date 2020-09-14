
import UIKit

class DailyWeatherCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    @IBOutlet weak var dailyIconImage: UIImageView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
