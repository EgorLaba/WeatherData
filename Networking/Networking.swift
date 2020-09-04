import Foundation


struct URLPaths {
    static let currentWeather: String = "/weather"
    static let hourlyForecast: String = "/forecast/hourly"
    static let dailyForecast: String = "/forecast/daily"
}

class Networking {
    static let shared = Networking()
    
    private lazy var session = URLSession(configuration: .default)
    private let baseURL: String = "https://api.openweathermap.org/data/2.5"
    private let appid: String = "6ff3fb460d0433db2333415a383c5733"
    private lazy var parameters: [String: String] = [
        "appid": self.appid
    ]
    
    func getCurrentWeather<T: Decodable>(longitude: Double,
                                       latitude: Double,
                                       okHandler: @escaping (T) -> Void,
                                       errorHandler: @escaping () -> Void) {
        self.parameters["lon"] = String(longitude)
        self.parameters["lat"] = String(latitude)
        if let url = getUrlWith(url: baseURL, path: URLPaths.currentWeather, params: parameters) {
            session.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(T.self, from: data)
                        okHandler(response)
                        
                    } catch let error {
                        errorHandler()
                    }
                }
            }.resume()
        }
    }
    
    func getUrlWith(url: String, path: String, params: [String: String]? = nil) -> URL? {
        guard var components = URLComponents(string: url + path) else { return nil }
        if let params = params {
            components.queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
        }
        return components.url
    }
}
