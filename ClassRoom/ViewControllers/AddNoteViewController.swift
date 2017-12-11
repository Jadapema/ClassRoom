//
//  AddNoteViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 8/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddNoteViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet var NoteTextView: UITextView!
    @IBOutlet var AddNoteBG: UIView!
    
    
    var SelectedSubjectId = UserDefaults.standard.object(forKey: "SelectedSubjectId") as! String
    var SelectedGropId = UserDefaults.standard.object(forKey: "SelectedGroupId") as! String
    var SelectedTopic = UserDefaults.standard.object(forKey: "SelectedTopicId") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddNoteBG.layer.masksToBounds = false
        AddNoteBG.layer.cornerRadius = 5
        AddNoteBG.clipsToBounds = true
        NoteTextView.delegate = self
        
    }

    
    @IBAction func AddNote(_ sender: UIButton) {
        
        let vid = FIRDatabase.database().reference().child("Subjects").child("\(self.SelectedSubjectId)").child("Groups").child("\(self.SelectedGropId)").child("Classes").child("\(self.SelectedTopic)").child("Notes").childByAutoId()
        vid.setValue(NoteTextView.text!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //Hide Keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NoteTextView.resignFirstResponder()
        return true
    }
    
    
}
