

import UIKit

class WeatherCell: UITableViewCell {
    
    // MARK: - Lifecycle
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
