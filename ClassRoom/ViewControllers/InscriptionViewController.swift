//
//  InscriptionViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 18/8/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//



import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import AVFoundation
import MapKit
import CoreLocation

class InscriptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate, MKMapViewDelegate , UITabBarDelegate{
        //Outlets
    //Subjects Oulets
    @IBOutlet var MainScrollView: UIScrollView!
    @IBOutlet var MainSegmentedControl: UISegmentedControl!
    @IBOutlet var SubjectName: UITextField!
    @IBOutlet var UniversityPickerView: UIPickerView!
    @IBOutlet var DescriptionTextView: UITextView!
    @IBOutlet var GroupName: UITextField!
    @IBOutlet var TeacherName: UITextField!
    @IBOutlet var TemarioTableView: UITableView!
    @IBOutlet var IntergantesTableView: UITableView!
    @IBOutlet var Map: MKMapView!
    @IBOutlet var addTopicButton: UIButton!
    @IBOutlet var AddMemberButton: UIButton!
    
    @IBOutlet var SubjectView: UIView!
    //University Oulets
    @IBOutlet var UniversityView: UIView!
    @IBOutlet var UniversityName: UITextField!
    @IBOutlet var UniversityMotto: UITextField!
    @IBOutlet var LogoUniversityImageView: UIImageView!
    @IBOutlet var AddUniversityButton: UIButton!
    @IBOutlet var AddSubjectButton: UIButton!
    
    //Variables
    var Universities : [University] = []
    var Years : [Int] = []
    var Topics : [Topic] = []
    var Members : [User] = []
    var SelectedUniversity : University!
    var SelectedUniversityRow : Int!
    var Selectedyear : Int!
    var SelectedYearRow:Int!
    var SelectedUniversityLogo : UIImage!
    
    var annotation : MKPointAnnotation!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
                                                //BeforeView Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadTableview()
        FetchAll()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        if (SubjectName.text?.isEmpty)! {
//            print("SubjectName Empty")
//        } else {
//            UserDefaults.standard.set("\(SubjectName.text!)", forKey: "SubjectName")
//        }
//        if SelectedUniversity == nil && Selectedyear == nil {
//            UserDefaults.standard.set(0, forKey: "SelectedUniversityPosition")
//            UserDefaults.standard.set(0, forKey: "SelectedYearPosition")
//        } else {
//            UserDefaults.standard.set(SelectedUniversityRow, forKey: "SelectedUniversityPosition")
//            UserDefaults.standard.set(SelectedYearRow, forKey: "SelectedYearPosition")
//        }
//        if DescriptionTextView.text.isEmpty {
//            print("Description is empty")
//        } else {
//            UserDefaults.standard.set("\(DescriptionTextView.text!)", forKey: "SubjectDescription")
//        }
//        if (GroupName.text?.isEmpty)! {
//            print("GroupName is empty")
//        } else {
//            UserDefaults.standard.set("\(GroupName.text!)", forKey: "GroupName")
//        }
//        if (TeacherName.text?.isEmpty)! {
//            print("TeacherName is empty")
//        } else {
//            UserDefaults.standard.set("\(TeacherName.text!)", forKey: "TeacherName")
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Assign the delegates
        self.TemarioTableView.delegate = self
        self.TemarioTableView.dataSource = self
        self.IntergantesTableView.delegate = self
        self.IntergantesTableView.dataSource = self
        self.UniversityPickerView.delegate = self
        self.UniversityPickerView.dataSource = self
        self.SubjectName.delegate = self
        self.DescriptionTextView.delegate = self
        self.GroupName.delegate = self
        self.TeacherName.delegate = self
        self.UniversityName.delegate = self
        self.UniversityMotto.delegate = self
        self.Map.delegate = self
        
        Map.layer.masksToBounds = false
        Map.layer.cornerRadius = 5
        Map.clipsToBounds = true
        AddUniversityButton.layer.masksToBounds = false
        AddUniversityButton.layer.cornerRadius = 5
        AddUniversityButton.layer.borderWidth = 1
        AddUniversityButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5961312072)
        AddUniversityButton.clipsToBounds = true
        
