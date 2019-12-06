//
//  LocationInfoViewController.swift
//  LocationInfo
//
//  Created by STV-M025 on 2019/12/04.
//  Copyright © 2019 STV-M025. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SystemConfiguration.CaptiveNetwork

import Realm
import RealmSwift

import Reachability

class LocationInfoViewController: UIViewController {
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var wifiLatitude: UILabel!
    @IBOutlet weak var wifiLongitude: UILabel!
    
    @IBOutlet weak var gpsLatitude: UILabel!
    @IBOutlet weak var gpsLongitude: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Action
extension LocationInfoViewController {
    @IBAction func TappedLocationUpdate(_ sender: UIButton) {
        
        locationManager = CLLocationManager()
        
        let status = CLLocationManager.authorizationStatus()
        if (status == .notDetermined) {
            locationManager?.requestAlwaysAuthorization()
        }
        
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationInfoViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last
        if let last = lastLocation {
            let eventDate = last.timestamp
            if let location = manager.location {
                
                let latitude = String(location.coordinate.latitude)
                let longitude = String(location.coordinate.longitude)
                
                var reachability: Reachability
                
                do {
                    reachability = try Reachability()
                } catch {
                   return
                }
                print("タイムスタンプ：\(eventDate)")
                print("緯度：\(latitude)\n経度：\(longitude)")
                
                switch reachability.connection {
                case .cellular:
                    gpsLatitude.text = latitude
                    gpsLongitude.text = longitude
                    break

                case .wifi:
                    wifiLatitude.text = latitude
                    wifiLongitude.text = longitude
                    break

                default:
                    break
                }
            }
        }
        locationManager = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .restricted) {
            print("機能制限している");
        }
        else if (status == .denied) {
            print("許可していない");
        }
        else if (status == .authorizedWhenInUse) {
            print("このアプリ使用中のみ許可している");
        }
        else if (status == .authorizedAlways) {
            print("常に許可している");
        }
    }
}
