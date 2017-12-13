//
//  LibraryViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 18/8/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


import MobileCoreServices
import PDFKit

@available(iOS 11.0, *)
 
class LibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource /*,UINavigationControllerDelegate, UIDocumentMenuDelegate,UIDocumentPickerDelegate*/, PDFViewDelegate {
   
    

    let pdfView = PDFView()
    var MyBooks : [Book] = []
    var selectedBook : Book!
    @IBOutlet var ThumbnailCollectionView: UICollectionView!
    @IBOutlet var ThumbnailView: UIView!
    @IBOutlet var ThumbnailsReading: UIImageView!
    @IBOutlet var BackReading: UIImageView!
    @IBOutlet var BookNameReading: UILabel!
    @IBOutlet var MenuReading: UIView!
    @IBOutlet var LoadingView: UIView!
    @IBOutlet var Porcent: UILabel!
    @IBOutlet var BGView: UIView!
    @IBOutlet var UploadBook: UIImageView!
    @IBOutlet var Explore: UIImageView!
    @IBOutlet var myBooksCollectionV: UICollectionView!
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        FetchAll()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myBooksCollectionV.delegate = self
        myBooksCollectionV.dataSource = self

        Explore.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ExploreHandle)))
        Explore.isUserInteractionEnabled = true
        
        UploadBook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UploadBookHandle)))
        UploadBook.isUserInteractionEnabled = true
        
        BackReading.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BackReadingHandle)))
        BackReading.isUserInteractionEnabled = true
        
        ThumbnailsReading.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ThumbnailHandle)))
        ThumbnailsReading.isUserInteractionEnabled = true
        
        ThumbnailCollectionView.delegate = self
        ThumbnailCollectionView.dataSource = self
        
        pdfView.delegate = self
        
        LoadingView.isHidden = true
        
        BGView.layer.masksToBounds = false
        BGView.layer.cornerRadius = 5
        BGView.layer.borderWidth = 1
        BGView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8524989298)
        BGView.clipsToBounds = true
        
        MenuReading.isHidden = true
       // MenuReading.layer.zPosition = 1
        MenuReading.layer.masksToBounds = false
        MenuReading.layer.cornerRadius = 5
        MenuReading.layer.borderWidth = 1
        MenuReading.clipsToBounds = true
        MenuReading.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8524989298)
        
        
        ThumbnailView.layer.masksToBounds = false
        ThumbnailView.layer.cornerRadius = 5
        ThumbnailView.layer.borderWidth = 1
        ThumbnailView.clipsToBounds = true
        ThumbnailView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8524989298)
        
        ThumbnailView.isHidden = true
        // Do any additional setup after loading the view.
    }

