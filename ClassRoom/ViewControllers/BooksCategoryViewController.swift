//
//  BooksCategoryViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 23/10/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class BooksCategoryViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var SectionName: UILabel!
    @IBOutlet var MyBooks: UIImageView!
    @IBOutlet var Back: UIImageView!
    @IBOutlet var BooksTableView: UITableView!
    
    var SectionN : String!
    var SectionNFB : String!
    var SectionBooks : [Book] = []
    var selectedBook : Book!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        FetchAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        BooksTableView.delegate = self
        BooksTableView.dataSource = self
        
        SectionName.text = SectionN
        
        Back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BackHandle)))
        Back.isUserInteractionEnabled = true
        
        MyBooks.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MyBooksHandle)))
        MyBooks.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
    }
    
    
    func FetchAll() {
        
        FIRDatabase.database().reference().observe(.value, with: { snapshot in
            self.SectionBooks.removeAll()
            //Creamos un diccionario con la base de datos completa
            if let dictionary = snapshot.value as? [String:AnyObject] {
                
                if let Categories = dictionary["BooksCategories"] as? Dictionary<String,AnyObject> {
                    
                    for (CatId, V) in Categories {
                        if CatId == self.SectionNFB {
                            if let BooksCategory = V["Books"] as? Dictionary<String,AnyObject> {
                                for (BID,_) in BooksCategory {
                                    if let Books = dictionary["Books"] as? Dictionary<String,AnyObject> {
                                        //Recorremos la seccion de usuarios con un ciclo para obtener el valor de cada uno
                                        for (bookId,value) in Books {
                                            if BID == bookId {
                                                if value is Dictionary<String,AnyObject> {
                                                    let book = Book()
                                                    book.BookId = bookId
                                                    if let bookURL = value["BookURL"] as? String {
                                                        book.URL = bookURL
                                                    }
                                                    if let Category = value["Category"] as? String {
                                                        book.Category = Category
                                                    }
                                                    if let Cover = value["Cover"] as? String {
                                                        book.Cover = Cover
                                                    }
                                                    if let Date = value["Date"] as? String {
                                                        book.Date = Date
                                                    }
                                                    if let Description = value["Description"] as? String {
                                                        book.Description = Description
                                                    }
                                                    if let Idiom = value["Idiom"] as? String {
                                                        book.Idiom = Idiom
                                                    }
                                                    if let Name = value["Name"] as? String {
                                                        book.Name = Name
                                                    }
                                                    if let PagesCount = value["PagesCount"] as? Int {
                                                        book.PagesCount = PagesCount
                                                    }
                                                    if let Writer = value["Writer"] as? String {
                                                        book.Writer = Writer
                                                    }
                            
                                                    self.SectionBooks.append(book)
                                                }
                                            }
                                        }
                                        
                                        DispatchQueue.main.async(execute: {
                                            self.BooksTableView.reloadData()
                                        })
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    func BackHandle () {
        dismiss(animated: true, completion: nil)
    }
    
    func MyBooksHandle () {
        performSegue(withIdentifier: "mybooks", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SectionBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BooksTableView.dequeueReusableCell(withIdentifier: "BooksCategory", for: indexPath) as! BooksCategoryTableViewCell
        cell.backgroundColor = #colorLiteral(red: 0, green: 0.1491528427, blue: 0.2637124495, alpha: 1)
        cell.Cover.loadImageUsingCacheWithUrlString(SectionBooks[indexPath.row].Cover)
        cell.Name.text = SectionBooks[indexPath.row].Name
        cell.Date.text = SectionBooks[indexPath.row].Date
        cell.Writer.text = SectionBooks[indexPath.row].Writer
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      selectedBook = SectionBooks[indexPath.row]
        performSegue(withIdentifier: "Detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            if let detail = segue.destination as? DetailBookViewController {
                detail.SelectedBook = selectedBook
                detail.CategoryName = SectionN
            }
        }
    }
    

}
