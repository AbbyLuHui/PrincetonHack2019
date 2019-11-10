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
import Foundation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    
    
    //MAP
    @IBOutlet weak var map: MKMapView!
    
    //location
    @IBOutlet weak var locationDisplay: UILabel!
    
    let location = CLLocationManager()
    let motion = CMMotionManager()
    var accelerometerUpdateInterval: TimeInterval { 1 }
    static let home_latitude = 20.0;
    static let home_longitude = 20.0;
    var inEmergency:Bool = false;
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let location = locations[0]
        if let location = locations.last{
            print("New location: \(location.coordinate) ")
            if Double(location.coordinate.latitude) - ViewController.home_latitude > 20 || Double(location.coordinate.longitude) - ViewController.home_latitude > 20{
                self.alertFamily(domain: "location", input: ["phoneNumber":"Out of zone"], completion: printCompletion(input:))
            }
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
            if let trueData = data{
                self.view.reloadInputViews()
                let x = trueData.acceleration.x
                let y = trueData.acceleration.y
                let z = trueData.acceleration.z
                //print(x)
                //print(y)
                //print(z)
            }
        }
       }
    }
    
    
    
    // If there is an emergency, call python backend
    private func alertFamily(domain: String, input:  [String:String], completion: @escaping(String) -> Void?) {
        let json = input
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            print(jsonData)
            let url = NSURL(string: "http://10.25.3.190/\(domain)/")!
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            
            request.setValue("application/json; charset=utf-8",forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            print(String(describing: jsonData))
     
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error1 -> \(String(describing: error))")
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    print ("Result -> \(String(describing: result))")
                    
                    // retrieving video from firebase and showing on screen
                    
                    completion("Result -> \(String(describing: result))")
                } catch {
                    completion("Error2 -> \(error)")
                }
            }
            task.resume()
        } catch {
            print(error)
        }
    }
    
    private func printCompletion(input: String) {
        print("successfully got message from backend: \(input)")
    }
    
    




    @IBOutlet weak var longButton: UIButton!
    var longGesture = UILongPressGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.requestAlwaysAuthorization()
        location.startUpdatingLocation()
        location.allowsBackgroundLocationUpdates = true
        startAccelerometers()
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress(_:)))
        longButton.addGestureRecognizer(longGesture)
    }
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        let alertController = UIAlertController(title:nil, message: "Emergency action dismissed", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default){(alert) in}
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
