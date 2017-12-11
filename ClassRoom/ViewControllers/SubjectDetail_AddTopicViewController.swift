//
//  SubjectDetail_AddTopicViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 4/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase
import FirebaseStorage

class SubjectDetail_AddTopicViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UITextViewDelegate {

    
    @IBOutlet var CentralView: UIView!
    @IBOutlet var TopicName: UITextField!
    @IBOutlet var Notes: UITextView!
    @IBOutlet var VideoCollectionView: UICollectionView!
    @IBOutlet var ImageCollectionView: UICollectionView!
    
    
    var Subject : Subject!
    var SelectedGroup: Group!
    let Vpicker = UIImagePickerController()
    let Ipicker = UIImagePickerController()
    var ImagesToUpload : [UIImage] = []
    var SelectedVideosUrls : [URL] = []
    var SelectedVideosImages : [UIImage] = []
    var SelectedVideosDuration : [String] = []
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet var AddTopicButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        ImageCollectionView.delegate = self
        ImageCollectionView.dataSource = self
        VideoCollectionView.delegate = self
        VideoCollectionView.dataSource = self
        TopicName.delegate = self
        Notes.delegate = self
        
        Notes.layer.masksToBounds = false
        Notes.layer.cornerRadius = 5
        Notes.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        Notes.layer.borderWidth = 1
        Notes.clipsToBounds = true
        
        CentralView.layer.masksToBounds = false
        CentralView.layer.cornerRadius = 5
        CentralView.layer.borderColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
        CentralView.layer.borderWidth = 1
        CentralView.clipsToBounds = true
        
