//
//  SubjectDetailViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 3/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SubjectDetailViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var CancelImageView: UIImageView!
    @IBOutlet var SubjectName: UILabel!
    @IBOutlet var GroupsCollectionView: UICollectionView!
    @IBOutlet var SubjectDescription: UILabel!
    @IBOutlet var AddGroupImageView: UIImageView!
    @IBOutlet var TISegmentedControl: UISegmentedControl!
    @IBOutlet var GroupName: UILabel!
    @IBOutlet var GroupBG: UIView!
    
    @IBOutlet var MembersView: UIView!
    @IBOutlet var AddMemberImageview: UIImageView!
    @IBOutlet var MembersTableView: UITableView!
    
    @IBOutlet var TopicsView: UIView!
    @IBOutlet var AddTopicImageView: UIImageView!
    @IBOutlet var TopicsTableView: UITableView!
    
    var IsMember = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    var Subjects : Subject!
    var selectedGroup : Group!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        if self.view.isHidden == false {
//            self.view.isHidden = true
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        FetchAll()
        print("viewwillapear")
        self.GroupsCollectionView.reloadData()
        self.TopicsTableView.reloadData()
        self.MembersTableView.reloadData()
      //  CheckIfIsMember()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.isHidden = false
        self.hidesBottomBarWhenPushed = false
        GroupsCollectionView.delegate = self
        GroupsCollectionView.dataSource = self
        MembersTableView.delegate = self
        MembersTableView.dataSource = self
        TopicsTableView.delegate = self
        TopicsTableView.dataSource = self
        CancelImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleCancel)))
        CancelImageView.isUserInteractionEnabled = true
        AddTopicImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleAddTopic)))
        AddTopicImageView.isUserInteractionEnabled = true
        AddMemberImageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleAddMember)))
        AddMemberImageview.isUserInteractionEnabled = true
        AddGroupImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleAddGroup)))
        AddGroupImageView.isUserInteractionEnabled = true
        SubjectName.text = Subjects.Name
        SubjectDescription.text = Subjects.Description
        GroupsCollectionView.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
        GroupBG.layer.masksToBounds = false
        GroupBG.layer.borderWidth = 1
        GroupBG.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5961312072)
        GroupBG.layer.cornerRadius = 5
        GroupBG.clipsToBounds = true
        if selectedGroup == nil {
        selectedGroup = Subjects.Groups[0]
        GroupName.text = selectedGroup.GroupName
        } else {
        GroupName.text = selectedGroup.GroupName
        }
        TopicsView.isHidden = false
        MembersView.isHidden = true
        TopicsTableView.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        MembersTableView.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        
        
