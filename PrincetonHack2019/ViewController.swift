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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    //MAP
    @IBOutlet weak var map: MKMapView?
    
    let location = CLLocationManager()
    let motion = CMMotionManager()
    var accelerometerUpdateInterval: TimeInterval { 1 }
    static let home_latitude = 39.350165785922435;
    static let home_longitude = -73.65276497931727;
    var inEmergency:Bool = false;
    var called:Bool = true;
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0001, longitudeDelta: 0.0001))
            map?.setRegion(region, animated: true)
            print("New location: \(location.coordinate) ")
            let latitude_diff = Double(location.coordinate.latitude) - ViewController.home_latitude
            let longitude_diff = Double(location.coordinate.longitude) - ViewController.home_latitude
            if (abs(latitude_diff) > 0.01 || abs(longitude_diff) > 0.01) && called{
                //let coordinate = String(location.coordinate.latitude).prefix(10)+","+String(location.coordinate.longitude).prefix(10)
                self.alertFamily(domain: "text", input: ["latitude":String(location.coordinate.latitude), "longitude":String(location.coordinate.longitude)], completion: printCompletion(input:))
                called=false;
            }
            if abs(latitude_diff) < 0.01 || abs(longitude_diff) < 0.01 {
                called=true;
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
        self.motion.accelerometerUpdateInterval = 1.0/20.0   // 60 Hz
        self.motion.startAccelerometerUpdates(to: OperationQueue.current!){(data, error) in
            if let trueData = data{
                self.view.reloadInputViews()
                let x = trueData.acceleration.x
                let y = trueData.acceleration.y
                let z = trueData.acceleration.z
                if abs(x)>3 || abs(y)>3 || abs(z)>3{
                    self.alertFamily(domain: "call", input: ["phoneNumber":"Out of zone"], completion: self.printCompletion(input:))
                    self.emergency()
                }
            }
        }
       }
    }
    
    
    
    // If there is an emergency, call python backend
    func alertFamily(domain: String, input:  [String:String], completion: @escaping(String) -> Void?) {
        let json = input
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let url = NSURL(string: "http://10.25.3.190:5000/\(domain)/")!
            
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
        print("successfully send message / call with \(input)")
    }
    

    
    @objc func emergency() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let goTo = storyBoard.instantiateViewController(withIdentifier: "Button")
        self.present(goTo, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        map?.delegate = self
        map?.showsUserLocation = true
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