        AddTopicButton.layer.masksToBounds = false
        AddTopicButton.layer.cornerRadius = 5
        AddTopicButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        AddTopicButton.layer.borderWidth = 1
        AddTopicButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    @IBAction func BGView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func AddVideo(_ sender: UIButton) {
        //Call the handler
        HandleVideoPicker()
        //
        DispatchQueue.main.async(execute: {
            //Reload the Data of VideoCollectionView with the selected videos
            self.VideoCollectionView.reloadData()
        })
    }
    @IBAction func AddImage(_ sender: UIButton) {
        //Call the handler
        HandleImagePicker()
        //
        DispatchQueue.main.async(execute: {
            //Reload the Data of ImageCollectionView with the selected Images
            self.ImageCollectionView.reloadData()
        })
    }
    @IBAction func AddTopic(_ sender: UIButton) {
        
        if TopicName.text != "" && TopicName.text != nil {
            let StorageRef = FIRStorage.storage().reference(forURL: "gs://classroom-19991.appspot.com/").child("Subjects")
            let classes =  FIRDatabase.database().reference().child("Subjects").child("\(Subject.SubId!)").child("Groups").child("\(SelectedGroup.GrId!)").child("Classes").childByAutoId()
            classes.child("Topic").setValue(TopicName.text!)
            classes.child("Notes").childByAutoId().setValue(Notes.text!)
            
            for img in ImagesToUpload {
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
            
            for index in 0...(SelectedVideosUrls.count - 1) {
                let vid = classes.child("Videos").childByAutoId()
                            let imgStorageRef = StorageRef.child("Images").child("VideoThumbnail").child("\(randomAlphaNumericString(length: 10)).jpg")
                            if  let UploadData = UIImageJPEGRepresentation(SelectedVideosImages[index], 0.1) {
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
                vid.child("VideoDuration").setValue(SelectedVideosDuration[index])
                
                let vidStorageRef = StorageRef.child("Videos").child("\(randomAlphaNumericString(length: 10)).mov")
                vidStorageRef.putFile(SelectedVideosUrls[index], metadata: nil, completion: { (metadata, error) in
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

//            var Videos : [Video] = []
//
//            for _ in SelectedVideosUrls{
//               // let vid = classes.child("Videos").childByAutoId()
//                let v : Video!
//                for img in SelectedVideosImages {
//                    let imgStorageRef = StorageRef.child("Images").child("VideoThumbnail").child("\(randomAlphaNumericString(length: 10)).jpg")
//                    if  let UploadData = UIImageJPEGRepresentation(img, 0.1) {
//                        imgStorageRef.put(UploadData, metadata: nil, completion: { (metadata, error) in
//                            if error != nil {
//                                print("Subiendo Imagen\(error!)")
//                            } else {
//                                if let imgdownloadUrl = metadata?.downloadURL()?.absoluteString {
//                                   // vid.child("VideoThumbnailUrl").setValue(imgdownloadUrl)
//
//                                }
//                            }
//
//                        })
//                    }
//                }
//                for V in SelectedVideosDuration {
//                    vid.child("VideoDuration").setValue(V)
//                }
//                for url in SelectedVideosUrls {
//                    print("Entro 0")
//                    let vidStorageRef = StorageRef.child("Videos").child("\(randomAlphaNumericString(length: 10)).mov")
//                    vidStorageRef.putFile(url, metadata: nil, completion: { (metadata, error) in
//                        print("Entro 1")
//                        if error != nil {
//                            print("Error al subir el video : \(error!.localizedDescription)")
//                        } else {
//                            print("Entro 2")
//                            if let downloadUrl = metadata?.downloadURL()?.absoluteString {
//                                print("Entro 3")
//                                vid.child("VideoUrl").setValue(downloadUrl)
//                                DispatchQueue.main.async(execute: {
//                                    let notification = NSNotification.Name("SubjectDetailFetchAll02")
//                                    NotificationCenter.default.post(name: notification, object: nil)
//                                })
//                            }
//
//                        }
//                    })
//                }
//            }
            DispatchQueue.main.async(execute: {
                let notification = NSNotification.Name("SubjectDetailFetchAll02")
                NotificationCenter.default.post(name: notification, object: nil)
            })
            dismiss(animated: true, completion: nil)
        } else {
            print("Ingrese un Tema")
        }
        
        
    }
    
    //DataSource and Delegate Functions
    //CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ImageCollectionView {
            return ImagesToUpload.count
        } else  {
            return SelectedVideosUrls.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ImageCollectionView {
            let cell = ImageCollectionView.dequeueReusableCell(withReuseIdentifier: "SubjectDetail_ImagesId", for: indexPath) as! ImagesCollectionViewCell
            cell.ImageView.image = ImagesToUpload[indexPath.row]
            cell.ImageView.layer.masksToBounds = false
            cell.ImageView.layer.cornerRadius = 5
            cell.ImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.ImageView.layer.borderWidth = 1
            cell.ImageView.clipsToBounds = true
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
            return cell
        } else {
            let cell = VideoCollectionView.dequeueReusableCell(withReuseIdentifier: "SubjectDetail_VideoId", for: indexPath) as! VideoCollectionViewCell
            cell.VideoImageView.image = SelectedVideosImages[indexPath.row]
            cell.VideoImageView.layer.masksToBounds = false
            cell.VideoImageView.layer.cornerRadius = 5
            cell.VideoImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.VideoImageView.layer.borderWidth = 1
            cell.VideoImageView.clipsToBounds = true
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
            cell.VideoDuration.text = SelectedVideosDuration[indexPath.row]
            return cell
        }
    }
    //ImagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //It function launches when we finish of select the media
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Check if is ImagePicker or VideoPicker
        if picker == Ipicker {
            var SelectedImage : UIImage!
            if let EditedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                SelectedImage = EditedImage
            } else if let OriginalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                SelectedImage = OriginalImage
            }
            if let image = SelectedImage {
                ImagesToUpload.append(image)
                //
                DispatchQueue.main.async(execute: {
                    //Reload the Data of ImageCollectionView with the selected Images
                    self.ImageCollectionView.reloadData()
                })
            }
        } else if picker == Vpicker {
            
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
                        self.SelectedVideosUrls.append(compressedURL)
                        self.SelectedVideosImages.append(self.generateThumbnailForVideoAtURL(filePathLocal: compressedURL)!)
                        self.SelectedVideosDuration.append(self.GetDurationOfVideoAtURL(URL: compressedURL)!)
                        print(self.SelectedVideosDuration.count)
                        print(self.SelectedVideosImages.count)
                        print(self.SelectedVideosUrls)
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
        }
        dismiss(animated: true, completion: nil)
    }
    
    //Functions
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
    //Handler of Video picker
    func HandleVideoPicker () {
        //Where we take the info?
        Vpicker.sourceType = .photoLibrary
        Vpicker.delegate = self
        Vpicker.allowsEditing = true
        Vpicker.mediaTypes = ["public.movie"]
        present(Vpicker, animated: true, completion: nil)
    }
    //Handler of Image Picker
    func HandleImagePicker () {
        Ipicker.delegate = self
        Ipicker.allowsEditing = true
        present(Ipicker, animated: true, completion: nil)
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
    
    //Hide Keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.ImageCollectionView.endEditing(true)
    }
    
    //Pressed return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TopicName.resignFirstResponder()
        return true
        
    }
    
    

}


extension SubjectDetail_AddTopicViewController: AVCaptureFileOutputRecordingDelegate {
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

