//
//  SubjectsViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 18/8/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SubjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    //Outlets
    @IBOutlet var SearchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    //Variables
    var Subjects : [Subject]  = []
    var SelectedSubject : Subject!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    var FilteredSubjects : [Subject] = []
    var IsSearching = false
    var mainRef : FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
                                                //BeforeView Functions
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        if self.view.isHidden == false {
//            self.view.isHidden = true
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
         FetchAll()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.isHidden = false
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        self.hidesBottomBarWhenPushed = false
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(HandleLogOut), with: nil, afterDelay: 0)
        }
        SearchBar.delegate = self
        SearchBar.returnKeyType = UIReturnKeyType.done
        
        
    }
                                                //DataSource and Delegate Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Verificamos si se esta buscando algo
        if IsSearching {
            //Creamos tantas filas como elementos buscados se encuentren
//            return FilteredSubjects.count
        }
        //Creamos tantas filas como elementos existan en la base de datos
       return Subjects.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Creamos una TableViewCell con el Identificador que  le dimos a nuestro modelo
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjects", for: indexPath) as! SubjectsTableViewCell
        cell.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        cell.BGView.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
        cell.BGView.layer.cornerRadius = 10
        cell.BGView.layer.borderWidth = 1
        cell.BGView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5961312072)
        cell.BGView.layer.masksToBounds = false
        cell.BGView.clipsToBounds = true
        //Verificamos si se esta buscando y dependiendo de eso asignamos los datos
        if IsSearching {
            //Asignamos cada valor a los textos de nuestras celdas
//            cell.textLabel?.text = FilteredSubjects[indexPath.row].Name
//            cell.detailTextLabel?.text = FilteredSubjects[indexPath.row].Description
        } else {
            //Asignamos cada valor a los textos de nuestras celdas

            cell.SubjectName.text = Subjects[indexPath.row].Name
            cell.UniversityName.text = Subjects[indexPath.row].University.Name
            cell.Year.text = "\(Subjects[indexPath.row].Year!)"
            cell.GroupCount.text = "Grupos: \(Subjects[indexPath.row].Groups.count)"
            cell.UniversityLogo.loadImageUsingCacheWithUrlString(Subjects[indexPath.row].University.LogoUrl)
            cell.UniversityLogo.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.UniversityLogo.layer.masksToBounds = false
            cell.UniversityLogo.layer.borderWidth = 0.5
            cell.UniversityLogo.layer.borderColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.80078125)
            cell.UniversityLogo.layer.cornerRadius = 2
            cell.UniversityLogo.clipsToBounds = true
            cell.UniversityLogo.contentMode = .scaleAspectFit
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("Selected \(indexPath.row)")
        SelectedSubject = Subjects[indexPath.row]
        return indexPath
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected \(indexPath.row)")
        SelectedSubject = Subjects[indexPath.row]
        performSegue(withIdentifier: "SubjectDetail", sender: self)
    }
    // Funcion que se activa cuando el texto de la searchBar cambia
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Chequeamos si el texto no es nulo ni vacio
        if searchBar.text == nil || searchBar.text == "" {
            //Indicamos que no se esta buscando
            IsSearching = false
            //Removemos las materias buscadas anteriormente
            FilteredSubjects.removeAll()
            view.endEditing(true)
            //Refrescamos la tabla
            tableView.reloadData()
        } else {
            // Indicamos que se esta buscando algo
            IsSearching = true
            //Recorremos nuestras materias
            for s in Subjects {
                //Si el nombre de la materia coincide con el que ingresaron
                if s.Name == searchBar.text{
                    //Se agrega al arreglo filtrado
                    FilteredSubjects.append(s)
                    print("\(s.Name) Anadido")
                    //Recargamos la tabla
                    tableView.reloadData()
                }
            }
            print(FilteredSubjects.count)
            tableView.reloadData()
        }
    }

                                                //Functions
    func FetchAll() {
        
        self.mainRef.observe(.value, with: { snapshot in

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
                                    if let GroupName = V["GroupName"], let Teacher = V["Teacher"] as? Dictionary<String,AnyObject> {
                                        
                                        let Gr = Group()
                                        Gr.GroupName = GroupName as! String
                                        Gr.GrId = K
                                        if let T = Teacher["Name"] {
                                            Gr.Teacher = T as! String
                                        }
                                        if let Topics = V["Classes"] as? Dictionary<String,AnyObject> {
                                            for (Id,Va) in Topics {
                                                if let TopicName = Va["Topic"], let Images = Va["Images"] as? Dictionary<String,AnyObject>, let Notes = Va["Notes"] as? Dictionary<String,AnyObject> {
                                                    print("Entro topic")
                                                    let T = Topic()
                                                    T.Topic = TopicName as! String
                                                    T.TopicId = Id
                                                    for (_,imgURL) in Images {
                                                        let url = URL(fileURLWithPath: imgURL as! String)
                                                        T.ImagesUrl.append(url)
                                                    }
                                                    for (_,nota) in Notes {
                                                        T.NotesA.append(nota as! String)
                                                        print("Entro nota")
                                                    }
                                                    if let Videos = Va["Videos"] as? Dictionary<String,AnyObject> {
                                                        print("Entro video")
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
                                                    print("Add topic")
                                                    Gr.Topics.append(T)
                                                }
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
                                //this will crash because of background thread, so lets use dispatch_async to fix
                                DispatchQueue.main.async(execute: {
                                    //Refrescamos los valores de nuestra tabla
                                    self.tableView.reloadData()
                                    
                                })
                            }
                        }
                    }
                }
            
            }
        })
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let SubjectDetail = segue.destination as? SubjectDetailViewController {
            SubjectDetail.Subjects = SelectedSubject
        }
    }
    
    
}

                                                    //Data Models

class Subject: NSObject {
    var SubId : String!
    var Name: String!
    var Description: String!
    var University : University!
    var Year : Int!
    var Groups : [Group] = []
}

class Group: NSObject {
    var GrId : String!
    var GroupName : String!
    var Members : [User] = []
    var Teacher : String!
    var Topics : [Topic] = []
}
