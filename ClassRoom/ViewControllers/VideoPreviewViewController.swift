//
//  VideoPreviewViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 9/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import FirebaseStorage
import FirebaseDatabase
import Photos

class VideoPreviewViewController: UIViewController {

    
    @IBOutlet var BG: UIImageView!
    @IBOutlet var TopView: UIView!
    @IBOutlet var Back: UIImageView!
    @IBOutlet var Upload: UIImageView!
    
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    
    
    var VideoImage : UIImage!
    var VideoURL : URL!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Upload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleUpload)))
        Upload.isUserInteractionEnabled = true
        Back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleBack)))
        Back.isUserInteractionEnabled = true
        BG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandlePlay)))
        BG.isUserInteractionEnabled = true
        BG.image = VideoImage
        
       // print("Esta es mi URL: \(VideoURL!)")
    }

    func HandleUpload() {
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.VideoURL)
        }) { saved, error in
            if saved {
                let alertController = UIAlertController(title: "Tu video se guardo satisfactoriamente en el Carrete, En un momento el video estara disponible en linea", message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
        let data = NSData(contentsOf: VideoURL as URL)!
        print("File size before compression: \(Double(data.length / 1048576)) mb")
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
        compressVideo(inputURL: VideoURL, outputURL: compressedURL) { (exportSession) in
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
                let vid = FIRDatabase.database().reference().child("Subjects").child("\(UserDefaults.standard.object(forKey: "SUBID") as! String)").child("Groups").child("\(UserDefaults.standard.object(forKey: "GRID") as! String)").child("Classes").child("\(UserDefaults.standard.object(forKey: "TPID") as! String)").child("Videos").childByAutoId()
                let StorageRef = FIRStorage.storage().reference(forURL: "gs://classroom-19991.appspot.com/").child("Subjects")
                let imgStorageRef = StorageRef.child("Images").child("VideoThumbnail").child("\(self.randomAlphaNumericString(length: 10)).jpg")
                if  let UploadData = UIImageJPEGRepresentation(self.VideoImage, 0.1) {
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
                vid.child("VideoDuration").setValue(self.GetDurationOfVideoAtURL(URL: self.VideoURL))
                
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
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
            case .failed:
                break
            case .cancelled:
                break
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
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
    
    func HandleBack() {
        dismiss(animated: true, completion: nil)
    }
    func HandlePlay() {
        playerView = AVPlayer(url: VideoURL!)
        playerViewController.player = playerView
        self.present(playerViewController, animated: true) {
            self.playerViewController.player?.play()
        }
    }
}