        DescriptionTextView.layer.masksToBounds = false
        DescriptionTextView.layer.cornerRadius = 5
        DescriptionTextView.layer.borderWidth = 1
        DescriptionTextView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        DescriptionTextView.clipsToBounds = true
        
        AddSubjectButton.layer.masksToBounds = false
        AddSubjectButton.layer.cornerRadius = 5
        AddSubjectButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5961312072)
        AddSubjectButton.layer.borderWidth = 1
        AddSubjectButton.clipsToBounds = true
        
        TemarioTableView.layer.masksToBounds = false
        TemarioTableView.layer.cornerRadius = 5
        TemarioTableView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        TemarioTableView.layer.borderWidth = 1
        TemarioTableView.clipsToBounds = true
        
        IntergantesTableView.layer.masksToBounds = false
        IntergantesTableView.layer.cornerRadius = 5
        IntergantesTableView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        IntergantesTableView.layer.borderWidth = 1
        IntergantesTableView.clipsToBounds = true
        
        addTopicButton.layer.masksToBounds = false
        addTopicButton.layer.cornerRadius = 5
        addTopicButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addTopicButton.layer.borderWidth = 1
        addTopicButton.clipsToBounds = true
        
        AddMemberButton.layer.masksToBounds = false
        AddMemberButton.layer.cornerRadius = 5
        AddMemberButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        AddMemberButton.layer.borderWidth = 1
        AddMemberButton.clipsToBounds = true
        
        let location = CLLocationCoordinate2DMake(12.114126100862466, -86.22391120937505)
        let span = MKCoordinateSpanMake(0.2, 0.2)
        let region = MKCoordinateRegion(center: location, span: span)
        Map.setRegion(region, animated: true)
        
        
        
        //Change the BG to TablesV
        TemarioTableView.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        IntergantesTableView.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        //Hide UniversityView
        UniversityView.isHidden = true
        //Add Selector to the university Image
        LogoUniversityImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleImagePicker)))
        LogoUniversityImageView.isUserInteractionEnabled = true
        //Get Date
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        for i in (1970...year).reversed() {
        self.Years.append(i)
        }
        //Notifications to reloadtableview from other VC
        let notificationNme = NSNotification.Name("NotificationIdf")
        NotificationCenter.default.addObserver(self, selector: #selector(InscriptionViewController.reloadTableview), name: notificationNme, object: nil)
        let notification = NSNotification.Name("Notification")
        NotificationCenter.default.addObserver(self, selector: #selector(InscriptionViewController.reloadTableview), name: notification, object: nil)
    }

    
                                            // IBActions
    @IBAction func EnrollSubject(_ sender: UIButton) {
        if SubjectName.text == "" || SubjectName.text == nil {
            SubjectName.backgroundColor = #colorLiteral(red: 0.8459790349, green: 0.2873021364, blue: 0.2579272389, alpha: 1)
        } else if DescriptionTextView.text == "" || DescriptionTextView.text == nil {
            DescriptionTextView.backgroundColor = #colorLiteral(red: 0.8459790349, green: 0.2873021364, blue: 0.2579272389, alpha: 1)
        } else if GroupName.text == "" || GroupName.text == nil {
            GroupName.backgroundColor = #colorLiteral(red: 0.8459790349, green: 0.2873021364, blue: 0.2579272389, alpha: 1)
        } else if TeacherName.text == "" || TeacherName.text == nil {
            TeacherName.backgroundColor = #colorLiteral(red: 0.8459790349, green: 0.2873021364, blue: 0.2579272389, alpha: 1)
        } else {
            print("Temas : \(Topics.count)")
            
            
            
            if (SelectedUniversity == nil && Selectedyear == nil) || (SelectedUniversity == nil || Selectedyear == nil) {
                let date = Date()
                let calendar = Calendar.current
                let year = calendar.component(.year, from: date)
                let U = University(uid: Universities[0].Uid, name: Universities[0].Name)
                SelectedUniversity = U
                Selectedyear = year
                
            }
            
            print("Buton------")
            print("Selected University is: \(SelectedUniversity.Name!)")
            // print("Selected Year is: \(Selectedyear!)")
            
            let ref =  FIRDatabase.database().reference().child("Subjects").childByAutoId()
            ref.child("Description").setValue(DescriptionTextView.text!)
            ref.child("SubjectName").setValue(SubjectName.text!)
            ref.child("University").setValue(SelectedUniversity.Uid)
            ref.child("Year").setValue(Selectedyear)
            let group = ref.child("Groups").childByAutoId()
            group.child("GroupName").setValue(GroupName.text!)
            group.child("Teacher").child("Name").setValue(TeacherName.text!)
            let members = group.child("Members")
            for member in Members {
                members.child(member.UserId!).setValue(true)
                members.child((FIRAuth.auth()?.currentUser?.uid)!).setValue(true)
            }
            let StorageRef = FIRStorage.storage().reference(forURL: "gs://classroom-19991.appspot.com/").child("Subjects")
            for t in Topics {
                let classes = group.child("Classes").childByAutoId()
                classes.child("Topic").setValue(t.Topic!)
                classes.child("Notes").childByAutoId().setValue(t.Notes)
                for img in t.ImagesToUpload {
                    let imgStorageRef = StorageRef.child("Images").child("\(randomAlphaNumericString(length: 10)).jpg")
                    if  let UploadData = UIImageJPEGRepresentation(img, 0.1) {
                        imgStorageRef.put(UploadData, metadata: nil, completion: { (metadata, error) in
                            if error != nil {
                                print("Subiendo Imagen\(error!)")
                            } else {
                                if let imgdownloadUrl = metadata?.downloadURL()?.absoluteString {
                                    classes.child("Images").childByAutoId().setValue(imgdownloadUrl)
                                }
                            }
                            
                        })
                    }
                }
                if t.SelectedVideosUrls.count != 0 {
                for index in 0...(t.SelectedVideosUrls.count - 1) {
                    let vid = classes.child("Videos").childByAutoId()
                    let imgStorageRef = StorageRef.child("Images").child("VideoThumbnail").child("\(randomAlphaNumericString(length: 10)).jpg")
                    if  let UploadData = UIImageJPEGRepresentation(t.SelectedVideosImages[index], 0.1) {
                        imgStorageRef.put(UploadData, metadata: nil, completion: { (metadata, error) in
                            if error != nil {
                                print("Subiendo Imagen\(error!)")
                            } else {
                                if let imgdownloadUrl = metadata?.downloadURL()?.absoluteString {
                                    vid.child("VideoThumbnailUrl").setValue(imgdownloadUrl)
                                }
                            }
                        })
//                    }
//                    } else {
                    
                    let vid = classes.child("Videos").childByAutoId()
                    vid.child("VideoDuration").setValue(t.SelectedVideosDuration[index])
                    
                        let vidStorageRef = StorageRef.child("Videos").child("\(randomAlphaNumericString(length: 10)).mov")
                    vidStorageRef.putFile(t.SelectedVideosUrls[index], metadata: nil, completion: { (metadata, error) in
                        print("Entro 1")
                        if error != nil {
                            print("Error al subir el video : \(error!.localizedDescription)")
                        } else {
                            print("Entro 2")
                            if let downloadUrl = metadata?.downloadURL()?.absoluteString {
                                print("Entro 3")
                                vid.child("VideoUrl").setValue(downloadUrl)
                                DispatchQueue.main.async(execute: {
                                    let notification = NSNotification.Name("SubjectDetailFetchAll02")
                                    NotificationCenter.default.post(name: notification, object: nil)
                                })
                            }
                        }
                    })
                    }
                }
            }
            }
            
            
            UserDefaults.standard.removeObject(forKey: "Topics")
            UserDefaults.standard.removeObject(forKey: "Members")
            UserDefaults.standard.removeObject(forKey: "SubjectName")
            UserDefaults.standard.removeObject(forKey: "SelectedUniversityPosition")
            UserDefaults.standard.removeObject(forKey: "SelectedYearPosition")
            UserDefaults.standard.removeObject(forKey: "SubjectDescription")
            UserDefaults.standard.removeObject(forKey: "GroupName")
            UserDefaults.standard.removeObject(forKey: "TeacherName")
            UserDefaults.standard.synchronize()
            Topics.removeAll()
            Members.removeAll()
            reloadTableview()
            SubjectName.text = ""
            SubjectName.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            DescriptionTextView.text = ""
            DescriptionTextView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            GroupName.text = ""
            GroupName.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            TeacherName.text = ""
            TeacherName.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        }
        
    }
    @IBAction func EnrollUniversity(_ sender: UIButton) {
        AddUniversityButton.setTitle("Inscribiendo...", for: .normal)
        AddUniversity()
    }
    @IBAction func AddMember(_ sender: UIButton) {
        if (SubjectName.text?.isEmpty)! {
            SubjectName.backgroundColor = #colorLiteral(red: 0.8459790349, green: 0.2873021364, blue: 0.2579272389, alpha: 1)
        } else {
            UserDefaults.standard.set("\(SubjectName.text!)", forKey: "SubjectName")
        }
        if SelectedUniversity == nil && Selectedyear == nil {
            UserDefaults.standard.set(0, forKey: "SelectedUniversityPosition")
            UserDefaults.standard.set(0, forKey: "SelectedYearPosition")
        } else {
            UserDefaults.standard.set(SelectedUniversityRow, forKey: "SelectedUniversityPosition")
            UserDefaults.standard.set(SelectedYearRow, forKey: "SelectedYearPosition")
        }
        if DescriptionTextView.text.isEmpty {
            print("Description is empty")
        } else {
            UserDefaults.standard.set("\(DescriptionTextView.text!)", forKey: "SubjectDescription")
        }
        if (GroupName.text?.isEmpty)! {
            print("GroupName is empty")
        } else {
            UserDefaults.standard.set("\(GroupName.text!)", forKey: "GroupName")
        }
        if (TeacherName.text?.isEmpty)! {
            print("TeacherName is empty")
        } else {
            UserDefaults.standard.set("\(TeacherName.text!)", forKey: "TeacherName")
        }
        performSegue(withIdentifier: "Member", sender: self)
    }
    @IBAction func AddClass(_ sender: UIButton) {
        if (SubjectName.text?.isEmpty)! {
            print("SubjectName Empty")
        } else {
        UserDefaults.standard.set("\(SubjectName.text!)", forKey: "SubjectName")
        }
        if SelectedUniversity == nil && Selectedyear == nil {
            UserDefaults.standard.set(0, forKey: "SelectedUniversityPosition")
            UserDefaults.standard.set(0, forKey: "SelectedYearPosition")
        } else {
            UserDefaults.standard.set(SelectedUniversityRow, forKey: "SelectedUniversityPosition")
            UserDefaults.standard.set(SelectedYearRow, forKey: "SelectedYearPosition")
        }
        if DescriptionTextView.text.isEmpty {
            print("Description is empty")
        } else {
            UserDefaults.standard.set("\(DescriptionTextView.text!)", forKey: "SubjectDescription")
        }
        if (GroupName.text?.isEmpty)! {
            print("GroupName is empty")
        } else {
            UserDefaults.standard.set("\(GroupName.text!)", forKey: "GroupName")
        }
        if (TeacherName.text?.isEmpty)! {
            print("TeacherName is empty")
        } else {
            UserDefaults.standard.set("\(TeacherName.text!)", forKey: "TeacherName")
        }
        performSegue(withIdentifier: "Topic", sender: self)
    }
    @IBAction func IndexChanged(_ sender: UISegmentedControl) {
        switch MainSegmentedControl.selectedSegmentIndex {
        case 0:
            MainScrollView.isHidden = false
            UniversityView.isHidden = true
        case 1:
            MainScrollView.isHidden = true
            UniversityView.isHidden = false
        default:
            break;
        }
    }

                                    //DataSource and Delegate Functions
    //TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == TemarioTableView {
            return Topics.count
        } else {
            return Members.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == TemarioTableView {
            let cell = TemarioTableView.dequeueReusableCell(withIdentifier: "Classes") as! TopicsTableViewCell
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
            cell.NameLabel.text = Topics[indexPath.row].Topic
            cell.ImagesCountLabel.text = "Imagenes: \(Topics[indexPath.row].ImagesToUpload.count)"
            cell.VideoCountLabel.text = "Videos: \(Topics[indexPath.row].SelectedVideosUrls.count)"
            return cell
        } else {
            let cell = IntergantesTableView.dequeueReusableCell(withIdentifier: "Members") as! SelectedMembersTableViewCell
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
            cell.ProfileImage.loadImageUsingCacheWithUrlString(Members[indexPath.row].ProfileImageUrl)
            cell.ProfileImage.layer.masksToBounds = false
            cell.ProfileImage.layer.cornerRadius = cell.ProfileImage.frame.height/2
            cell.ProfileImage.clipsToBounds = true
            cell.ProfileImage.contentMode = .scaleAspectFit
            cell.NameLabel.text = Members[indexPath.row].Name
            return cell
        }
    }
    //PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
        return self.Universities.count
        } else {
            return self.Years.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
        print("Selected is : \(self.Universities[row].Name)")
            let SelectionU = University(uid: self.Universities[row].Uid, name: self.Universities[row].Name)
            self.SelectedUniversity = SelectionU
            self.SelectedUniversityRow = row
        } else {
        print("Selected is : \(self.Years[row])")
            self.Selectedyear = self.Years[row]
            self.SelectedYearRow = row
        }
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 0 {
        let attributedString = NSAttributedString(string: Universities[row].Name, attributes: [NSForegroundColorAttributeName : UIColor.white])
        return attributedString
        } else {
        let attributedString = NSAttributedString(string: "\(Years[row])", attributes: [NSForegroundColorAttributeName : UIColor.white])
        return attributedString
        }
    }
    //ImagePickerView
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var SelectedImage : UIImage!
//        if let EditedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            SelectedImage = EditedImage
//        } else
        if let OriginalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            SelectedImage = OriginalImage
        }
        if let image = SelectedImage {
             LogoUniversityImageView.image = image
            LogoUniversityImageView.layer.masksToBounds = false
            LogoUniversityImageView.layer.borderWidth = 1
            LogoUniversityImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            LogoUniversityImageView.layer.cornerRadius = 5
            LogoUniversityImageView.clipsToBounds = true
            LogoUniversityImageView.contentMode = .scaleAspectFill
            SelectedUniversityLogo = image
        }
       dismiss(animated: true, completion: nil)
    }
    
    
    
                                        //Functions
    func FetchAll() {

        // Esperamos a que se haga un cambio en la base de datos
        FIRDatabase.database().reference().observe(.value, with: { snapshot in
                    self.Universities.removeAll()
            //Creamos un diccionario con la base de datos completa
            if let dictionary = snapshot.value as? [String:AnyObject] {
                //Creamos un diccionario con la seccion de las asignaturas
                if let subject = dictionary["Universities"] as? Dictionary<String,AnyObject> {
                    //Recorremos la seccion de asignaturas con un ciclo para obtener el valor de cada una, obviando la llave
                    for (Key,value) in subject {
                        //Almacenamos todos los valores de cada Asignatura en un diccionario nuevo
                        if let sub = value as? Dictionary<String,AnyObject> {
                            //Chequeamos que existan SubjectName y Description y los almacenamos en sus respectivas variables
                            if let name = sub["Name"] {
                                //Creamos y asignamos cada valor a la variable s que creamos de tipo SubjectsFirst
                                let u = University(uid: Key, name: name as! String)
                                //Añadimos nuestro SujectsFirst al arreglo que creamos al principio
                                self.Universities.append(u)
                                //Fundamental...
                                //this will crash because of background thread, so lets use dispatch_async to fix
                                DispatchQueue.main.async(execute: {
                                    //Refrescamos los valores de nuestra tabla
                                    self.UniversityPickerView.reloadAllComponents()
                                })
                            }
                        }
                    }
                }
            }
        })
    }
    
    
    
    func HandleImagePicker () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func reloadTableview() {
        // No TableViews
        if let subN = UserDefaults.standard.object(forKey: "SubjectName") as? String {
            SubjectName.text = subN
        }
        if let SUP = UserDefaults.standard.object(forKey: "SelectedUniversityPosition") as? Int {
            UniversityPickerView.selectRow(SUP, inComponent: 0, animated: true)
        }
        if let SYP = UserDefaults.standard.object(forKey: "SelectedYearPosition") as? Int {
            UniversityPickerView.selectRow(SYP, inComponent: 1, animated: true)
        }
        if let SubD = UserDefaults.standard.object(forKey: "SubjectDescription") as? String {
            DescriptionTextView.text = SubD
        }
        if let GroN = UserDefaults.standard.object(forKey: "GroupName") as? String {
            GroupName.text = GroN
        }
        if let TeaN = UserDefaults.standard.object(forKey: "TeacherName") as? String {
            TeacherName.text = TeaN
        }
        //TableViews
        if let TopicFromDefault = ArchiveUtiliesTopic.loadTopic() {
            Topics = TopicFromDefault
        }
        self.TemarioTableView.reloadData()
        
        if let MemberFromDefault = ArchiveUtiliesMembers.loadMembers() {
            Members = MemberFromDefault
        }
        self.IntergantesTableView.reloadData()
    }
    func AddUniversity () {
        let StorageRef = FIRStorage.storage().reference(forURL: "gs://classroom-19991.appspot.com/").child("Logo_Universities").child("\(randomAlphaNumericString(length: 10)).png")
        if SelectedUniversityLogo == nil {
            SelectedUniversityLogo = UIImage(named: "icons8-Embassy Filled")
        }
        if let UploadData = UIImageJPEGRepresentation(SelectedUniversityLogo, 0.1) {
            StorageRef.put(UploadData, metadata: nil, completion: { (Metadata, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let LogoImage = Metadata?.downloadURL()?.absoluteString {
                        print("University Added")
                        
                        self.SetValues(LogoUrl: LogoImage, Latitude: "00.0000", Longitude: "00.0000")
                        self.UniversityMotto.text = ""
                        self.UniversityName.text = ""
                        self.LogoUniversityImageView.image = #imageLiteral(resourceName: "icons8-Embassy Filled")
                        self.AddUniversityButton.setTitle("Inscribir Universidad", for: .normal)
                        
                    }
                }
                self.LogoUniversityImageView.layer.borderWidth = 0
                self.LogoUniversityImageView.contentMode = .scaleAspectFit
                self.MainSegmentedControl.selectedSegmentIndex = 0
                self.UniversityView.isHidden = true
                self.MainScrollView.isHidden = false
            })
        }
    }
    func SetValues(LogoUrl:String,Latitude:String,Longitude:String)  {
        let ref =  FIRDatabase.database().reference().child("Universities").childByAutoId()
        ref.child("Name").setValue("\(UniversityName.text!)")
        ref.child("Motto").setValue("\(UniversityMotto.text!)")
        ref.child("Logo").setValue("\(LogoUrl)")
        ref.child("Location").child("Latitude").setValue("\(annotation.coordinate.latitude)")
        ref.child("Location").child("Longitude").setValue("\(annotation.coordinate.longitude)")
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let TopicVc = segue.destination as? PopUpAddClassViewController {
        TopicVc.TopicTemp = Topics
        }
    }
    //Hide Keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self.Map)
        let location = self.Map.convert(touchPoint!, toCoordinateFrom: self.Map)
        print("\(location.latitude), \(location.longitude)")
        if annotation != nil {
        Map.removeAnnotation(annotation)
        }
        if UniversityName.text == "" || UniversityName.text == nil {
            UniversityName.backgroundColor = #colorLiteral(red: 0.8459790349, green: 0.2873021364, blue: 0.2579272389, alpha: 1)
            UniversityMotto.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else if UniversityMotto.text == "" || UniversityMotto.text == nil {
            UniversityMotto.backgroundColor = #colorLiteral(red: 0.8459790349, green: 0.2873021364, blue: 0.2579272389, alpha: 1)
            UniversityName.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
        UniversityName.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        UniversityMotto.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = UniversityName.text
        annotation.subtitle = UniversityMotto.text
        Map.addAnnotation(annotation)
        SubjectView.endEditing(true)
        }
    }
    
    //Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SubjectName.resignFirstResponder()
        GroupName.resignFirstResponder()
        TeacherName.resignFirstResponder()
        UniversityName.resignFirstResponder()
        UniversityMotto.resignFirstResponder()
        return true
        
    }
}

                                                //Data models

