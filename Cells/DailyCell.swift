
import UIKit

class DailyCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var today: UILabel!
    @IBOutlet weak var dayTemp: UILabel!
    @IBOutlet weak var nightTemp: UILabel!
    @IBOutlet weak var dailyIcon: UIImageView!
    
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
