//
//  SecondViewController.swift
//  PrincetonHack2019
//
//  Created by yiyang on 11/10/19.
//  Copyright © 2019 LuHui. All rights reserved.
//

import UIKit
import Foundation

class SecondViewController: UIViewController {

    
    
    @IBOutlet weak var nameDisp: UILabel!
    @IBOutlet weak var ageDisp: UILabel!
    @IBOutlet weak var contactDisp: UILabel!
    @IBOutlet weak var conditionDisp: UILabel!

    
//    var myName = String()
//    var myAge = String()
//    var myContact = String()
//    var myCondition = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
/*
        nameDisp.text = myName
        ageDisp.text = myAge
        contactDisp.text = myContact
        conditionDisp.text = myCondition
 */
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameDisp.text = name
        ageDisp.text = age
        contactDisp.text = contact
        conditionDisp.text = condition
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
