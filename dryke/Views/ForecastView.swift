//
//  ForecastView.swift
//  dryke
//
//  Created by Sergey Khamenev on 26/08/2023.
//

import SwiftUI
import CoreLocation

struct ForecastView: View {
    @ObservedObject var viewModel: ForecastViewModel
    @State private var animationFlag = false
    
    var body: some View {
        VStack {
            // Add a title
            Text("Dryke")
                .font(.largeTitle)
                .padding(.top, 20)
            
            Divider()
            
            switch viewModel.loadingState {
            case .loading:
                Text("Loading...")
                    .font(.headline)
            case .loaded:
                if let data = viewModel.forecastData {
                    Spacer()
                    Text("Is the weather suitable for drying outside?")
                        .font(.headline)
                        .padding(.top, 20)
                    
                    Text("\(data.isRecommended ? "Yes, you can do it" : "No, not recommended")")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(data.isRecommended ? Color.green : Color.red)
                        .underline()
                    
                    Divider()
                    
                    if let recommendations = data.recommendations {
                        Text("Recommendations:")
                            .font(.headline)
                        
                        VStack {
                            ForEach(recommendations, id: \.self) { recommendation in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text(recommendation)
                                }
                            }
                        }
                    }
                    
                    // Displaying reject reasons
                    if let rejectReasons = data.rejectReasons {
                        Text("Reasons:")
                            .font(.headline)
                        
                        VStack {
                            ForEach(rejectReasons, id: \.self) { reason in
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                    Text(reason)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
            case .error:
                Text("An error occurred.")
                    .font(.headline)
                    .foregroundColor(.red)
            case .retry:
                Text("Retry")
                    .font(.headline)
                    .foregroundColor(.yellow)
            }
            
            if viewModel.locationPermission == .denied {
                Button("Open Settings") {
                    // Logic to open settings
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            if viewModel.loadingState == .retry || viewModel.loadingState == .error {
                Button("Retry") {
                    viewModel.retry()
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .onAppear {
            if viewModel.locationPermission == .authorized {
                viewModel.locationManager?.startUpdatingLocation()
            } else if viewModel.locationPermission == .denied {
                viewModel.loadingState = .retry
            }
        }
    }
}



struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample ForecastData object to simulate a real API response.
        let sampleForecastData = ForecastData(isRecommended: true, recommendations: ["Use sunscreen", "Wear a hat"], rejectReasons: nil)
        
        // Create a new ForecastViewModel.
        let loadedViewModel = ForecastViewModel()
        
        // Manually set the loaded data and state for the preview.
        loadedViewModel.setForPreview(data: sampleForecastData)
        
        return ForecastView(viewModel: loadedViewModel)
    }
}


