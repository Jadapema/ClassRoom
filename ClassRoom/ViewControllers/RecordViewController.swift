   
   
   //
//  RecordViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 18/8/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import FirebaseDatabase

class RecordViewController: UIViewController {
    
    @IBOutlet var TakeButton: UIButton!
    @IBOutlet var AsignaturaButton: UIButton!
    @IBOutlet var GrupoButton: UIButton!
    @IBOutlet var TemaButton: UIButton!
    
    @IBOutlet var RecordButton: UIButton!
    @IBOutlet var Segmented: UISegmentedControl!
    
    @IBOutlet var RecordView: UIView!
    
    var Subjects : [Subject]  = []
    var mainRef : FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    //
    let  movieFileOutput = AVCaptureMovieFileOutput()
    var session: AVCaptureSession?
    var userreponsevideoData = NSData()
    var userreponsethumbimageData = NSData()
    ///
    var captureSession = AVCaptureSession()
    var BackCamera: AVCaptureDevice?
    var FrontCamera: AVCaptureDevice?
    var CurrentCamera: AVCaptureDevice?

    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    
    var ImageTaked : UIImage!
    var VideoImage : UIImage!
    var VideoUrl : URL!
    var isRecording = false
    
    var SelectedSubject = UserDefaults.standard.object(forKey: "SUBID")
    var SelectedGroup = UserDefaults.standard.object(forKey: "GRID")
    var SelectedTopic = UserDefaults.standard.object(forKey: "TPID")
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        FetchAll()
        print("ViewWillApear")
        
        TemaButton.isHidden = true
        GrupoButton.isHidden = true
        
