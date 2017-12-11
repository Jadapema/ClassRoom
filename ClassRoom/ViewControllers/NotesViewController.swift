//
//  NotesViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 7/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class NotesViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var Cancel: UIImageView!
    @IBOutlet var TopicName: UILabel!
    @IBOutlet var AddNote: UIImageView!
    @IBOutlet var NotesTableView: UITableView!
    @IBOutlet var BottonBG: UIView!
    @IBOutlet var Subject: UILabel!
    @IBOutlet var Group: UILabel!
    @IBOutlet var top: UILabel!
    @IBOutlet var BG: UIView!
    
    
    var SelectedSubjectId = UserDefaults.standard.object(forKey: "SelectedSubjectId") as! String
    var SelectedGropId = UserDefaults.standard.object(forKey: "SelectedGroupId") as! String
    var SelectedTopic = UserDefaults.standard.object(forKey: "SelectedTopicId") as! String
    var topic : Topic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchAll()
        NotesTableView.delegate = self
        NotesTableView.dataSource = self
        Cancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleCancel)))
        Cancel.isUserInteractionEnabled = true
        AddNote.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleAddNote)))
        AddNote.isUserInteractionEnabled = true
        
        NotesTableView.estimatedRowHeight = 100
        NotesTableView.rowHeight = UITableViewAutomaticDimension
        NotesTableView.setNeedsLayout()
        NotesTableView.layoutIfNeeded()
        BottonBG.layer.masksToBounds = false
        BottonBG.layer.cornerRadius = 5
        BottonBG.layer.borderWidth = 2
        BottonBG.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7018675086)
        BottonBG.clipsToBounds = true
        NotesTableView.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        BG.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        BG.layer.cornerRadius = 5
        BG.layer.borderWidth = 1
        BG.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7018675086)
        BG.layer.masksToBounds = false
        BG.clipsToBounds = true

        
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if topic != nil {
            return topic.NotesA.count
        } else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note") as! NotesTableViewCell
        cell.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        cell.NoteLabel.text = topic.NotesA[indexPath.row]
        cell.BGView.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
        cell.BGView.layer.masksToBounds = false
        cell.BGView.layer.borderWidth = 1
        cell.BGView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7018675086)
        cell.BGView.layer.cornerRadius = 5
        cell.BGView.clipsToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func HandleCancel () {
        dismiss(animated: true, completion: nil)
    }
    func HandleAddNote () {
        performSegue(withIdentifier: "AddNote", sender: self)
    }
    
    
    func FetchAll () {
      //  print("Fecth")
        FIRDatabase.database().reference(fromURL: "https://classroom-19991.firebaseio.com/").observe(.value, with: { snapshot in
            //Creamos un diccionario con la base de datos completa
           // print("Snap")
            if let dictionary = snapshot.value as? [String:AnyObject] {
               // print("dict")
                //Creamos un diccionario con la seccion de las asignaturas
                if let subject = dictionary["Subjects"] as? Dictionary<String,AnyObject> {
                  //  print("Subjec")
                    //Recorremos la seccion de asignaturas con un ciclo para obtener el valor de cada una, obviando la llave
                    for (Key,value) in subject {
                        if Key == self.SelectedSubjectId {
                            
                          //  print("Entro SUbject \(self.SelectedSubjectId)")
                            //Almacenamos todos los valores de cada Asignatura en un diccionario nuevo
                            if let sub = value as? Dictionary<String,AnyObject> {
                                if let SN = sub["SubjectName"] as? String {
                                    self.Subject.text = SN
                                }
                                //Chequeamos que existan SubjectName y Description y los almacenamos en sus respectivas variables
                                if let groups = sub["Groups"] as? Dictionary<String,AnyObject> {
                                    for (K,V) in groups {
                                        if K == self.SelectedGropId {
                                            if K == self.SelectedGropId {
                                                if let GR = V["GroupName"] as? String {
                                                    self.Group.text = GR
                                                }
                                          //  print("Entro Grupo \(self.SelectedGropId)")
                                            if let Topics = V["Classes"] as? Dictionary<String,AnyObject> {
                                                for (Id,Va) in Topics {
                                                    if Id == self.SelectedTopic {
                                                        if let TN = Va["Topic"] as? String {
                                                            self.top.text = TN
                                                        }
                                                      //  print("Entro topic \(self.SelectedTopic)")
                                                        if let TopicName = Va["Topic"]   {
                                                          //  print("Entro entro")
                                                            let T = Topic()
                                                            T.Topic = TopicName as! String
                                                            T.TopicId = Id
                                                            if let Images = Va["Images"] as? Dictionary<String,AnyObject> {
                                                           //     print("Entro Images")
                                                                for (_,imgURL) in Images {
                                                                    // let url = URL(fileURLWithPath: imgURL as! String)
                                                                    T.ImagesUrlString.append(imgURL as! String)
                                                                }
                                                            }
                                                            if let Notes = Va["Notes"] as? Dictionary<String,AnyObject> {
                                                              //  print("Entro Notes")
                                                                for (_,nota) in Notes {
                                                                    T.NotesA.append(nota as! String)
                                                                }
                                                            }
                                                            if let Videos = Va["Videos"] as? Dictionary<String,AnyObject> {
                                                              //  print("Entro Videos")
                                                                for (_,VidURL) in Videos {
                                                                    if let duration = VidURL["VideoDuration"] {
                                                                        if duration != nil {
                                                                        T.SelectedVideosDuration.append(duration as! String)
                                                                        }
                                                                    }
                                                                    if let vidU = VidURL["VideoUrl"] {
                                                                        guard vidU != nil else {return}
                                                                        let url = URL(fileURLWithPath: vidU as! String)
                                                                        T.SelectedVideosUrls.append(url)
                                                                    }
                                                                    if let imgUrl = VidURL["VideoThumbnailUrl"] {
                                                                        if imgUrl != nil {
                                                                        T.SelectedVideosImagesUrlString.append(imgUrl as! String)
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            self.topic = T
                                                            self.TopicName.text = self.topic.Topic
                                                            self.NotesTableView.reloadData()
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
            }
        })
    }
    
    
}
