
//  PRViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 11/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PRViewController: UIViewController, UITextFieldDelegate , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var BG: UIView!
    @IBOutlet var RespuestasTableView: UITableView!
    @IBOutlet var Question: UILabel!
    @IBOutlet var responder: UIButton!
    @IBOutlet var Res: UITextField!
    
    var SelectedSubjectId = UserDefaults.standard.object(forKey: "SelectedSubjectId") as! String
    var SelectedGropId = UserDefaults.standard.object(forKey: "SelectedGroupId") as! String
    var SelectedTopic = UserDefaults.standard.object(forKey: "SelectedTopicId") as! String
    var Q : Pregunta!
    var R : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchAll()
        Question.text = Q.QuestionName
        Res.delegate = self
        
        RespuestasTableView.delegate = self
        RespuestasTableView.dataSource = self
        
        RespuestasTableView.estimatedRowHeight = 100
        RespuestasTableView.rowHeight = UITableViewAutomaticDimension
        
        RespuestasTableView.setNeedsLayout()
        RespuestasTableView.layoutIfNeeded()
        RespuestasTableView.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        
        
        BG.layer.cornerRadius = 10
        BG.layer.borderWidth = 1
        BG.layer.borderColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.7989083904)
        BG.layer.masksToBounds = false
        BG.clipsToBounds = true
        
        responder.layer.cornerRadius = 5
        responder.layer.borderWidth = 1
        responder.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7018675086)
        responder.layer.masksToBounds = false
        responder.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return R.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PR", for: indexPath) as! responsesTableViewCell
        cell.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        cell.BG.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
        cell.BG.layer.cornerRadius = 10
        cell.BG.layer.borderWidth = 1
        cell.BG.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5961312072)
        cell.BG.layer.masksToBounds = false
        cell.BG.clipsToBounds = true
        cell.Response.text = R[indexPath.row]
        
        return cell
    }

    @IBAction func Responder(_ sender: UIButton) {
        
        if Res.text == nil || Res.text == "" {
            Res.backgroundColor = #colorLiteral(red: 0.8459790349, green: 0.2873021364, blue: 0.2579272389, alpha: 1)
        } else {
            FIRDatabase.database().reference().child("Subjects").child("\(SelectedSubjectId)").child("Groups").child("\(SelectedGropId)").child("Classes").child("\(SelectedTopic)").child("Questions").child("\(Q.QuestionID!)").child("Responses").childByAutoId().setValue("\(Res.text!)")
            Res.text = ""
        }
        
    }
    

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Res.resignFirstResponder()
        return true
    }
    
    
    func FetchAll () {
//        print("Fecth")
        FIRDatabase.database().reference(fromURL: "https://classroom-19991.firebaseio.com/").observe(.value, with: { snapshot in
            self.R.removeAll()
            //Creamos un diccionario con la base de datos completa
//            print("Snap")
            if let dictionary = snapshot.value as? [String:AnyObject] {
//                print("dict")
                //Creamos un diccionario con la seccion de las asignaturas
                if let subject = dictionary["Subjects"] as? Dictionary<String,AnyObject> {
//                    print("Subjec")
                    //Recorremos la seccion de asignaturas con un ciclo para obtener el valor de cada una, obviando la llave
                    for (Key,value) in subject {
                        if Key == self.SelectedSubjectId {
                            
//                            print("Entro SUbject \(self.SelectedSubjectId)")
                            //Almacenamos todos los valores de cada Asignatura en un diccionario nuevo
                            if let sub = value as? Dictionary<String,AnyObject> {
                                //Chequeamos que existan SubjectName y Description y los almacenamos en sus respectivas variables
                                if let groups = sub["Groups"] as? Dictionary<String,AnyObject> {
                                    for (K,V) in groups {
                                        if K == self.SelectedGropId {
                                            if K == self.SelectedGropId {
//                                                print("Entro Grupo \(self.SelectedGropId)")
                                                if let Topics = V["Classes"] as? Dictionary<String,AnyObject> {
                                                    for (Id,Va) in Topics {
                                                        if Id == self.SelectedTopic {
//                                                            print("Entro topic \(self.SelectedTopic)")
                                                            
                                                                if let Questions = Va["Questions"] as? Dictionary<String,AnyObject> {
//                                                                    print("Entro Questions")
                                                                    for (ID,QU) in Questions {
                                                                        if ID == self.Q.QuestionID {
                                                                            if let res = QU["Responses"] as? Dictionary<String,AnyObject> {
                                                                                for (_,r) in res {
//                                                                                    print("Is apprending")
                                                                                    self.R.append(r as! String)
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                   
                                                                self.RespuestasTableView.reloadData()
                                                            }
                                                        
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }

}