        if let SSub = UserDefaults.standard.object(forKey: "SUBID") as? String {
            for sub in Subjects {
                if sub.SubId == SSub {
                    AsignaturaButton.setTitle("\(sub.Name!)", for: .normal)
                    GrupoButton.setTitle("Grupo", for: .normal)
                    GrupoButton.isHidden = false
                    if let GID = UserDefaults.standard.object(forKey: "GRID") as? String {
                        for G in sub.Groups {
                            if G.GrId == GID {
                                GrupoButton.setTitle(G.GroupName!, for: .normal)
                                TemaButton.setTitle("Tema", for: .normal)
                                TemaButton.isHidden = false
                                if let TID = UserDefaults.standard.object(forKey: "TPID") as? String {
                                    for T in G.Topics {
                                        if T.TopicId == TID {
                                            TemaButton.setTitle(T.Topic!, for: .normal)
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
        if Segmented.selectedSegmentIndex == 1 {
            session?.startRunning()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        bordered()
        SetupCaptureSession()
        SetupDevice()
        SetupInputOutput()
        SetupPreviewLayer()
        StartRunningCaptureSession()
       // createSession()
        RecordButton.isHidden = true
        RecordView.isHidden = true
        let check = NSNotification.Name("check")
        NotificationCenter.default.addObserver(self, selector: #selector(RecordViewController.Check), name: check, object: nil)
        
    }
    
    
    @IBAction func RecordButton(_ sender: UIButton) {
        
        if AsignaturaButton.title(for: .normal) == "Asignatura" {
            AsignaturaButton.backgroundColor = #colorLiteral(red: 0.481179595, green: 0.04767268151, blue: 0, alpha: 0.7980254709)
        } else if GrupoButton.title(for: .normal) == "Grupo" {
            AsignaturaButton.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.80078125)
            GrupoButton.backgroundColor = #colorLiteral(red: 0.481179595, green: 0.04767268151, blue: 0, alpha: 0.7980254709)
        } else if TemaButton.title(for: .normal) == "Tema" {
            AsignaturaButton.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.80078125)
            GrupoButton.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.80078125)
            TemaButton.backgroundColor = #colorLiteral(red: 0.481179595, green: 0.04767268151, blue: 0, alpha: 0.7980254709)
        } else {
            AsignaturaButton.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.80078125)
            GrupoButton.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.80078125)
            TemaButton.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.80078125)
            print("record!")
            if isRecording == true {
                print("No record")
                RecordButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8524989298)
                RecordButton.layer.borderColor = #colorLiteral(red: 0.481179595, green: 0.04767268151, blue: 0, alpha: 0.7980254709)
                session?.stopRunning()
                isRecording = false
            } else {
                if session?.isRunning == true {
                    print("record!")
                    RecordButton.backgroundColor = #colorLiteral(red: 0.481179595, green: 0.04767268151, blue: 0, alpha: 0.7980254709)
                    RecordButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8524989298)
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let  filemainurl = NSURL(string: ("\(documentsURL.appendingPathComponent("temp"))" + ".mov"))
                    movieFileOutput.startRecording(toOutputFileURL: filemainurl! as URL, recordingDelegate: self)
                    isRecording = true
                } else {
                    session?.startRunning()
                    print("record!")
                    RecordButton.backgroundColor = #colorLiteral(red: 0.481179595, green: 0.04767268151, blue: 0, alpha: 0.7980254709)
                    RecordButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8524989298)
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let  filemainurl = NSURL(string: ("\(documentsURL.appendingPathComponent("temp"))" + ".mov"))
                    movieFileOutput.startRecording(toOutputFileURL: filemainurl! as URL, recordingDelegate: self)
                    isRecording = true
                }
            }
        }
    }
    
    
    @IBAction func SegmentedChanged(_ sender: UISegmentedControl) {
        switch Segmented.selectedSegmentIndex {
        case 0:
            if captureSession.isRunning {
            TakeButton.isHidden = false
            RecordButton.isHidden = true
            RecordView.isHidden = true
            } else {
                TakeButton.isHidden = false
                RecordButton.isHidden = true
                RecordView.isHidden = true
                captureSession.startRunning()
            }
        case 1:
            TakeButton.isHidden = true
            RecordButton.isHidden = false
            RecordView.isHidden = false
            createSession()
        default:
            return
        }
    }
    
    func Check () {
        if let SSub = UserDefaults.standard.object(forKey: "SUBID") as? String {
            for sub in Subjects {
                if sub.SubId == SSub {
                    AsignaturaButton.setTitle("\(sub.Name!)", for: .normal)
                    GrupoButton.setTitle("Grupo", for: .normal)
                    GrupoButton.isHidden = false
                    if let GID = UserDefaults.standard.object(forKey: "GRID") as? String {
                        for G in sub.Groups {
                            if G.GrId == GID {
                                GrupoButton.setTitle(G.GroupName!, for: .normal)
                                TemaButton.setTitle("Tema", for: .normal)
                                TemaButton.isHidden = false
                                if let TID = UserDefaults.standard.object(forKey: "TPID") as? String {
                                    for T in G.Topics {
                                        if T.TopicId == TID {
                                            TemaButton.setTitle(T.Topic!, for: .normal)
                                            
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
    
    func bordered () {
        TakeButton.layer.borderWidth = 2
        TakeButton.layer.borderColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.80078125)
        TakeButton.layer.masksToBounds = false
        TakeButton.layer.cornerRadius = TakeButton.frame.height/2
        TakeButton.clipsToBounds = true
        
        RecordButton.layer.borderWidth = 2
        RecordButton.layer.borderColor = #colorLiteral(red: 0.481179595, green: 0.04767268151, blue: 0, alpha: 0.8001391267)
        RecordButton.layer.masksToBounds = false
        RecordButton.layer.cornerRadius = TakeButton.frame.height/2
        RecordButton.clipsToBounds = true
        
        AsignaturaButton.layer.borderWidth = 1
        AsignaturaButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8524989298)
        AsignaturaButton.layer.masksToBounds = false
        AsignaturaButton.layer.cornerRadius = 5
        AsignaturaButton.clipsToBounds = true
        
        GrupoButton.layer.borderWidth = 1
        GrupoButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8524989298)
        GrupoButton.layer.masksToBounds = false
        GrupoButton.layer.cornerRadius = 5
        GrupoButton.clipsToBounds = true
        
        TemaButton.layer.borderWidth = 1
        TemaButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8524989298)
        TemaButton.layer.masksToBounds = false
        TemaButton.layer.cornerRadius = 5
        TemaButton.clipsToBounds = true
        
    }
    func SetupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
    }
    func SetupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession?.devices
        for device in devices! {
            if device.position == AVCaptureDevice.Position.back {
                BackCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                FrontCamera = device
            }
            CurrentCamera = BackCamera
        }
    }
    func SetupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: CurrentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            if #available(iOS 11.0, *) {
                photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings.init(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
            captureSession.addOutput(photoOutput!)
            
            
        } catch {
            print(error)
        }
    }
    func SetupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    func StartRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    
    @IBAction func TakeButton(_ sender: UIButton) {
        if AsignaturaButton.title(for: .normal) == "Asignatura" {
            AsignaturaButton.backgroundColor = #colorLiteral(red: 0.481179595, green: 0.04767268151, blue: 0, alpha: 0.7980254709)
        } else if GrupoButton.title(for: .normal) == "Grupo" {
            AsignaturaButton.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.80078125)
            GrupoButton.backgroundColor = #colorLiteral(red: 0.481179595, green: 0.04767268151, blue: 0, alpha: 0.7980254709)
        } else if TemaButton.title(for: .normal) == "Tema" {
            AsignaturaButton.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.80078125)
            GrupoButton.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.80078125)
            TemaButton.backgroundColor = #colorLiteral(red: 0.481179595, green: 0.04767268151, blue: 0, alpha: 0.7980254709)
        } else {
            AsignaturaButton.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.80078125)
            GrupoButton.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.80078125)
            TemaButton.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.7989083904)
            print("record!")
            let settings = AVCapturePhotoSettings()
            photoOutput?.capturePhoto(with: settings, delegate: self)
        }
        
        //performSegue(withIdentifier: "ShowPreview", sender: nil)
    }
    
    @IBAction func AsignaturaButton(_ sender: UIButton) {

        UserDefaults.standard.removeObject(forKey: "SUBID")
        UserDefaults.standard.removeObject(forKey: "GRID")
        UserDefaults.standard.removeObject(forKey: "TPID")
       performSegue(withIdentifier: "subjectsCamera", sender: self)
    }
    
    @IBAction func GrupoButton(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "GRID")
        UserDefaults.standard.removeObject(forKey: "TPID")
        performSegue(withIdentifier: "GroupsCamera", sender: self)
        //GroupsCamera
    }
    
    @IBAction func TemaButton(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "TPID")
        performSegue(withIdentifier: "TopicsCamera", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPreview" {
            let Preview = segue.destination as! PreviewViewController
            Preview.TakedImage = ImageTaked
        } else if segue.identifier == "ShowPreviewVideo" {
            let Vpreview = segue.destination as! VideoPreviewViewController
            Vpreview.VideoImage = VideoImage
            Vpreview.VideoURL = VideoUrl
        } else if segue.identifier == "subjectsCamera" {
           // print("Entro prepare")
            let subjec = segue.destination as! SelectSubjectViewController
            subjec.Subjects = Subjects
        } else if segue.identifier == "GroupsCamera" {
            let group = segue.destination as! SelectGroupViewController
            group.subjects = Subjects
        } else if segue.identifier == "TopicsCamera" {
            let topic = segue.destination as! SelectTopicViewController
            topic.subjects = Subjects
        }
    }
    
    //
    func createSession() {
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession?.devices
        for device in devices! {
            if device.position == AVCaptureDevice.Position.back {
                BackCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                FrontCamera = device
            }
            CurrentCamera = BackCamera
        }
        
        
        
        var input: AVCaptureDeviceInput?
//        let  movieFileOutput = AVCaptureMovieFileOutput()
        var prevLayer: AVCaptureVideoPreviewLayer?
        prevLayer?.frame.size = RecordView.frame.size
        session = AVCaptureSession()
        let error: NSError? = nil
        do { input = try AVCaptureDeviceInput(device: CurrentCamera) } catch {return}
        if error == nil {
            session?.addInput(input)
        } else {
            print("camera input error: \(String(describing: error))")
        }
        prevLayer = AVCaptureVideoPreviewLayer(session: session)
        prevLayer?.frame.size = RecordView.frame.size
        prevLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        prevLayer?.connection.videoOrientation = .portrait
        RecordView.layer.addSublayer(prevLayer!)
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let  filemainurl = NSURL(string: ("\(documentsURL.appendingPathComponent("temp"))" + ".mov"))
        
        let maxDuration: CMTime = CMTimeMake(600, 10)
        movieFileOutput.maxRecordedDuration = maxDuration
        movieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024
        if self.session!.canAddOutput(movieFileOutput) {
            self.session!.addOutput(movieFileOutput)
        }
        session?.startRunning()
//        movieFileOutput.startRecording(toOutputFileURL: filemainurl! as URL, recordingDelegate: self)
        
    }

    func cameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession?.devices
        for device in devices! {
            if device.position == position {
                return device
            }
        }
        return nil
    }

    
    //
    
    
    
    func FetchAll() {
        
        self.mainRef.observe(.value, with: { snapshot in
           // print("Entro")
            self.Subjects.removeAll()
            //Creamos un diccionario con la base de datos completa
            if let dictionary = snapshot.value as? [String:AnyObject] {
                //Creamos un diccionario con la seccion de las asignaturas
                if let subject = dictionary["Subjects"] as? Dictionary<String,AnyObject> {
                   // print("Entro Subjects")
                    //Recorremos la seccion de asignaturas con un ciclo para obtener el valor de cada una
                    for (Key,value) in subject {
                        //Almacenamos todos los valores de cada Asignatura en un diccionario nuevo
                        if let sub = value as? Dictionary<String,AnyObject> {
                            //Chequeamos que existan SubjectName y Description y los almacenamos en sus respectivas variables
                            if let name = sub["SubjectName"] ,
                                let description = sub["Description"], let Year = sub["Year"], let U = sub["University"], let G = sub["Groups"] as? Dictionary<String,AnyObject> {
                               // print("Subject")
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
                                                   // print("Topic")
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
                                                            T.SelectedVideosDuration.append(duration as! String)
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
                               // print("Append \(s.Name)")
                                //this will crash because of background thread, so lets use dispatch_async to fix
                                
                            }
                        }
                    }
                }
                
            }
        })
    }

}


extension RecordViewController : AVCapturePhotoCaptureDelegate {
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let ImageData = photo.fileDataRepresentation() {
            ImageTaked = UIImage(data: ImageData)
            performSegue(withIdentifier: "ShowPreview", sender: nil)
        }
    }
}



