//
//  ButtonViewController.swift
//  PrincetonHack2019
//
//  Created by yiyang on 11/10/19.
//  Copyright © 2019 LuHui. All rights reserved.
//

import UIKit

// var buttonPressed = true

class ButtonViewController: UIViewController {

    @IBOutlet weak var longButton: UIButton!
    var longGesture = UILongPressGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ButtonViewController.longPress(_:)))
        longButton.addGestureRecognizer(longGesture)
        
/*
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.longPress(_:)), userInfo: nil, repeats: true)
        timer.tolerance = 10
 */
    }
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began
        {
            // notification
            let alertC = UIAlertController(title:nil, message: "Emergency action cancelled", preferredStyle: .alert)
            // also back to main
            let ok = UIAlertAction(title: "OK", style: .default, handler: {action in self.GoTo()})
            alertC.addAction(ok)
            self.present(alertC, animated: true, completion: nil)
        }
/*
        else {
            buttonPressed = false
        }
 */
    }
    
    func GoTo(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let goTo = storyBoard.instantiateViewController(withIdentifier: "Intro")
        self.present(goTo, animated: true, completion: nil)
    }



}
