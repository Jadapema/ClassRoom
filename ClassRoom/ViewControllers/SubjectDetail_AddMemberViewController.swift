//
//  SubjectDetail_AddMemberViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 4/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SubjectDetail_AddMemberViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var BGCenterView: UIView!
    @IBOutlet var MembersTableView: UITableView!
    @IBOutlet var SearchBar: UISearchBar!
    @IBOutlet var AddMemberButton: UIButton!
    
    
    var Subject: Subject!
    var SelectedGroup : Group!
    var Members : [User] = []
    var SelectedMembers : [User] = []
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //BeforeView Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchBar.delegate = self
        MembersTableView.delegate = self
        MembersTableView.dataSource = self
        FetchAll()
        
        BGCenterView.layer.masksToBounds = false
        BGCenterView.layer.cornerRadius = 5
        BGCenterView.layer.borderColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
        BGCenterView.layer.borderWidth = 1
        BGCenterView.clipsToBounds = true
        
        MembersTableView.layer.masksToBounds = false
        MembersTableView.layer.cornerRadius = 5
        MembersTableView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        MembersTableView.layer.borderWidth = 1
        MembersTableView.clipsToBounds = true
        MembersTableView.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        
        AddMemberButton.layer.masksToBounds = false
        AddMemberButton.layer.cornerRadius = 5
        AddMemberButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        AddMemberButton.layer.borderWidth = 1
        AddMemberButton.clipsToBounds = true
        
        
    }

    @IBAction func BGButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func AñadirMiembro(_ sender: UIButton) {
        
        //Go over members and add to SelectedMembers array if is selected
        for member in Members {
            if member.isSelected! {
                SelectedMembers.append(member)
            }
        }
        
        let NewMember =  FIRDatabase.database().reference().child("Subjects").child(Subject.SubId!).child("Groups").child(SelectedGroup.GrId!).child("Members")
        for member in SelectedMembers {
            NewMember.child(member.UserId!).setValue(true)
        }
        
        print(Subject.Name)
        print(SelectedGroup.GroupName)
        
        
            let notification = NSNotification.Name("SubjectDetailFetchAll02")
            NotificationCenter.default.post(name: notification, object: nil)

        
        dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Members.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MembersTableView.dequeueReusableCell(withIdentifier: "members", for: indexPath) as! MembersTableViewCell
        cell.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
        cell.NameLabel.text = Members[indexPath.row].Name
        cell.EmailLabel.text = Members[indexPath.row].Email
        cell.BG.layer.masksToBounds = false
        cell.BG.layer.cornerRadius = 5
        cell.BG.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.BG.layer.borderWidth = 1
        cell.BG.clipsToBounds = true
        cell.ProfileImageView.loadImageUsingCacheWithUrlString(Members[indexPath.row].ProfileImageUrl)
        cell.ProfileImageView.layer.masksToBounds = false
        cell.ProfileImageView.layer.cornerRadius = cell.ProfileImageView.frame.height/2
        cell.ProfileImageView.clipsToBounds = true
        cell.ProfileImageView.contentMode = .scaleAspectFit
        if let img = cell.ProfileImageView.image {
            Members[indexPath.row].ProfileImage = img
        }
        if Members[indexPath.row].isSelected == true {
            cell.CheckImageView.image = #imageLiteral(resourceName: "CheckMark")
        } else {
            cell.CheckImageView.image = nil
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = MembersTableView.cellForRow(at: indexPath) as! MembersTableViewCell
        cell.contentView.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
        if Members[indexPath.row].isSelected! {
            Members[indexPath.row].isSelected = false
            cell.CheckImageView.image = nil
        } else {
            Members[indexPath.row].isSelected = true
            cell.CheckImageView.image = #imageLiteral(resourceName: "CheckMark")
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Search
    }
    
    func FetchAll() {
        
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
                                self.Members.append(user)
                                //this will crash because of background thread, so lets use dispatch_async to fix
                                DispatchQueue.main.async(execute: {
                                    //Refrescamos los valores de nuestra tabla
                                    self.MembersTableView.reloadData()
                                })
                            }
                        }
                    }
                    
                }
                
            }
            
        })
        
    }

}
