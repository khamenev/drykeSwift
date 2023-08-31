//
//  ForecastViewModel.swift
//  dryke
//
//  Created by Sergey Khamenev on 26/08/2023.
//

import Foundation
import CoreLocation
import Combine

enum LoadingState {
    case loading, loaded, error, retry
}

enum LocationPermission {
    case notDetermined, restricted, denied, authorized
}

class ForecastViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var forecastData: ForecastData?
    @Published var loadingState: LoadingState = .loading
    @Published var locationPermission: LocationPermission = .notDetermined
    
    func setForPreview(data: ForecastData?, loadingState: LoadingState = .loaded, locationPermission: LocationPermission = .authorized) {
        self.forecastData = data
        self.loadingState = loadingState
        self.locationPermission = locationPermission
    }
    
    var locationManager: CLLocationManager?
    
    
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    // Additional initializer for previews
    init(loadingState: LoadingState, locationPermission: LocationPermission) {
        super.init() // You must call the designated initializer of the superclass
        self.loadingState = loadingState
        self.locationPermission = locationPermission
    }
    
    func fetchData(latitude: Double, longitude: Double) {
        self.loadingState = .loading
        
        let url = URL(string: "http://localhost:8080/api/forecast/dryOrNot")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = ["latitude": latitude, "longitude": longitude]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(ForecastResponse.self, from: data)
                        self.forecastData = decodedData.data
                        self.loadingState = .loaded
                    } catch {
                        self.loadingState = .error
                    }
                } else {
                    self.loadingState = .error
                }
            }
        }.resume()
    }
    
    func retry() {
        self.loadingState = .retry
        if locationPermission == .authorized {
            self.locationManager?.startUpdatingLocation()
        } else {
            self.locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationPermission = .notDetermined
        case .restricted:
            locationPermission = .restricted
        case .denied:
            locationPermission = .denied
        case .authorizedAlways, .authorizedWhenInUse:
            locationPermission = .authorized
            locationManager?.startUpdatingLocation()
        @unknown default:
            locationPermission = .notDetermined
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            fetchData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.loadingState = .error
    }
}
