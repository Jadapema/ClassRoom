//
//  SubjectDetail_AddGroupViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 4/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SubjectDetail_AddGroupViewController: UIViewController {

    
    @IBOutlet var GroupName: UITextField!
    @IBOutlet var TeacherName: UITextField!
    @IBOutlet var PopView: UIView!
    @IBOutlet var AddButton: UIButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var SelectedSubject : Subject!
    
    override func viewWillDisappear(_ animated: Bool) {
        
//        if self.view.isHidden == false {
//            self.view.isHidden = true
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PopView.layer.masksToBounds = false
        PopView.layer.cornerRadius = 5
        PopView.layer.borderColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
        PopView.layer.borderWidth = 1
        PopView.clipsToBounds = true
        
        AddButton.layer.masksToBounds = false
        AddButton.layer.cornerRadius = 5
        AddButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        AddButton.layer.borderWidth = 1
        AddButton.clipsToBounds = true
    }

    @IBAction func BGButton(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            //Refrescamos los valores de nuestra tabla
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    @IBAction func AddGroup(_ sender: UIButton) {
        
        let refNewGroup = FIRDatabase.database().reference().child("Subjects").child("\(SelectedSubject.SubId!)").child("Groups").childByAutoId()
        refNewGroup.child("GroupName").setValue(GroupName.text!)
        refNewGroup.child("Teacher").child("Name").setValue(TeacherName.text!)
        refNewGroup.child("Members").child("\((FIRAuth.auth()?.currentUser?.uid)!)").setValue(true)
        let notification = NSNotification.Name("SubjectDetailFetchAll")
        NotificationCenter.default.post(name: notification, object: nil)
        dismiss(animated: true, completion: nil)

    }
    
    
    
}
