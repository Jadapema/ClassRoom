//
//  SelectGroupViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 9/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit

class SelectGroupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    

    @IBOutlet var CenterView: UIView!
    @IBOutlet var Picker: UIPickerView!
    @IBOutlet var Done: UIButton!
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var subjects : [Subject] = []
    var GroupId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Picker.delegate = self
        Picker.dataSource = self
        
        CenterView.layer.masksToBounds = false
        CenterView.layer.cornerRadius = 5
        CenterView.layer.borderWidth = 1
        CenterView.layer.borderColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.80078125)
        CenterView.clipsToBounds = true
        
        Done.layer.masksToBounds = false
        Done.layer.cornerRadius = 5
        Done.layer.borderWidth = 1
        Done.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6019905822)
        Done.clipsToBounds = true
    }
    

    @IBAction func Done(_ sender: UIButton) {
       
        for sub in subjects {
            if sub.SubId == UserDefaults.standard.object(forKey: "SUBID") as? String {
                if GroupId == nil  {
                    UserDefaults.standard.set(sub.Groups[0].GrId, forKey: "GRID")
                    print("Sended group: \(sub.Groups[0].GroupName!)")
                } else {
                    UserDefaults.standard.set(GroupId!, forKey: "GRID")
                    for g in sub.Groups {
                        if g.GrId! == GroupId! {
                            print("Sended group : \(GroupId!)")
                        }
                    }
                }
                
                
            }
        }
        let check = NSNotification.Name("check")
        NotificationCenter.default.post(name: check, object: nil)
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func BGButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        for sub in subjects {
            if sub.SubId == UserDefaults.standard.object(forKey: "SUBID") as? String {
                return sub.Groups.count
            }
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        for sub in subjects {
            if sub.SubId == UserDefaults.standard.object(forKey: "SUBID") as? String {
                GroupId = sub.Groups[row].GrId!
                print("Grop Selected: \(sub.Groups[row].GroupName!)")
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        for sub in subjects {
            if sub.SubId == UserDefaults.standard.object(forKey: "SUBID") as? String {
                let attributedString = NSAttributedString(string: sub.Groups[row].GroupName!, attributes: [NSForegroundColorAttributeName : UIColor.white])
                return attributedString
                
            }
        }
        let attributedString = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName : UIColor.white])
        return attributedString
    }
    
    
}
