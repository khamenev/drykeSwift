//
//  AppDelegate.swift
//  dryke
//
//  Created by Sergey Khamenev on 26/08/2023.
//

import UIKit
import CoreLocation

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .notDetermined:
                // The user has not yet made a choice about location permissions
                print("Location status not determined.")
            case .restricted:
                // The app is not authorized to use location services
                print("Location status restricted.")
            case .denied:
                // The user denied the use of location
                print("Location status denied.")
            case .authorizedWhenInUse:
                // The app is authorized to use location only when the app is in the foreground
                print("Location status authorized when in use.")
            case .authorizedAlways:
                // The app is authorized to use location services whenever the app is running
                print("Location status authorized always.")
            @unknown default:
                // A new case was introduced that we need to handle
                print("Did not recognize the new location status.")
            }
            
            // Can also update your ViewModel or trigger other logic here
        }
    }
