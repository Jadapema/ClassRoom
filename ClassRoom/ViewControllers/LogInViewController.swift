//
//  LogInViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 16/8/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseAuth


class LogInViewController: UIViewController, UITextFieldDelegate {
    //Outlets
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    //Hide the StatusBar
    override var prefersStatusBarHidden: Bool {
        return true
    }
                                        //BeforeView Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.email.delegate = self
        self.password.delegate = self
        
//        FIRAuth.auth()?.currentUser?.getTokenForcingRefresh(true, completion: { (idToken, error) in
//            if error == nil {
//                print(error)
//            } else {
//
//                print("\(idToken)")
//
//            }
//        })
        
        
    }
                                        //IBActions
    //Button "Iniciar Sesion" Action
    @IBAction func LogIn(_ sender: UIButton) {
        //LogIn With Email and Password
        FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!, completion: { (user, error) in
            //Check if the User Exist
            if user != nil {
                //LogIn Sucessfully
                print(" Log In Sucessfully")
                //Present the SubjectVC
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let MainVC = storyboard.instantiateViewController(withIdentifier: "Main")
                self.present(MainVC, animated: true, completion: nil)
            } else {
                if let myError = error?.localizedDescription {
                    print(myError)
                } else {
                    print("Error")
                }
            }
        })
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