//        let notificationNme = NSNotification.Name("SubjectDetailFetchAll")
//        NotificationCenter.default.addObserver(self, selector: #selector(SubjectDetailViewController.reload), name: notificationNme, object: nil)
//        let notification = NSNotification.Name("SubjectDetailFetchAll02")
//        NotificationCenter.default.addObserver(self, selector: #selector(SubjectDetailViewController.reload), name: notification, object: nil)

        print("viewdidload")
        
    }
    
    
    
    @IBAction func ChangeIndex(_ sender: UISegmentedControl) {

        switch TISegmentedControl.selectedSegmentIndex {
        case 0:
            
            TopicsView.isHidden = false
            MembersView.isHidden = true
           
            
        case 1:
            
            TopicsView.isHidden = true
            MembersView.isHidden = false
           
            
        default:
            break;
        }
    }
    
    
    func HandleCancel () {
        performSegue(withIdentifier: "SubjectDetailMain", sender: self)
    }
    
    func HandleAddTopic () {
        performSegue(withIdentifier: "SubjectDetail_AddTopic", sender: self)
    }
    func HandleAddMember () {
        performSegue(withIdentifier: "SubjectDetail_AddMember", sender: self)
    }
    func HandleAddGroup () {
        performSegue(withIdentifier: "SubjectDetail_AddGroup", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Subjects.Groups.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = GroupsCollectionView.dequeueReusableCell(withReuseIdentifier: "Groups", for: indexPath) as! GroupsCollectionViewCell
        cell.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        cell.GroupsName.text = Subjects.Groups[indexPath.row].GroupName
        cell.GroupsName.layer.masksToBounds = false
        cell.GroupsName.layer.borderWidth = 1
        cell.GroupsName.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5961312072)
        cell.GroupsName.layer.cornerRadius = 5
        cell.GroupsName.clipsToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedGroup = Subjects.Groups[indexPath.row]
        GroupName.text = selectedGroup.GroupName
        TopicsTableView.reloadData()
        MembersTableView.reloadData()
        CheckIfIsMember()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == TopicsTableView {
            return selectedGroup.Topics.count
        } else {
            return selectedGroup.Members.count
        }
        

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == TopicsTableView {
            let cell = TopicsTableView.dequeueReusableCell(withIdentifier: "TopicDetailSubject") as! TopicsTableViewCell
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
            cell.BG.layer.masksToBounds = false
            cell.BG.layer.borderWidth = 1
            cell.BG.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5961312072)
            cell.BG.layer.cornerRadius = 5
            cell.BG.clipsToBounds = true
            cell.NameLabel.text = selectedGroup.Topics[indexPath.row].Topic
            cell.ImagesCountLabel.text = "Imagenes: \(selectedGroup.Topics[indexPath.row].ImagesUrl.count)"
            cell.VideoCountLabel.text = "Videos: \(selectedGroup.Topics[indexPath.row].SelectedVideosUrls.count)"
            return cell

        } else {
            let cell = MembersTableView.dequeueReusableCell(withIdentifier: "MembersDetailSubject") as! SelectedMembersTableViewCell
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
            cell.BG.layer.masksToBounds = false
            cell.BG.layer.borderWidth = 1
            cell.BG.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5961312072)
            cell.BG.layer.cornerRadius = 5
            cell.BG.clipsToBounds = true
            cell.ProfileImage.loadImageUsingCacheWithUrlString(selectedGroup.Members[indexPath.row].ProfileImageUrl)
            cell.ProfileImage.layer.masksToBounds = false
            cell.ProfileImage.layer.cornerRadius = cell.ProfileImage.frame.height/2
            cell.ProfileImage.clipsToBounds = true
            cell.ProfileImage.contentMode = .scaleAspectFit
            cell.NameLabel.text = selectedGroup.Members[indexPath.row].Name
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == TopicsTableView{
        UserDefaults.standard.set(Subjects.SubId!, forKey: "SelectedSubjectId")
        UserDefaults.standard.set(selectedGroup.GrId!, forKey: "SelectedGroupId")
        UserDefaults.standard.set(selectedGroup.Topics[indexPath.row].TopicId!, forKey: "SelectedTopicId")
        performSegue(withIdentifier: "PageVC", sender: self)
        }
    }
    
    func CheckIfIsMember () {
        self.IsMember = false
        
        for m in self.selectedGroup.Members {
            print("Member id: \(m.UserId!)")
            if m.UserId! == (FIRAuth.auth()?.currentUser?.uid)! {
                self.IsMember = true
            }
            
        }
        
        print((FIRAuth.auth()?.currentUser?.uid)!)
        print("Is Member? : \(IsMember)")
        if IsMember {
            print("is member")
            AddMemberImageview.isHidden = false
            AddTopicImageView.isHidden = false
        } else {
            print("no member")
            AddMemberImageview.isHidden = true
            AddTopicImageView.isHidden = true
        }
    }
    
    func FetchAll() {
        print("Fecth")
        // Esperamos a que se haga un cambio en la base de datos
        FIRDatabase.database().reference().observe(.value, with: { snapshot in
            self.Subjects.Groups.removeAll()
            print("Fecth entry")
            //Creamos un diccionario con la base de datos completa
            if let dictionary = snapshot.value as? [String:AnyObject] {
                print("Dict")
                //Creamos un diccionario con la seccion de las asignaturas
                if let subject = dictionary["Subjects"] as? Dictionary<String,AnyObject> {
                    //Recorremos la seccion de asignaturas con un ciclo para obtener el valor de cada una, obviando la llave
                    for (Key,value) in subject {
                        if Key == self.Subjects.SubId {
                            //Almacenamos todos los valores de cada Asignatura en un diccionario nuevo
                            if let sub = value as? Dictionary<String,AnyObject> {
                                //Chequeamos que existan SubjectName y Description y los almacenamos en sus respectivas variables
                                if let groups = sub["Groups"] as? Dictionary<String,AnyObject> {
                                    print("Entro Group")
                                    for (K,V) in groups {

                                        let Gr = Group()
                                        Gr.GrId = K
                                        if let Name = V["GroupName"] {
                                            Gr.GroupName = Name as! String
                                        }
                                        if let Teacher = V["Teacher"] as? Dictionary<String,AnyObject> {
                                            if let N = Teacher["Name"] {
                                                Gr.Teacher = N as! String
                                            }
                                        }
                                        if let Members = V["Members"] as? Dictionary<String,AnyObject> {
                                            for (MemberId, _) in Members {
                                                if let Users = dictionary["Users"] as? Dictionary<String,AnyObject> {
                                                    for (UserId,Val) in Users {
                                                        if UserId == MemberId {
                                                            if let Profile = Val["Profile"] as? Dictionary<String,AnyObject> {
                                                                if let Name = Profile["Name"], let Email = Profile["Email"], let ProfileImageUrl = Profile["ProfileImageUrl"] {
                                                                    let us = User()
                                                                    us.UserId = UserId
                                                                    us.Name = Name as! String
                                                                    us.Email = Email as! String
                                                                    us.ProfileImageUrl = ProfileImageUrl as! String
                                                                    Gr.Members.append(us)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        if let Topics = V["Classes"] as? Dictionary<String,AnyObject> {
                                            for (Id,Va) in Topics {
                                               
                                                if let TopicName = Va["Topic"]   {
                                                     print("Entro topic")
                                                    let T = Topic()
                                                    T.Topic = TopicName as! String
                                                    T.TopicId = Id
                                                    if let Images = Va["Images"] as? Dictionary<String,AnyObject> {
                                                        for (_,imgURL) in Images {
                                                            let url = URL(fileURLWithPath: imgURL as! String)
                                                            T.ImagesUrl.append(url)
                                                        }
                                                    }
                                                    if let Notes = Va["Notes"] as? Dictionary<String,AnyObject> {
                                                        for (_,nota) in Notes {
                                                            T.NotesA.append(nota as! String)
                                                        }
                                                    }
                                                    if let Videos = Va["Videos"] as? Dictionary<String,AnyObject> {
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
                                                    }
                                                    Gr.Topics.append(T)
                                                    self.TopicsTableView.reloadData()
                                                }
                                            }
                                        }
                                        
                                        if K == self.selectedGroup.GrId {
                                            self.selectedGroup = Gr
                                           self.CheckIfIsMember()
                                        }
                                        
                                        self.Subjects.Groups.append(Gr)

                                        
                                        self.GroupsCollectionView.reloadData()
                                        self.TopicsTableView.reloadData()
                                        self.MembersTableView.reloadData()
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let AddGroup =  segue.destination as? SubjectDetail_AddGroupViewController {
            AddGroup.SelectedSubject = Subjects
        } else if let AddTopic = segue.destination as? SubjectDetail_AddTopicViewController {
            AddTopic.Subject = Subjects
            AddTopic.SelectedGroup = selectedGroup
        } else if let AddMember = segue.destination as? SubjectDetail_AddMemberViewController {
            AddMember.Subject = Subjects
            AddMember.SelectedGroup = selectedGroup
        }
    }
    
    
    
    
    
    
    
}
