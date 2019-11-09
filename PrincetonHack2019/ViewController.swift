//
//  ViewController.swift
//  PrincetonHack2019
//
//  Created by LuHui on 2019/11/8.
//  Copyright © 2019 LuHui. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //MAP
    @IBOutlet weak var map: MKMapView!
    
    //location
    @IBOutlet weak var locationDisplay: UILabel!
    
    @IBAction func LongPress(_ sender: Any) {
    }
    
    let location = CLLocationManager()
    let motion = CMMotionManager()
    var accelerometerUpdateInterval: TimeInterval { 1 }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let location = locations[0]
        if let location = locations.last{
            print("New location: \(location.coordinate) ")
        }
    }
    
    @IBAction func enabledChanged(_ sender: UISwitch) {
      if sender.isOn {
        location.startUpdatingLocation()
      } else {
        location.stopUpdatingLocation()
      }
    }
    
    @IBAction func accuracyChanged(_ sender: UISegmentedControl) {
      let accuracyValues = [
        kCLLocationAccuracyBestForNavigation,
        kCLLocationAccuracyBest,
        kCLLocationAccuracyNearestTenMeters,
        kCLLocationAccuracyHundredMeters,
        kCLLocationAccuracyKilometer,
        kCLLocationAccuracyThreeKilometers]
      
      location.desiredAccuracy = accuracyValues[sender.selectedSegmentIndex];
    }
    
    func startAccelerometers() {
       // Make sure the accelerometer hardware is available.
       if self.motion.isAccelerometerAvailable {
        self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
        self.motion.startAccelerometerUpdates(to: OperationQueue.current!){(data, error) in
            print(data as Any)
            if let trueData = data{
                self.view.reloadInputViews()
                let x = trueData.acceleration.x
                let y = trueData.acceleration.y
                let z = trueData.acceleration.z
                print(x)
                print(y)
                print(z)
            }
        }
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.requestAlwaysAuthorization()
        location.startUpdatingLocation()
        location.allowsBackgroundLocationUpdates = true
        startAccelerometers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

