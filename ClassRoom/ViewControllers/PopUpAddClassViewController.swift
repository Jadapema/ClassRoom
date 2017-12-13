//
//  PopUpAddClassViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 22/8/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import AVFoundation

class PopUpAddClassViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UITextViewDelegate {
    // Outlets
    @IBOutlet var ImagesCollectionView: UICollectionView!
    @IBOutlet var VideoCollectionView: UICollectionView!
    @IBOutlet var NotasTextView: UITextView!
    @IBOutlet var TemaTextfield: UITextField!
    @IBOutlet var BGView: UIView!
    @IBOutlet var AddTopicButton: UIButton!
    
    
    // Variables
    var TopicTemp : [Topic] = []
    let Vpicker = UIImagePickerController()
    let Ipicker = UIImagePickerController()
    var ImagesToUpload : [UIImage] = []
    var SelectedVideosUrls : [URL] = []
    var SelectedVideosImages : [UIImage] = []
    var SelectedVideosDuration : [String] = []
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
                                                //BeforeView Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //Specify the delegates
        ImagesCollectionView.delegate = self
        ImagesCollectionView.dataSource = self
        VideoCollectionView.delegate = self
        VideoCollectionView.dataSource = self
        TemaTextfield.delegate = self
        NotasTextView.delegate = self
        
        NotasTextView.layer.masksToBounds = false
        NotasTextView.layer.cornerRadius = 5
        NotasTextView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        NotasTextView.layer.borderWidth = 1
        NotasTextView.clipsToBounds = true
        
        BGView.layer.masksToBounds = false
        BGView.layer.cornerRadius = 5
        BGView.layer.borderColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
        BGView.layer.borderWidth = 1
        BGView.clipsToBounds = true
        
        AddTopicButton.layer.masksToBounds = false
        AddTopicButton.layer.cornerRadius = 5
        AddTopicButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        AddTopicButton.layer.borderWidth = 1
        AddTopicButton.clipsToBounds = true
        
    }
    
                                                // IBActions
    //Buton "Añadir Tema" Action
    @IBAction func Cancel(_ sender: UIButton) {
        //Check if the Topic is empty
        if TemaTextfield.text != nil && TemaTextfield.text != ""  {
            //Create a local Topic variable and add it to TopicTemp array
            let topicToSend : Topic = Topic()
            topicToSend.Topic = TemaTextfield.text
            topicToSend.Notes = NotasTextView.text
            for image in ImagesToUpload {
                topicToSend.ImagesToUpload.append(image)
            }
            for url in SelectedVideosUrls {
                topicToSend.SelectedVideosUrls.append(url)
            }
            for duration in SelectedVideosDuration {
                topicToSend.SelectedVideosDuration.append(duration)
            }
            for ImgV in SelectedVideosImages {
                topicToSend.SelectedVideosImages.append(ImgV)
            }
            TopicTemp.append(topicToSend)
            //Add topicTemp to UserDefault usign the funcion save of our custom class utilities
            ArchiveUtiliesTopic.savePeople(top: TopicTemp)
            //Call the function ReloadTableViews from InscriptionVC using a notification
            let notificationNme = NSNotification.Name("NotificationIdf")
            NotificationCenter.default.post(name: notificationNme, object: nil)
            //Dismiss the VC
            dismiss(animated: true, completion: nil)
        // if the Topic is Empty...
        } else {
            //Change the BacgroundColor of the textfield, Change the Textcolor of the PlaceHolder and the textfield
            TemaTextfield.backgroundColor = #colorLiteral(red: 0.8459790349, green: 0.2873021364, blue: 0.2579272389, alpha: 1)
            TemaTextfield.attributedPlaceholder = NSAttributedString(string: "Ingrese el Tema...", attributes: [NSForegroundColorAttributeName : UIColor.white])
            TemaTextfield.textColor = UIColor.white
        }
        }
    // Action of the Button in the backgroung of the View
    @IBAction func CancelBg(_ sender: UIButton) {
        //Dismiss the VC
        dismiss(animated: true, completion: nil)
    }
    // Button "Añadir Video" Action
    @IBAction func AddVideo(_ sender: Any) {
        //Call the handler
        HandleVideoPicker()
        //
        DispatchQueue.main.async(execute: {
            //Reload the Data of VideoCollectionView with the selected videos
            self.VideoCollectionView.reloadData()
        })
    }
    //Button "Añadir Imagen" Action
    @IBAction func AddImage(_ sender: UIButton) {
        //Call the handler
        HandleImagePicker()
        //
        DispatchQueue.main.async(execute: {
            //Reload the Data of ImageCollectionView with the selected Images
            self.ImagesCollectionView.reloadData()
        })

    }
    
                                    //DataSource and Delegate Functions
                                            //CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ImagesCollectionView {
            return ImagesToUpload.count
        } else  {
            return SelectedVideosUrls.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ImagesCollectionView {
            let cell = ImagesCollectionView.dequeueReusableCell(withReuseIdentifier: "ImagesId", for: indexPath) as! ImagesCollectionViewCell
            cell.ImageView.image = ImagesToUpload[indexPath.row]
            cell.ImageView.layer.masksToBounds = false
            cell.ImageView.layer.cornerRadius = 5
            cell.ImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.ImageView.layer.borderWidth = 1
            cell.ImageView.clipsToBounds = true
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
            return cell
        } else {
            let cell = VideoCollectionView.dequeueReusableCell(withReuseIdentifier: "VideoId", for: indexPath) as! VideoCollectionViewCell
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
                    self.ImagesCollectionView.reloadData()
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
//                self.SelectedVideosUrls.append(compressedURL)
//                self.SelectedVideosImages.append(generateThumbnailForVideoAtURL(filePathLocal: compressedURL)!)
//                self.SelectedVideosDuration.append(GetDurationOfVideoAtURL(URL: compressedURL)!)

              //  print(info)
                //
//                DispatchQueue.main.async(execute: {
//                    //Reload the Data of VideoCollectionView with the selected Videos
//                    self.VideoCollectionView.reloadData()
//                })
            }
        }
        dismiss(animated: true, completion: nil)
    }

                                    //Functions
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
        self.ImagesCollectionView.endEditing(true)
    }
    
    //Pressed return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TemaTextfield.resignFirstResponder()
        return true
        
    }
    
    
}



