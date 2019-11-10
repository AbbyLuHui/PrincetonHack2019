//
//  ThirdViewController.swift
//  PrincetonHack2019
//
//  Created by yiyang on 11/10/19.
//  Copyright © 2019 LuHui. All rights reserved.
//

import UIKit
import Foundation

 
class ThirdViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var contactField: UITextField!
    @IBOutlet weak var conditionField: UITextField!
    @IBOutlet weak var save: UIButton!
    
    
    
    
    @IBAction func enter(_ sender: Any) {
        if nameField.text != "" && ageField.text != "" && contactField.text != "" && conditionField.text != ""
        {
            name = nameField.text!
            age = ageField.text!
            contact = contactField.text!
            condition = conditionField.text!
            performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    
    
    
/*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondController = segue.destination as! SecondViewController
        secondController.myName = nameField.text!
        secondController.myAge = ageField.text!
        secondController.myContact = contactField.text!
        secondController.myCondition = conditionField.text!
    }
*/

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameField.delegate = self
        ageField.delegate = self
        contactField.delegate = self
        conditionField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameField.resignFirstResponder()
        ageField.resignFirstResponder()
        contactField.resignFirstResponder()
        conditionField.resignFirstResponder()
    }
}

extension ThirdViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
