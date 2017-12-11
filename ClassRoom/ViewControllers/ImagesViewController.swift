//
//  ImagesViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 7/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ImagesViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var CancelImageView: UIImageView!
    @IBOutlet var TopicName: UILabel!
    @IBOutlet var AddImageView: UIImageView!
    @IBOutlet var CollectionViewBG: UIView!
    @IBOutlet var CollectionView: UICollectionView!
    @IBOutlet var Arrow: UIImageView!
    @IBOutlet var ArrowLabel: UILabel!
    @IBOutlet var BottonBG: UIView!
    @IBOutlet var Subject: UILabel!
    @IBOutlet var Group: UILabel!
    @IBOutlet var topic: UILabel!
    
    var SelectedSubjectId = UserDefaults.standard.object(forKey: "SelectedSubjectId") as! String
    var SelectedGropId = UserDefaults.standard.object(forKey: "SelectedGroupId") as! String
    var SelectedTopic = UserDefaults.standard.object(forKey: "SelectedTopicId") as! String
    var to : Topic!
    var selectedImageUrl : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchAll()
        CancelImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleCancel)))
        CancelImageView.isUserInteractionEnabled = true
        AddImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleAddImage)))
        AddImageView.isUserInteractionEnabled = true
        Arrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleArrow)))
        Arrow.isUserInteractionEnabled = true
        CollectionView.delegate = self
        CollectionView.dataSource = self
        CollectionView.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        CollectionViewBG.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        CollectionViewBG.layer.masksToBounds = false
        CollectionViewBG.layer.cornerRadius = 5
        CollectionViewBG.layer.borderWidth = 2
        CollectionViewBG.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7018675086)
        CollectionViewBG.clipsToBounds = true
        
        BottonBG.layer.masksToBounds = false
        BottonBG.layer.cornerRadius = 5
        BottonBG.layer.borderWidth = 2
        BottonBG.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7018675086)
        BottonBG.clipsToBounds = true
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if to == nil {return 0} else {
        return to.ImagesUrlString.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Img", for: indexPath) as! ImagesCollectionViewCell
        cell.ImageView.loadImageUsingCacheWithUrlString(to.ImagesUrlString[indexPath.row])
        cell.ImageView.layer.masksToBounds = false
        cell.ImageView.layer.cornerRadius = 5
        cell.ImageView.clipsToBounds = true
        cell.ImageView.contentMode = .scaleToFill
        cell.BGView.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.7989083904)
        cell.BGView.layer.masksToBounds = false
        cell.BGView.layer.cornerRadius = 5
        cell.BGView.clipsToBounds = true
        cell.BGView.contentMode = .scaleAspectFit
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageUrl = to.ImagesUrlString[indexPath.row]
        
        performSegue(withIdentifier: "ImageExtended", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let Extended = segue.destination as? ImageExtendedViewController {
            Extended.selectedImageUrlString = selectedImageUrl
        }
    }
    
    func HandleCancel() {
        UserDefaults.standard.removeObject(forKey: "SelectedSubjectId")
        UserDefaults.standard.removeObject(forKey: "SelectedGroupId")
        UserDefaults.standard.removeObject(forKey: "SelectedTopicId")
        dismiss(animated: true, completion: nil)
    }
    func HandleAddImage() {
        
        HandleImagePicker()
        
    }
    func HandleArrow() {
        
    }
    
    func HandleImagePicker () {
        let Ipicker = UIImagePickerController()
        Ipicker.delegate = self
        Ipicker.allowsEditing = true
        present(Ipicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var SelectedImage : UIImage!
        if let EditedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            SelectedImage = EditedImage
        } else if let OriginalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            SelectedImage = OriginalImage
        }
        if let image = SelectedImage {
            let StorageRef = FIRStorage.storage().reference(forURL: "gs://classroom-19991.appspot.com/").child("Subjects")
            let ImagesDBRef =  FIRDatabase.database().reference().child("Subjects").child("\(SelectedSubjectId)").child("Groups").child("\(SelectedGropId)").child("Classes").child("\(SelectedTopic)").child("Images").childByAutoId()
            let imgStorageRef = StorageRef.child("Images").child("\(randomAlphaNumericString(length: 10)).jpg")
            if  let UploadData = UIImageJPEGRepresentation(image, 0.1) {
                    imgStorageRef.put(UploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print("Subiendo Imagen\(error!)")
                    } else {
                        if let imgdownloadUrl = metadata?.downloadURL()?.absoluteString {
                            ImagesDBRef.setValue(imgdownloadUrl)
                        }
                    }
                })
            }
        }
        dismiss(animated: true, completion: nil)
    }
    

    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        return randomString
    }

    func FetchAll () {
        
        FIRDatabase.database().reference().observe(.value, with: { snapshot in
            //Creamos un diccionario con la base de datos completa
            if let dictionary = snapshot.value as? [String:AnyObject] {
                //Creamos un diccionario con la seccion de las asignaturas
                if let subject = dictionary["Subjects"] as? Dictionary<String,AnyObject> {
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
                                            if let GR = V["GroupName"] as? String {
                                                self.Group.text = GR
                                            }
                                        // print("Entro Grupo \(self.SelectedGropId)")
                                            if let Topics = V["Classes"] as? Dictionary<String,AnyObject> {
                                                for (Id,Va) in Topics {
                                                    if Id == self.SelectedTopic {
                                                        if let TN = Va["Topic"] as? String {
                                                            self.topic.text = TN
                                                        }
                                                     //   print("Entro topic \(self.SelectedTopic)")
                                                        if let TopicName = Va["Topic"]   {
                                                         //   print("Entro entro")
                                                            let T = Topic()
                                                            T.Topic = TopicName as! String
                                                            T.TopicId = Id
                                                            if let Images = Va["Images"] as? Dictionary<String,AnyObject> {
                                                                for (_,imgURL) in Images {
                                                                   // let url = URL(fileURLWithPath: imgURL as! String)
                                                                    T.ImagesUrlString.append(imgURL as! String)
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
                                                            self.to = T
                                                            self.TopicName.text = self.to.Topic
                                                            self.CollectionView.reloadData()
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
