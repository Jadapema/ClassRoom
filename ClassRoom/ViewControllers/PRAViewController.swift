//
//  PRAViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 11/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PRAViewController: UIViewController {

    
    @IBOutlet var BG: UIView!
    @IBOutlet var preguntar: UIButton!
    @IBOutlet var pregunta: UITextField!
    
    var SelectedSubjectId = UserDefaults.standard.object(forKey: "SelectedSubjectId") as! String
    var SelectedGropId = UserDefaults.standard.object(forKey: "SelectedGroupId") as! String
    var SelectedTopic = UserDefaults.standard.object(forKey: "SelectedTopicId") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BG.layer.cornerRadius = 5
        BG.layer.borderWidth = 1
        BG.layer.borderColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.7989083904)
        BG.layer.masksToBounds = false
        BG.clipsToBounds = true
        
        preguntar.layer.cornerRadius = 5
        preguntar.layer.borderWidth = 1
        preguntar.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7018675086)
        preguntar.layer.masksToBounds = false
        preguntar.clipsToBounds = true
        
    }

    
    @IBAction func preguntar(_ sender: UIButton) {
        if pregunta.text == nil || pregunta.text == "" {
            pregunta.backgroundColor = #colorLiteral(red: 0.8459790349, green: 0.2873021364, blue: 0.2579272389, alpha: 1)
        } else {
            FIRDatabase.database().reference().child("Subjects").child("\(SelectedSubjectId)").child("Groups").child("\(SelectedGropId)").child("Classes").child("\(SelectedTopic)").child("Questions").childByAutoId().child("QuestionName").setValue("\(pregunta.text!)")
            dismiss(animated: true, completion: nil)
        }
        
    }
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
