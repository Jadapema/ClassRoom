//
//  ProfileViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 18/8/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var LogOut: UIImageView!
    @IBOutlet var ProfileImage: UIImageView!
    @IBOutlet var ChatView: UIView!
    @IBOutlet var MySubjectsView: UIView!
    @IBOutlet var MySubjectsTableView: UITableView!
    @IBOutlet var UserName: UILabel!
    @IBOutlet var Segmented: UISegmentedControl!
    @IBOutlet var AddChat: UIImageView!
    @IBOutlet var ChatTableView: UITableView!
    
    var Members : [User] = []
    var Messages : [Message] = []
    var MessagesDictionary = [String:Message]()
    var CurrentUser : User!
    var sendMenssageTo : User!
    
    var Subjects : [Subject] = []
    var MySubjects : [Subject] = []
    var MyGroups : [Group] = []
    
    var selectedSubject : Subject!
    var selectedGroup : Group!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        FetchAll()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        LogOut.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleLogOut)))
        LogOut.isUserInteractionEnabled = true
        AddChat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleAddChat)))
        AddChat.isUserInteractionEnabled = true
        ChatView.isHidden = true
        ChatTableView.delegate = self
        ChatTableView.dataSource = self
        MySubjectsTableView.delegate = self
        MySubjectsTableView.dataSource = self
        ChatTableView.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        MySubjectsTableView.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        FetchAll()

        
    }
    
    func HandleProfileImage () {
        ProfileImage.loadImageUsingCacheWithUrlString(CurrentUser.ProfileImageUrl)
        ProfileImage.layer.masksToBounds = false
        ProfileImage.layer.borderWidth = 1
        ProfileImage.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ProfileImage.layer.cornerRadius = ProfileImage.frame.height/2
        ProfileImage.clipsToBounds = true
        ProfileImage.contentMode = .scaleAspectFit
        UserName.text = CurrentUser.Name
    }
    
    func HandleAddChat () {
        performSegue(withIdentifier: "PickUser", sender: self)
    }
    

    
    @IBAction func Segmented(_ sender: UISegmentedControl) {
        switch Segmented.selectedSegmentIndex {
        case 0:
            MySubjectsView.isHidden = false
            ChatView.isHidden = true
        case 1:
            MySubjectsView.isHidden = true
            ChatView.isHidden = false
        default:
            break;
        }
    }
    
    //Handle to Logout
    func HandleLogOut () {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let LogoutError {
            print("Error al salir de la sesion \(LogoutError)")
        }

        if let LogIn = self.storyboard?.instantiateViewController(withIdentifier: "LogIn")  {
        present(LogIn, animated: true) {
            print("Exito")
        }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ChatTableView {
            return Messages.count
        } else {
            return MySubjects.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ChatTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chats", for: indexPath) as! MessageGroupTableViewCell
            if let seconds = Messages[indexPath.row].Timestamp {
                let timestamDate = NSDate(timeIntervalSince1970: Double(seconds))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                cell.Timestamp.text = dateFormatter.string(from: timestamDate as Date)
            }
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
            cell.BG.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
            cell.BG.layer.cornerRadius = 10
            cell.BG.layer.borderWidth = 1
            cell.BG.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5961312072)
            cell.BG.layer.masksToBounds = false
            cell.BG.clipsToBounds = true
            cell.Message.text = Messages[indexPath.row].Message
            
            //        let chatPartnerId : String?
            //        if Messages[indexPath.row].FromId == FIRAuth.auth()?.currentUser?.uid {
            //            chatPartnerId = Messages[indexPath.row].ToId
            //        } else {
            //            chatPartnerId = Messages[indexPath.row].FromId
            //        }
            
            for u in Members {
                if u.UserId == Messages[indexPath.row].chatPartnerId() {
                    cell.UserName.text = u.Name
                    cell.UserImage.loadImageUsingCacheWithUrlString(u.ProfileImageUrl)
                    cell.UserImage.layer.masksToBounds = false
                    cell.UserImage.layer.cornerRadius = cell.UserImage.frame.height/2
                    cell.UserImage.clipsToBounds = true
                    cell.UserImage.contentMode = .scaleAspectFit
                }
            }
            return cell
        } else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mySubjects", for: indexPath) as! SubjectsTableViewCell

//                cell.textLabel?.text = "\(MySubjects[indexPath.row].Name!) - \(MyGroups[indexPath.row].GroupName!)"
            
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
            cell.BGView.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
            cell.BGView.layer.cornerRadius = 10
            cell.BGView.layer.borderWidth = 1
            cell.BGView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5961312072)
            cell.BGView.layer.masksToBounds = false
            cell.BGView.clipsToBounds = true
            cell.SubjectName.text = MySubjects[indexPath.row].Name
            cell.UniversityName.text = MySubjects[indexPath.row].University.Name
            cell.Year.text = "\(MySubjects[indexPath.row].Year!)"
            cell.GroupCount.text = "\(MyGroups[indexPath.row].GroupName!)"
            cell.UniversityLogo.loadImageUsingCacheWithUrlString(MySubjects[indexPath.row].University.LogoUrl)
            cell.UniversityLogo.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.UniversityLogo.layer.masksToBounds = false
            cell.UniversityLogo.layer.borderWidth = 0.5
            cell.UniversityLogo.layer.borderColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.80078125)
            cell.UniversityLogo.layer.cornerRadius = 2
            cell.UniversityLogo.clipsToBounds = true
            cell.UniversityLogo.contentMode = .scaleAspectFit
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == MySubjectsTableView {
            selectedSubject = MySubjects[indexPath.row]
            selectedGroup = MyGroups[indexPath.row]
            
            performSegue(withIdentifier: "profilesubjectdetail", sender: self)
        } else {
        let messag = Messages[indexPath.row]
        guard let chatPartnerId = messag.chatPartnerId() else {return}
        
        for u in Members {
            if u.UserId == chatPartnerId {
                sendMenssageTo = u
            }
        }
        
        performSegue(withIdentifier: "messageDetail", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messageDetail" {
            let dest = segue.destination as! MessageViewController
            
            dest.SelectedUser = sendMenssageTo
        } else if segue.identifier == "profilesubjectdetail" {
            let subDetail = segue.destination as! SubjectDetailViewController
            subDetail.Subjects = selectedSubject
            subDetail.selectedGroup = selectedGroup
        }
    }
    
    func checkSubjec () {
        print("checking...")
       MySubjects.removeAll()
        MyGroups.removeAll()
        for sub in Subjects {
            for Gr in sub.Groups {
                for M in Gr.Members {
                    if M.UserId == FIRAuth.auth()?.currentUser?.uid {
                        MySubjects.append(sub)
                        MyGroups.append(Gr)
                        print(M.UserId)
                        print((FIRAuth.auth()?.currentUser?.uid)!)
                        print("subject \(sub.Name!), group \(Gr.GroupName!)")
                    }
                }
            }
        }
        print(MySubjects.count)
        //this will crash because of background thread, so lets use dispatch_async to fix
        DispatchQueue.main.async(execute: {
            //Refrescamos los valores de nuestra tabla
            self.MySubjectsTableView.reloadData()
            
        })
        
    }
    
    
