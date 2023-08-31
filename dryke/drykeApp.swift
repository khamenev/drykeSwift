//
//  drykeApp.swift
//  dryke
//
//  Created by Sergey Khamenev on 26/08/2023.
//

import SwiftUI

@main
struct DrykeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var forecastViewModel = ForecastViewModel()
    
    var body: some Scene {
        WindowGroup {
            ForecastView(viewModel: forecastViewModel)
        }
    }
}
