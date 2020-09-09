
import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    let locationManager: CLLocationManager
    var currentLocationCallBack: (_ currentLocation: CLLocation, _ city: String) -> () = { currentLocation, city in }
    
    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        super.init()
        locationManager.delegate = self
    }
    
    func start(currentLocationCallBack: @escaping ((_ currentLocation: CLLocation, _ city: String) -> (Void))) {
        self.currentLocationCallBack = currentLocationCallBack
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(mostRecentLocation) { (placemarks, error) in
            guard let placemarks = placemarks, let placemark = placemarks.first else { return }
            if let city = placemark.locality {
                self.currentLocationCallBack(mostRecentLocation, city)
            }
        }
    }
}
