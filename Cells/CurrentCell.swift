

import UIKit

class CurrentCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var dayTemperature: UILabel!
    @IBOutlet weak var nightTemperature: UILabel!
    
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
