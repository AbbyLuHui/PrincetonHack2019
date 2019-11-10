//
//  ButtonViewController.swift
//  PrincetonHack2019
//
//  Created by yiyang on 11/10/19.
//  Copyright © 2019 LuHui. All rights reserved.
//

import UIKit

class ButtonViewController: UIViewController {

    @IBOutlet weak var longButton: UIButton!
    var longGesture = UILongPressGestureRecognizer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ButtonViewController.longPress(_:)))
        longButton.addGestureRecognizer(longGesture)
    }
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began
        {
            let alertC = UIAlertController(title:nil, message: "Emergency action cancelled", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default){(alert) in}
            alertC.addAction(ok)
            self.present(alertC, animated: true, completion: nil)

        }
    }



}
