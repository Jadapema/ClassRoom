//
//  VideosViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 7/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import AVFoundation
import AVKit


class VideosViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var Cancel: UIImageView!
    @IBOutlet var TopicName: UILabel!
    @IBOutlet var AddVideo: UIImageView!
    @IBOutlet var CollectionViewBG: UIView!
    @IBOutlet var VideoCollectionView: UICollectionView!
    @IBOutlet var BottonBG: UIView!
    @IBOutlet var Subject: UILabel!
    @IBOutlet var Group: UILabel!
    @IBOutlet var top: UILabel!
    
    var SelectedSubjectId = UserDefaults.standard.object(forKey: "SelectedSubjectId") as! String
    var SelectedGropId = UserDefaults.standard.object(forKey: "SelectedGroupId") as! String
    var SelectedTopic = UserDefaults.standard.object(forKey: "SelectedTopicId") as! String
    var topic : Topic!
    
    let avPlayerVC = AVPlayerViewController()
    var avPlayer:AVPlayer?
    var selectedVideoUrl : URL!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        FetchAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FetchAll()
        print("Selected Subject: \(SelectedSubjectId)")
        print("Selected Group: \(SelectedGropId)")
        print("Selected Topic: \(SelectedTopic)")
        Cancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleCancel)))
        Cancel.isUserInteractionEnabled = true
        AddVideo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleAddVideo)))
        AddVideo.isUserInteractionEnabled = true
        VideoCollectionView.delegate = self
        VideoCollectionView.dataSource = self
        
        BottonBG.layer.masksToBounds = false
        BottonBG.layer.cornerRadius = 5
        BottonBG.layer.borderWidth = 2
        BottonBG.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7018675086)
        BottonBG.clipsToBounds = true
        VideoCollectionView.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        CollectionViewBG.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        CollectionViewBG.layer.masksToBounds = false
        CollectionViewBG.layer.cornerRadius = 5
        CollectionViewBG.layer.borderWidth = 2
        CollectionViewBG.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7018675086)
        CollectionViewBG.clipsToBounds = true
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if topic != nil {
        return topic.SelectedVideosImagesUrlString.count
        } else {
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Vid", for: indexPath) as! VideoCollectionViewCell
        cell.VideoImageView.loadImageUsingCacheWithUrlString(topic.SelectedVideosImagesUrlString[indexPath.row])
        cell.VideoImageView.layer.masksToBounds = false
        cell.VideoImageView.layer.cornerRadius = 5
        cell.VideoImageView.clipsToBounds = true
       // cell.VideoImageView.contentMode = .scaleToFill
        cell.BGView.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 0.7989083904)
        cell.BGView.layer.masksToBounds = false
        cell.BGView.layer.cornerRadius = 5
        cell.BGView.clipsToBounds = true
        cell.BGView.contentMode = .scaleToFill
        cell.VideoDuration.text = topic.SelectedVideosDuration[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
      selectedVideoUrl = topic.SelectedVideosUrls[indexPath.row]
        print(selectedVideoUrl.absoluteString)
        let dowloadtask =  FIRStorage.storage().reference(forURL: "\(topic.SelectedVideosUrlString[indexPath.row])").data(withMaxSize: 100 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Hola")
                let path = NSTemporaryDirectory() as String
                print(path)
                
                    print("Hahahahahahahahahah")
                let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
                do {
                    try data!.write(to: compressedURL, options: .atomicWrite)
                } catch {
                    print(error)
                }
                
//                                        let u = URL(fileURLWithPath: string as String)
                                            self.avPlayer = AVPlayer(url: compressedURL)
                                            self.avPlayerVC.player = self.avPlayer
                    
                    
                
                
                self.present(self.avPlayerVC, animated: true, completion: {
                    self.avPlayerVC.player?.play()
                })
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
    
    func HandleCancel() {
        UserDefaults.standard.removeObject(forKey: "SelectedSubjectId")
        UserDefaults.standard.removeObject(forKey: "SelectedGroupId")
        UserDefaults.standard.removeObject(forKey: "SelectedTopicId")
        dismiss(animated: true, completion: nil)
    }
    func HandleAddVideo() {
        
        HandleVideoPicker()
        
    }
    func HandleAvPlayer() {
        
        if let url = selectedVideoUrl {
            print("URL: \(url)")
            self.avPlayer = AVPlayer(url: url)
            self.avPlayerVC.player = self.avPlayer
        }
        
    }
    
    //Handler of Video picker
    func HandleVideoPicker () {
        //Where we take the info?
        let Vpicker = UIImagePickerController()
        Vpicker.sourceType = .photoLibrary
        Vpicker.delegate = self
        Vpicker.allowsEditing = true
        Vpicker.mediaTypes = ["public.movie"]
        present(Vpicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let SelectedVideo = info["UIImagePickerControllerMediaURL"] as? URL {
            
            let data = NSData(contentsOf: SelectedVideo as URL)!
            print("File size before compression: \(Double(data.length / 1048576)) mb")
            let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
            compressVideo(inputURL: SelectedVideo, outputURL: compressedURL) { (exportSession) in
                guard let session = exportSession else {
                    return
                }
                
                switch session.status {
                case .unknown:
                    break
                case .waiting:
                    break
                case .exporting:
                    break
                case .completed:
                    guard let compressedData = NSData(contentsOf: compressedURL) else {
                        return
                    }
                    
                    
                    let vid = FIRDatabase.database().reference().child("Subjects").child("\(self.SelectedSubjectId)").child("Groups").child("\(self.SelectedGropId)").child("Classes").child("\(self.SelectedTopic)").child("Videos").childByAutoId()
                    let StorageRef = FIRStorage.storage().reference(forURL: "gs://classroom-19991.appspot.com/").child("Subjects")
                    let imgStorageRef = StorageRef.child("Images").child("VideoThumbnail").child("\(self.randomAlphaNumericString(length: 10)).jpg")
                    if  let UploadData = UIImageJPEGRepresentation(self.generateThumbnailForVideoAtURL(filePathLocal: compressedURL)!, 0.1) {
                        imgStorageRef.put(UploadData, metadata: nil, completion: { (metadata, error) in
                            if error != nil {
                                print("Subiendo Imagen\(error!)")
                            } else {
                                if let imgdownloadUrl = metadata?.downloadURL()?.absoluteString {
                                    vid.child("VideoThumbnailUrl").setValue(imgdownloadUrl)
                                }
                            }
                        })
                    }
                    vid.child("VideoDuration").setValue(self.GetDurationOfVideoAtURL(URL: compressedURL)!)
                    
                    let vidStorageRef = StorageRef.child("Videos").child("\(self.randomAlphaNumericString(length: 10)).mov")
                    vidStorageRef.putFile(compressedURL, metadata: nil, completion: { (metadata, error) in
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
                    
//                    self.SelectedVideosUrls.append(compressedURL)
//                    self.SelectedVideosImages.append(self.generateThumbnailForVideoAtURL(filePathLocal: compressedURL)!)
//                    self.SelectedVideosDuration.append(self.GetDurationOfVideoAtURL(URL: compressedURL)!)
                    DispatchQueue.main.async(execute: {
                        //Reload the Data of VideoCollectionView with the selected Videos
                        self.VideoCollectionView.reloadData()
                    })
                    
                    print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                case .failed:
                    break
                case .cancelled:
                    break
                }
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    //Return a image of a video
    func generateThumbnailForVideoAtURL(filePathLocal: URL) -> UIImage? {
        let asset = AVURLAsset(url: filePathLocal)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    //Return a String with the duration of a video
    func GetDurationOfVideoAtURL(URL: URL) -> String? {
        let asset = AVURLAsset(url: URL)
        let durationInSeconds = asset.duration.seconds
        let minutes = Int(durationInSeconds/60)
        let seconds = Int(Int(durationInSeconds.rounded()) - minutes * 60)
        let duration = "\(minutes):\(seconds)"
        return duration
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
       // print("Fecth")
        FIRDatabase.database().reference(fromURL: "https://classroom-19991.firebaseio.com/").observe(.value, with: { snapshot in
            //Creamos un diccionario con la base de datos completa
         //   print("Snap")
            if let dictionary = snapshot.value as? [String:AnyObject] {
              //  print("dict")
                //Creamos un diccionario con la seccion de las asignaturas
                if let subject = dictionary["Subjects"] as? Dictionary<String,AnyObject> {
                 //   print("Subjec")
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
                                            //print("Entro Grupo \(self.SelectedGropId)")
                                            if let Topics = V["Classes"] as? Dictionary<String,AnyObject> {
                                                for (Id,Va) in Topics {
                                                    if Id == self.SelectedTopic {
                                                        if let TN = Va["Topic"] as? String {
                                                            self.top.text = TN
                                                        }
                                                       // print("Entro topic \(self.SelectedTopic)")
                                                        if let TopicName = Va["Topic"]   {
                                                           // print("Entro entro")
                                                            let T = Topic()
                                                            T.Topic = TopicName as! String
                                                            T.TopicId = Id
                                                            if let Images = Va["Images"] as? Dictionary<String,AnyObject> {
                                                               // print("Entro Images")
                                                                for (_,imgURL) in Images {
                                                                    // let url = URL(fileURLWithPath: imgURL as! String)
                                                                    T.ImagesUrlString.append(imgURL as! String)
                                                                }
                                                            }
                                                            if let Notes = Va["Notes"] as? Dictionary<String,AnyObject> {
                                                               // print("Entro Notes")
                                                                for (_,nota) in Notes {
                                                                    T.NotesA.append(nota as! String)
                                                                }
                                                            }
                                                            if let Videos = Va["Videos"] as? Dictionary<String,AnyObject> {
                                                               // print("Entro Videos")
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
                                                                        T.SelectedVideosUrlString.append(vidU as! String)
                                                                    }
                                                                    if let imgUrl = VidURL["VideoThumbnailUrl"] {
                                                                        if imgUrl != nil {
                                                                        T.SelectedVideosImagesUrlString.append(imgUrl as! String)
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            self.topic = T
                                                            self.TopicName.text = self.topic.Topic
                                                            self.VideoCollectionView.reloadData()
                                                  
                                                           // print("imagVideoUrl : \(T.SelectedVideosImagesUrlString.count)")
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

extension VideosViewController: AVCaptureFileOutputRecordingDelegate {
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        guard let data = NSData(contentsOf: outputFileURL as URL) else {
            return
        }
        
        print("File size before compression: \(Double(data.length / 1048576)) mb")
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
        compressVideo(inputURL: outputFileURL as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
            case .failed:
                break
            case .cancelled:
                break
            }
        }
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetLowQuality) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileTypeQuickTimeMovie
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}
