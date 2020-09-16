
import UIKit

class HourlyCollectionViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    // MARK: - Collection
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyDetailCollectionCell", for: indexPath) as! HourlyDetailCollectionCell
        
        cell.hour.text = "СЕЙЧАС"
        cell.weatherTemp.text = " ХОЛОДНО 8"
        
        return cell
    }
    
}