//    @IBAction func Search(_ sender: UIButton) {
//
//        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
//        importMenu.delegate = self
//        importMenu.modalPresentationStyle = .overFullScreen
//        self.present(importMenu, animated: true, completion: nil)
//
//    }
    
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//        let cico = url as URL
//        print("The Url is : \(cico)")
//
////        pdfView.translatesAutoresizingMaskIntoConstraints = false
////        view.addSubview(pdfView)
////        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
////        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
////        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
////        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
////
////        if let document = PDFDocument(url: cico) {
////            pdfView.document = document
////            pdfView.goToFirstPage(nil)
////            pdfView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
////            pdfView.displayMode = .singlePageContinuous
////           // pdfView.displayDirection = .horizontal
////            pdfView.canGoBack()
////            pdfView.canGoForward()
////            pdfView.canGoToNextPage()
////            pdfView.canGoToPreviousPage()
////            pdfView.displaysAsBook = true
////           // pdfView.displayBox = .artBox
////        }
//
//    }
//
//    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
//        documentPicker.delegate = self
//        present(documentPicker, animated: true, completion: nil)
//    }
//
//    func documentMenuWasCancelled(_ documentMenu: UIDocumentMenuViewController) {
//        dismiss(animated: true, completion: nil)
//    }
    
    
    func FetchAll() {
        
        FIRDatabase.database().reference().observe(.value, with: { snapshot in
            self.MyBooks.removeAll()
            //Creamos un diccionario con la base de datos completa
            if let dictionary = snapshot.value as? [String:AnyObject] {
                //Creamos un diccionario con la seccion de los Usuarios
                if let users = dictionary["Users"] as? Dictionary<String,AnyObject> {
                    for (userid, value) in users {
                        if userid == FIRAuth.auth()?.currentUser?.uid {
                            if let mybooks = value["Books"] as? Dictionary<String,AnyObject> {
                                for (mybookid,_) in mybooks {
                                    if let Books = dictionary["Books"] as? Dictionary<String,AnyObject> {
                                        //Recorremos la seccion de usuarios con un ciclo para obtener el valor de cada uno
                                        for (bookId,value) in Books {
                                            if bookId == mybookid {
                                                if let val = value as? Dictionary<String,AnyObject> {
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
                                                    
                                                    self.MyBooks.append(book)
                                                }
                                            }
                                        }
                                        
                                        DispatchQueue.main.async(execute: {
                                            self.myBooksCollectionV.reloadData()
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
    
    
    func ExploreHandle () {
        
//        LoadBook(bookURL: "gs://classroom-19991.appspot.com/Books/Introduction_to_Character_Animation_19_Sept_2006.pdf")
        performSegue(withIdentifier: "Categories", sender: self)
    
    }
    
    func LoadBook(selectedBook : Book)  {
        LoadingView.isHidden = false
        print("Hola")
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
       // pdfView.layer.zPosition = -0.5
        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let dowloadtask =  FIRStorage.storage().reference(forURL: selectedBook.URL).data(withMaxSize: 60 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Hola")
                if let document = PDFDocument.init(data: data!) {
                    print("si! :D")
                    self.pdfView.document = document
                    self.pdfView.goToFirstPage(nil)
                    self.pdfView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                    self.pdfView.displayMode = .singlePageContinuous
                    self.pdfView.autoScales = true
                    // pdfView.displayDirection = .horizontal
                    let IV = UIImageView(frame: self.view.frame)
                    IV.image = UIImage(view: self.pdfView)
                    // self.pdfView.isHidden = true
                    // self.view.addSubview(IV)
                }
            }
        }
        let observer = dowloadtask.observe(.progress, handler: { snapshot in
            
            if snapshot.progress?.completedUnitCount != 0 {
                let porcent = 100 * Int(snapshot.progress!.completedUnitCount)/Int(snapshot.progress!.totalUnitCount)
                print(Int(porcent))
                self.Porcent.text = "\(porcent)%"
                if porcent == 100 {
                    self.pdfView.isHidden = false
                    self.LoadingView.isHidden = true
                    self.MenuReading.isHidden = false
                    self.view.bringSubview(toFront: self.MenuReading)
                    self.view.bringSubview(toFront: self.ThumbnailView)
                    self.BookNameReading.text = selectedBook.Name
//                    self.ThumbnailCollectionView.reloadData()
                }
            }
        })
    }
    
    func UploadBookHandle () {
        
        
        let dowloadtask =  FIRStorage.storage().reference(forURL: "gs://classroom-19991.appspot.com/Subjects/Videos/2wc6PkCFRj.mov").data(withMaxSize: 100 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Hola")
                
            }
        }
        
        
        
//        selectedVideoUrl = topic.SelectedVideosUrls[indexPath.row]
        //        if let url = selectedVideoUrl {
        //            print("URL: \(url)")
        //            URLSession.shared.dataTask(with: url, completionHandler: { (Data, UrlResponse, error) in
        //                if let error = error {
        //                    print(error)
        //                    return
        //                }
        //                if let string = NSString(data: Data!, encoding: String.Encoding.utf8.rawValue) {
        //                    let u = URL(fileURLWithPath: string as String)
        //                        self.avPlayer = AVPlayer(url: u)
        //                        self.avPlayerVC.player = self.avPlayer
        //
        //                }
        //            })
        //
        //
        //        }
        //        self.present(self.avPlayerVC, animated: true) {
        //            self.avPlayerVC.player?.play()
        //        }
        
    }
    
    func BackReadingHandle () {
        print("Back")
        MenuReading.isHidden = true
        pdfView.isHidden = true
        ThumbnailView.isHidden = true
        
    }
    
    func ThumbnailHandle () {
        
        self.ThumbnailCollectionView.reloadData()
        
        if ThumbnailView.isHidden == true {
            // si esta oculto
            ThumbnailView.isHidden = false
        } else {
            // si no esta oculto
            ThumbnailView.isHidden = true
        }
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == myBooksCollectionV {
        return MyBooks.count
        } else {
            if selectedBook != nil {
            return selectedBook.PagesCount
            } else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == myBooksCollectionV {
        let cell = myBooksCollectionV.dequeueReusableCell(withReuseIdentifier: "mybooks", for: indexPath) as! BooksCollectionViewCell
        cell.backgroundColor = UIColor.blue
        cell.Cover.loadImageUsingCacheWithUrlString(MyBooks[indexPath.row].Cover)
        return cell
        } else {
            let cell = ThumbnailCollectionView.dequeueReusableCell(withReuseIdentifier: "Thumbnail", for: indexPath) as! ThumbnailsCollectionViewCell
            cell.backgroundColor = UIColor.blue
            if let page = pdfView.document?.page(at: indexPath.item) {
            let thumbnail = page.thumbnail(of: cell.bounds.size, for: PDFDisplayBox.cropBox)
            cell.Thumbnail.image = thumbnail
            cell.PageNumber.text = page.label
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == myBooksCollectionV {
        LoadBook(selectedBook: MyBooks[indexPath.row])
        selectedBook = MyBooks[indexPath.row]
        } else {
            if let page = pdfView.document?.page(at: indexPath.row) {
                pdfView.go(to: page)
            }
        }
    }
    
    
   
    
}


