//
//  DryOrNotViewModel.swift
//  dryke
//
//  Created by Sergey Khamenev on 26/08/2023.
//

import SwiftUI
import Combine
import CoreLocation

enum LoadingState {
    case loading
    case loaded(Recommendation)
    case error(String)
    case retry
}

class ForecastViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var loadingState: LoadingState = .loading
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchData() {
        self.loadingState = .loading
        locationManager.requestLocation() // This will trigger didUpdateLocations or didFailWithError
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            self.loadingState = .error("Failed to get location")
            return
        }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // Create URL and URLRequest
        guard let url = URL(string: "http://localhost:8080/api/forecast/dryOrNot") else {
            self.loadingState = .error("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare JSON payload
        let payload = ["latitude": latitude, "longitude": longitude]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            self.loadingState = .error("Failed to serialize payload")
            return
        }
        
        // Make API call
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.loadingState = .error("An error occurred: \(error!.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    self.loadingState = .error("Data is empty")
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                    
                    if let recommendation = decodedResponse.data {
                        self.loadingState = .loaded(recommendation)
                    } else if let error = decodedResponse.error {
                        self.loadingState = .error(error)
                    } else {
                        self.loadingState = .error("Unknown error")
                    }
                } catch {
                    self.loadingState = .error("Failed to decode: \(error)")
                }
            }
        }.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.loadingState = .error("Failed to get location: \(error.localizedDescription)")
    }
    
    func retry() {
        self.loadingState = .retry
        fetchData()
    }
}
