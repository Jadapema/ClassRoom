//
//  MessageViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 9/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MessageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var Back: UIImageView!
    @IBOutlet var UserImage: UIImageView!
    @IBOutlet var UserName: UILabel!

    @IBOutlet var MessageTextField: UITextField!
    @IBOutlet var Send: UIImageView!
    
    
    var tabBarIndex: Int?
    var SelectedUser : User!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UserImage.loadImageUsingCacheWithUrlString(SelectedUser.ProfileImageUrl)
        UserImage.layer.masksToBounds = false
        UserImage.layer.borderWidth = 1
        UserImage.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UserImage.layer.cornerRadius = UserImage.frame.height/2
        UserImage.clipsToBounds = true
        UserImage.contentMode = .scaleAspectFit
        UserName.text = SelectedUser.Name
        Back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleBack)))
        Back.isUserInteractionEnabled = true
        Send.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleSend)))
        Send.isUserInteractionEnabled = true
        MessageTextField.delegate = self
    }
    
    func HandleSend() {
        let TimeStamp : Int = Int(NSDate().timeIntervalSince1970)
        let ref = FIRDatabase.database().reference().child("Messages")
        let RefMessage = ref.childByAutoId()
        RefMessage.child("ToId").setValue(SelectedUser.UserId!)
        RefMessage.child("FromId").setValue(FIRAuth.auth()?.currentUser?.uid)
        RefMessage.child("Timestamp").setValue(TimeStamp)
        RefMessage.child("Message").setValue(MessageTextField.text!)
        MessageTextField.text = ""
        
        let userMessageRef = FIRDatabase.database().reference().child("User-Messages").child((FIRAuth.auth()?.currentUser?.uid)!)
        let messageID = RefMessage.key
        userMessageRef.child(messageID).setValue(1)
        
        let RecipientUserMessagesRef = FIRDatabase.database().reference().child("User-Messages").child(SelectedUser.UserId!)
        RecipientUserMessagesRef.child(messageID).setValue(1)
    }
    
    func HandleBack () {
        loadTabBarController(atIndex: 4)
    }
    
    private func loadTabBarController(atIndex: Int){
        self.tabBarIndex = atIndex
        self.performSegue(withIdentifier: "profile", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "profile" {
            let tabbarController = segue.destination as! UITabBarController
            tabbarController.selectedIndex = self.tabBarIndex!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        MessageTextField.resignFirstResponder()
        return true
    }

}
