//
//  ComentsViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 7/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ComentsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var Cancel: UIImageView!
    @IBOutlet var TopicName: UILabel!
    @IBOutlet var BG: UIView!
    @IBOutlet var QuestionTableView: UITableView!
    @IBOutlet var Add: UIImageView!
    @IBOutlet var BottonBG: UIView!
    @IBOutlet var Subject: UILabel!
    @IBOutlet var Group: UILabel!
    @IBOutlet var top: UILabel!
    
    var SelectedSubjectId = UserDefaults.standard.object(forKey: "SelectedSubjectId") as! String
    var SelectedGropId = UserDefaults.standard.object(forKey: "SelectedGroupId") as! String
    var SelectedTopic = UserDefaults.standard.object(forKey: "SelectedTopicId") as! String
    var topic : Topic!
    var selectedQuestion : Pregunta!
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchAll()
        
        QuestionTableView.delegate = self
        QuestionTableView.dataSource = self
        
        Add.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleAddQuestion)))
        Add.isUserInteractionEnabled = true
        Cancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleCancel)))
        Cancel.isUserInteractionEnabled = true
        
        BG.layer.masksToBounds = false
        BG.layer.cornerRadius = 5
        BG.layer.borderWidth = 2
        BG.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7018675086)
        BG.clipsToBounds = true
        BG.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        
        BottonBG.layer.masksToBounds = false
        BottonBG.layer.cornerRadius = 5
        BottonBG.layer.borderWidth = 2
        BottonBG.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7018675086)
        BottonBG.clipsToBounds = true
        QuestionTableView.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if topic != nil {
            return topic.Questions.count
        } else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "P") as! PRTableViewCell
        cell.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        cell.BG.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
        cell.BG.layer.cornerRadius = 10
        cell.BG.layer.borderWidth = 1
        cell.BG.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5961312072)
        cell.BG.layer.masksToBounds = false
        cell.BG.clipsToBounds = true
        
        cell.Pregunta.text = topic.Questions[indexPath.row].QuestionName
        cell.RespuestasCount.text = "Respuestas: \(topic.Questions[indexPath.row].Respuestas.count)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedQuestion = topic.Questions[indexPath.row]
        performSegue(withIdentifier: "PRS", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PRS" {
            let PR = segue.destination as! PRViewController
            PR.Q = selectedQuestion
        }
    }
    
    func HandleAddQuestion () {

        performSegue(withIdentifier: "PRSA", sender: self)
        
    }

    func HandleCancel () {
        dismiss(animated: true, completion: nil)
    }
    
    func FetchAll () {
//        print("Fecth")
        FIRDatabase.database().reference(fromURL: "https://classroom-19991.firebaseio.com/").observe(.value, with: { snapshot in
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
//                                                print("Entro Grupo \(self.SelectedGropId)")
                                                if let Topics = V["Classes"] as? Dictionary<String,AnyObject> {
                                                    for (Id,Va) in Topics {
                                                        if Id == self.SelectedTopic {
                                                            if let TN = Va["Topic"] as? String {
                                                                self.top.text = TN
                                                            }
//                                                            print("Entro topic \(self.SelectedTopic)")
                                                            if let TopicName = Va["Topic"]   {
//                                                                print("Entro entro")
                                                                let T = Topic()
                                                                T.Topic = TopicName as! String
                                                                T.TopicId = Id
                                                                if let Images = Va["Images"] as? Dictionary<String,AnyObject> {
//                                                                    print("Entro Images")
                                                                    for (_,imgURL) in Images {
                                                                        // let url = URL(fileURLWithPath: imgURL as! String)
                                                                        T.ImagesUrlString.append(imgURL as! String)
                                                                    }
                                                                }
                                                                if let Notes = Va["Notes"] as? Dictionary<String,AnyObject> {
//                                                                    print("Entro Notes")
                                                                    for (_,nota) in Notes {
                                                                        T.NotesA.append(nota as! String)
                                                                    }
                                                                }
                                                                if let Questions = Va["Questions"] as? Dictionary<String,AnyObject> {
//                                                                    print("Entro Questions")
                                                                    for (ID,Q) in Questions {
                                                                        let Ques = Pregunta()
                                                                        Ques.QuestionID = ID
                                                                        if let Name = Q["QuestionName"] as? String {
//                                                                            print("Entro QuestionsName")
                                                                            Ques.QuestionName = Name
                                                                        }
                                                                        if let res = Q["Responses"] as? Dictionary<String,AnyObject> {
                                                                            for (_,r) in res {
                                                                                Ques.Respuestas.append(r as! String)
                                                                            }
                                                                        }
                                                                        T.Questions.append(Ques)
                                                                    }
                                                                }
                                                                if let Videos = Va["Videos"] as? Dictionary<String,AnyObject> {
//                                                                    print("Entro Videos")
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
                                                                self.QuestionTableView.reloadData()
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
