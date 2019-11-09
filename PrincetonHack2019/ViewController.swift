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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let location = locations[0]
        if let location = locations.last{
            print("New location: \(location.coordinate) ")
        }
    }
    func startAccelerometerUpdates(to queue: OperationQueue, withHandler handler: @escaping CMAccelerometerHandler){
        if self.motion.isAccelerometerAvailable{
            self.motion.accelerometerUpdateInterval = 1.0 / 100.0
            
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

