//
//  PreviewViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 8/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import FirebaseDatabase
import FirebaseStorage

class PreviewViewController: UIViewController {

    
    @IBOutlet var Back: UIImageView!
    @IBOutlet var Upload: UIImageView!
    @IBOutlet var BG: UIImageView!
    
    
    
    
    var TakedImage : UIImage!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleBack)))
        Back.isUserInteractionEnabled = true
        Upload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleUpload)))
        Upload.isUserInteractionEnabled = true
        BG.image = TakedImage
    }

    func HandleBack () {
        dismiss(animated: true, completion: nil)
    }
    func HandleUpload () {
        
       // UIImageWriteToSavedPhotosAlbum(TakedImage, nil, nil, nil)
        
        UIImageWriteToSavedPhotosAlbum(TakedImage, nil, #selector(HandleAlert), nil)
        
        let StorageRef = FIRStorage.storage().reference(forURL: "gs://classroom-19991.appspot.com/").child("Subjects")
        let ImagesDBRef =  FIRDatabase.database().reference().child("Subjects").child("\(UserDefaults.standard.object(forKey: "SUBID") as! String)").child("Groups").child("\(UserDefaults.standard.object(forKey: "GRID") as! String)").child("Classes").child("\(UserDefaults.standard.object(forKey: "TPID") as! String)").child("Images").childByAutoId()
        let imgStorageRef = StorageRef.child("Images").child("\(randomAlphaNumericString(length: 10)).jpg")
        if  let UploadData = UIImageJPEGRepresentation(TakedImage, 0.1) {
            
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
        dismiss(animated: true, completion: nil)
    }
    
    func HandleAlert () {
                let alertController = UIAlertController(title: "Tu Imagen se guardo satisfactoriamente en el Carrete", message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
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

}
