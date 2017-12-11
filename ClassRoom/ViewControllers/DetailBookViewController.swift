//
//  DetailBookViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 23/10/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DetailBookViewController: UIViewController {

    
    @IBOutlet var Back: UIImageView!
    @IBOutlet var Mybooks: UIImageView!
    @IBOutlet var MenuCategoryName: UILabel!
    @IBOutlet var Cover: UIImageView!
    @IBOutlet var Name: UILabel!
    @IBOutlet var Writer: UILabel!
    @IBOutlet var AddRemoveButton: UIButton!
    @IBOutlet var Description: UILabel!
    @IBOutlet var Idiom: UILabel!
    @IBOutlet var Category: UILabel!
    @IBOutlet var Date: UILabel!
    @IBOutlet var PagesCount: UILabel!
    
    
    var SelectedBook : Book!
    var CategoryName : String!
    var isMine : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BackHandle)))
        Back.isUserInteractionEnabled = true
        
        Mybooks.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MyBooksHandle)))
        Mybooks.isUserInteractionEnabled = true
        
        MenuCategoryName.text = CategoryName
        Category.text = CategoryName
        Cover.loadImageUsingCacheWithUrlString(SelectedBook.Cover)
        Name.text = SelectedBook.Name
        Writer.text = SelectedBook.Writer
        Description.text = SelectedBook.Description
        Idiom.text = SelectedBook.Idiom
        Date.text = SelectedBook.Date
        PagesCount.text = "\(SelectedBook.PagesCount!) Paginas"
        
        
        
        AddRemoveButton.isHidden = true
        
        CheckIfIsMine()
    }

    
    @IBAction func AddRemove(_ sender: UIButton) {
        
        if isMine == true {
            // Quitar libro
            FIRDatabase.database().reference().child("Users").child("\((FIRAuth.auth()?.currentUser?.uid)!)").child("Books").child("\((SelectedBook.BookId)!)").removeValue()
        } else {
            // Agregar libro
            FIRDatabase.database().reference().child("Users").child("\((FIRAuth.auth()?.currentUser?.uid)!)").child("Books").child("\((SelectedBook.BookId)!)").setValue(true)
        }
        
        CheckIfIsMine()
        
    }
    
    func CheckIfIsMine () {

//        print("Chequea")
        FIRDatabase.database().reference().observeSingleEvent(of: .value, with: { (snapshot) in

//        FIRDatabase.database().reference().observe(.value, with: { snapshot in
//            print("Reference")
            //Creamos un diccionario con la base de datos completa
            if let dictionary = snapshot.value as? [String:AnyObject] {
//                print("Diccionario")
                //Creamos un diccionario con la seccion de los Usuarios
                if let Users = dictionary["Users"] as? Dictionary<String,AnyObject> {
//                    print("Usuraios")
                    //Recorremos la seccion de usuarios con un ciclo para obtener el valor de cada uno
                    for (userId,value) in Users {
//                        print("Recorre Usuarios")
                        if userId == FIRAuth.auth()?.currentUser?.uid {
//                            print("Me encontro")
                            if let UserBooks = value["Books"] as? Dictionary<String, AnyObject> {
//                                print("Entra a los libros")
                                var helper : Bool = false
                                for (BookID, _) in UserBooks {
//                                    print("Recorre los libros")
                                    print(BookID)
                                    
                                    if BookID == self.SelectedBook.BookId {
                                        helper = true
//                                        print("Es mio")
                                    }
                                }
                                
                                self.SetButton(ButtonIsMine: helper)
                            }
                        }
                    }
                }
                
            }
            
        })
        
    }
    
    func SetButton(ButtonIsMine : Bool) {
        
        if ButtonIsMine == true {
            self.AddRemoveButton.setTitle("Remover", for: .normal)
            self.AddRemoveButton.layer.masksToBounds = false
            self.AddRemoveButton.layer.cornerRadius = 5
            self.AddRemoveButton.layer.borderWidth = 2
            self.AddRemoveButton.layer.borderColor = #colorLiteral(red: 0.8459790349, green: 0.2873021364, blue: 0.2579272389, alpha: 1)
            self.AddRemoveButton.clipsToBounds = true
            isMine = true
            
        } else {
            
            self.AddRemoveButton.setTitle("Obtener", for: .normal)
            self.AddRemoveButton.layer.masksToBounds = false
            self.AddRemoveButton.layer.cornerRadius = 5
            self.AddRemoveButton.layer.borderWidth = 2
            self.AddRemoveButton.layer.borderColor = #colorLiteral(red: 0, green: 0.6532471776, blue: 0.4756888151, alpha: 1)
            self.AddRemoveButton.clipsToBounds = true
            isMine = false
        }
        
        self.AddRemoveButton.isHidden = false
        
    }
    
    func BackHandle () {
        dismiss(animated: true, completion: nil)
    }
    
    func MyBooksHandle () {
        performSegue(withIdentifier: "Mybookss", sender: self)
    }

}
