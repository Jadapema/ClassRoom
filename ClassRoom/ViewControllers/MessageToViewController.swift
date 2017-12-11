//
//  MessageToViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 9/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MessageToViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var ToTableView: UITableView!
    @IBOutlet var Back: UIImageView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var AllUsers : [User] = []
    var SelectedUser : User!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        FetchAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ToTableView.delegate = self
        ToTableView.dataSource = self
        Back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleBack)))
        Back.isUserInteractionEnabled = true
    }
    
    func HandleBack () {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AllUsers.first == nil {
            return 0
        }
        return AllUsers.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedUser = AllUsers[indexPath.row]
        performSegue(withIdentifier: "message", sender: self)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toUser", for: indexPath) as! MembersTableViewCell
        cell.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
        cell.NameLabel.text = AllUsers[indexPath.row].Name
        cell.EmailLabel.text = AllUsers[indexPath.row].Email
        cell.ProfileImageView.loadImageUsingCacheWithUrlString(AllUsers[indexPath.row].ProfileImageUrl)
        cell.ProfileImageView.layer.masksToBounds = false
        cell.ProfileImageView.layer.cornerRadius = cell.ProfileImageView.frame.height/2
        cell.ProfileImageView.clipsToBounds = true
        cell.ProfileImageView.contentMode = .scaleAspectFit
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "message" {
            let message = segue.destination as! MessageViewController
            message.SelectedUser = SelectedUser
        }
    }
    
    func FetchAll() {
        
        // Esperamos a que se haga un cambio en la base de datos
        FIRDatabase.database().reference().observe(.value, with: { snapshot in
            self.AllUsers.removeAll()
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
                                user.ProfileImageUrl = ProfileImageUrl
                                self.AllUsers.append(user)
                                //this will crash because of background thread, so lets use dispatch_async to fix
                                DispatchQueue.main.async(execute: {
                                    //Refrescamos los valores de nuestra tabla
                                    self.ToTableView.reloadData()
                                })
                            }
                        }
                    }
                    
                }
                
            }
            
        })
        
    }

}
