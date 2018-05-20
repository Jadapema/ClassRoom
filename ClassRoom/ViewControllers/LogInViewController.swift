//
//  LogInViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 16/8/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//
//class

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    //Outlets
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    //Variables
    var firebase = FirebaseController()
    
    //Hide the StatusBar
    override var prefersStatusBarHidden: Bool {
        return true
    }
                                        //BeforeView Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.email.delegate = self
        self.password.delegate = self
    }
                                        //IBActions
    //Button "Iniciar Sesion" Action
    @IBAction func LogIn(_ sender: UIButton) {
        //LogIn With Email and Password
        firebase.Login(email: email.text!, password: password.text!) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let MainVC = storyboard.instantiateViewController(withIdentifier: "Main")
            self.present(MainVC, animated: true, completion: nil)
        }
    }
                                        //Other Functions
    //Hide Keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        email.resignFirstResponder()
        password.resignFirstResponder()
        return true
        
    }

}