//
    func FetchAll() {
        
        
        // Fetch Users
        
        // Esperamos a que se haga un cambio en la base de datos
        FIRDatabase.database().reference().observe(.value, with: { snapshot in
            self.Members.removeAll()
            //Creamos un diccionario con la base de datos completa
            if let dictionary = snapshot.value as? [String:AnyObject] {
                //Creamos un diccionario con la seccion de los Usuarios
                if let Users = dictionary["Users"] as? Dictionary<String,AnyObject> {
                    //Recorremos la seccion de usuarios con un ciclo para obtener el valor de cada uno
                    for (Key,value) in Users {
                        let UId = Key
                        if let Profile = value["Profile"] as? Dictionary<String,String> {
                            if let Name = Profile["Name"], let ProfileImageUrl = Profile["ProfileImageUrl"], let Email = Profile["Email"] {
                                let user : User = User()
                                user.Name = Name
                                user.Email = Email
                                user.UserId = UId
                                user.isSelected = false
                                user.ProfileImageUrl = ProfileImageUrl
                                if user.UserId == FIRAuth.auth()?.currentUser?.uid {
                                    self.CurrentUser = user
                                }
                                self.Members.append(user)
                                
                                //this will crash because of background thread, so lets use dispatch_async to fix
                                DispatchQueue.main.async(execute: {
                                    //Refrescamos los valores de nuestra tabla
//                                    self.TableView.reloadData()
                                })
                            }
                        }
                    }
                    self.HandleProfileImage()
                }
                
            }
            
        })
        
        // Fetch Subjects
        
        
        FIRDatabase.database().reference().observe(.value, with: { snapshot in
            
            self.Subjects.removeAll()
            //Creamos un diccionario con la base de datos completa
            if let dictionary = snapshot.value as? [String:AnyObject] {
                //Creamos un diccionario con la seccion de las asignaturas
                if let subject = dictionary["Subjects"] as? Dictionary<String,AnyObject> {
                    //Recorremos la seccion de asignaturas con un ciclo para obtener el valor de cada una
                    for (Key,value) in subject {
                        //Almacenamos todos los valores de cada Asignatura en un diccionario nuevo
                        if let sub = value as? Dictionary<String,AnyObject> {
                            //Chequeamos que existan SubjectName y Description y los almacenamos en sus respectivas variables
                            if let name = sub["SubjectName"] ,
                                let description = sub["Description"], let Year = sub["Year"], let U = sub["University"], let G = sub["Groups"] as? Dictionary<String,AnyObject> {
                                //Creamos y asignamos cada valor a la variable s que creamos de tipo SubjectsFirst
                                let s = Subject()
                                s.SubId = Key
                                s.Name = name as! String
                                s.Description = description as! String
                                s.Year = Year as! Int
                                
                                for (K,V) in G {
                                    if let GroupName = V["GroupName"], let Members = V["Members"] as? Dictionary<String,AnyObject>, let Teacher = V["Teacher"] as? Dictionary<String,AnyObject> {
                                        
                                        let Gr = Group()
                                        Gr.GroupName = GroupName as! String
                                        Gr.GrId = K
                                        if let T = Teacher["Name"] {
                                            Gr.Teacher = T as! String
                                        }
                                        if let Topics = V["Classes"] as? Dictionary<String,AnyObject> {
                                            for (Id,Va) in Topics {
                                                if let TopicName = Va["Topic"], let Images = Va["Images"] as? Dictionary<String,AnyObject>, let Notes = Va["Notes"] as? Dictionary<String,AnyObject>, let Videos = Va["Videos"] as? Dictionary<String,AnyObject> {
                                                    let T = Topic()
                                                    T.Topic = TopicName as! String
                                                    T.TopicId = Id
                                                    for (_,imgURL) in Images {
                                                        let url = URL(fileURLWithPath: imgURL as! String)
                                                        T.ImagesUrl.append(url)
                                                    }
                                                    for (_,nota) in Notes {
                                                        T.NotesA.append(nota as! String)
                                                    }
                                                    for (_,VidURL) in Videos {
                                                        if let duration = VidURL["VideoDuration"] {
                                                            if duration != nil {
                                                        
                                                            T.SelectedVideosDuration.append(duration as! String)
                                                            }
                                                        }
                                                        if let vidU = VidURL["VideoUrl"] {
                                                            if vidU != nil {
                                                                let url = URL(fileURLWithPath: vidU as! String)
                                                                T.SelectedVideosUrls.append(url)
                                                            }
                                                        }
                                                        if let imgUrl = VidURL["VideoThumbnailUrl"] {
                                                            if imgUrl != nil {
                                                                T.SelectedVideosImagesUrlString.append(imgUrl as! String)
                                                            }
                                                        }
                                                    }
                                                    Gr.Topics.append(T)
                                                }
                                            }
                                        }
                                        for (MemberId, _) in Members {
                                            if let Users = dictionary["Users"] as? Dictionary<String,AnyObject> {
                                                for (UserId,Val) in Users {
                                                    if UserId == MemberId {
                                                        if let Profile = Val["Profile"] as? Dictionary<String,AnyObject> {
                                                            if let Name = Profile["Name"], let Email = Profile["Email"], let ProfileImageUrl = Profile["ProfileImageUrl"] {
                                                                let us = User()
                                                                us.Name = Name as! String
                                                                us.Email = Email as! String
                                                                us.UserId = MemberId
                                                                us.ProfileImageUrl = ProfileImageUrl as! String
                                                                Gr.Members.append(us)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        s.Groups.append(Gr)
                                    }
                                }
                                if let Universities = dictionary["Universities"] as? Dictionary<String,AnyObject> {
                                    for (key,value) in Universities {
                                        if key == U as! String {
                                            if let Uni = value as? Dictionary<String,AnyObject> {
                                                if let Location = Uni["Location"] as? Dictionary<String,AnyObject>, let Logo = Uni["Logo"], let Motto = Uni["Motto"], let Name = Uni["Name"] {
                                                    let u = University()
                                                    u.LogoUrl = Logo as! String
                                                    u.Motto = Motto as! String
                                                    u.Name = Name as! String
                                                    u.Uid = key
                                                    if let latitude = Location["Latitude"], let Longitude = Location["Longitude"] {
                                                        u.Latitude = "\(latitude as! String)"
                                                        u.Longitude = "\(Longitude as! String)"
                                                        s.University = u
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                
                                
                                
                                
                                //Añadimos nuestro SujectsFirst al arreglo que creamos al principio
                                self.Subjects.append(s)
                                
                                self.checkSubjec()
                                
                                
                            }
                        }
                    }
                }
                
            }
            //self.checkSubjec()
        })
        
        
        
        // Fetch Messages
        
        let Re = FIRDatabase.database().reference().child("User-Messages").child((FIRAuth.auth()?.currentUser?.uid)!)
        Re.observe(.value, with: { snapshot in
            self.MessagesDictionary.removeAll()
          //print("primera entrada")
            if let snapshotValue = snapshot.value as? [String:AnyObject] {
               // print(snapshot)
                for (k,_) in snapshotValue {
                    let messageReference = FIRDatabase.database().reference().child("Messages").child(k)
                    messageReference.observe(.value, with: { snapshot in
                        self.Messages.removeAll()
                      //  self.MessagesDictionary.removeAll()
                       // print("segunda entrada")
                        if let dictionary = snapshot.value as? [String:AnyObject] {
                            
                          //  for (_,v) in dictionary {
                                let message = Message()
                                if let From = dictionary["FromId"] as? String {
                                    message.FromId = From
                                }
                                if let To = dictionary["ToId"] as? String {
                                    message.ToId = To
                                }
                                if let Me = dictionary["Message"] as? String {
                                    message.Message = Me
                                }
                                if let Tim = dictionary["Timestamp"] as? Int {
                                    message.Timestamp = Tim
                                }
                                //                    self.Messages.append(message)
                            
                            
                                // Set in groups the messages
                                if let toId = message.ToId, let _ = message.Timestamp {
                                    self.MessagesDictionary[toId] = message
                                    self.Messages = Array(self.MessagesDictionary.values)
                              //      print("tercera entrada")
                               //     print("antes algo")
                                    self.Messages.sort(by: { (Message1, Message2) -> Bool in
                                        // if Message1.Timestamp != nil && Message2.Timestamp != nil {
                                       // print("Algo")
                                        return Message1.Timestamp > Message2.Timestamp
                                        
                                        // }
                                        // return false
                                    })
                                }
                            
                                DispatchQueue.main.async(execute: {
                                    //Refrescamos los valores de nuestra tabla
                                    self.ChatTableView.reloadData()
                                })
                            //}
                        }
                    })
                }
            }
            
        })
//        FIRDatabase.database().reference().child("Messages").observe(.value, with: { snapshot in
//            self.Messages.removeAll()
//            if let dictionary = snapshot.value as? [String:AnyObject] {
//                for (_,v) in dictionary {
//                    let message = Message()
//                    if let From = v["FromId"] as? String {
//                        message.FromId = From
//                    }
//                    if let To = v["ToId"] as? String {
//                        message.ToId = To
//                    }
//                    if let Me = v["Message"] as? String {
//                    message.Message = Me
//                    }
//                    if let Tim = v["Timestamp"] as? Int {
//                    message.Timestamp = Tim
//                    }
////                    self.Messages.append(message)
//
//
//                    // Set in groups the messages
//                    if let toId = message.ToId, let _ = message.Timestamp {
//                        self.MessagesDictionary[toId] = message
//                        self.Messages = Array(self.MessagesDictionary.values)
//                        print("antes algo")
//                        self.Messages.sort(by: { (Message1, Message2) -> Bool in
//                           // if Message1.Timestamp != nil && Message2.Timestamp != nil {
//                            print("Algo")
//                            return Message1.Timestamp > Message2.Timestamp
//
//                           // }
//                           // return false
//                        })
//                    }
//
//                    DispatchQueue.main.async(execute: {
//                        //Refrescamos los valores de nuestra tabla
//                        self.ChatTableView.reloadData()
//                    })
//                }
//            }
//        })
        
    }
}

class Message : NSObject {
    var FromId : String!
    var ToId : String!
    var Message : String!
    var Timestamp : Int!
    
    func chatPartnerId() -> String? {
        if FromId == FIRAuth.auth()?.currentUser?.uid {
            return ToId
        } else {
            return FromId
        }
    }
}
