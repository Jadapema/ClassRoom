//
//  Models.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 11/12/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import FirebaseAuth

// will be a struct ********
class Book : NSObject {
    var BookId : String!
    var URL : String!
    var Category : String!
    var Cover : String!
    var Date : String!
    var Description : String!
    var Idiom : String!
    var Name : String!
    var PagesCount : Int!
    var Writer : String!
    
    
    override init() {}
    
    required init(BookId : String,URL : String ,Category : String, Cover:String, Date:String,Description : String, Idiom:String,Name:String,PagesCount : Int,Writer:String) {
        self.BookId = BookId
        self.URL = URL
        self.Category = Category
        self.Cover = Cover
        self.Date = Date
        self.Description = Description
        self.Idiom = Idiom
        self.Name = Name
        self.PagesCount = PagesCount
        self.Writer = Writer
    }
    
    
}

class Message : NSObject {
    var FromId : String!
    var ToId : String!
    var Message : String!
    var Timestamp : Int!
    
    func chatPartnerId() -> String? {
        if FromId == FIRAuth.auth()?.currentUser?.uid {
            return ToId
        } else {
            return FromId
        }
    }
}

// will be a struct ********
class Subject: NSObject {
    var SubId : String!
    var Name: String!
    var Description: String!
    var University : University!
    var Year : Int!
    var Groups : [Group] = []
}

// will be a struct ********
class Group: NSObject {
    var GrId : String!
    var GroupName : String!
    var Members : [User] = []
    var Teacher : String!
    var Topics : [Topic] = []
}

// will be a struct ********
class User: NSObject, NSCoding {
    var Name : String!
    var Email : String!
    var ProfileImageUrl : String!
    var ProfileImage = #imageLiteral(resourceName: "Profile-White")
    var UserId : String!
    var isSelected : Bool!
    
    override init() {}
    
    required init(N:String,E:String,PIU:String,PI:UIImage,UID:String,IS:Bool) {
        Name = N
        Email = E
        ProfileImageUrl = PIU
        ProfileImage = PI
        UserId = UID
        isSelected = IS
    }
    required init(coder aDecoder: NSCoder) {
        Name = aDecoder.decodeObject(forKey: "Name") as? String
        Email = aDecoder.decodeObject(forKey: "Email") as? String
        ProfileImageUrl = aDecoder.decodeObject(forKey: "ProfileImageUrl") as? String
        ProfileImage = (aDecoder.decodeObject(forKey: "ProfileImage") as? UIImage)!
        UserId = aDecoder.decodeObject(forKey: "UserId") as? String
        isSelected = aDecoder.decodeObject(forKey: "isSelected") as? Bool
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(Name, forKey: "Name")
        aCoder.encode(Email, forKey: "Email")
        aCoder.encode(ProfileImageUrl, forKey: "ProfileImageUrl")
        aCoder.encode(ProfileImage, forKey: "ProfileImage")
        aCoder.encode(UserId, forKey: "UserId")
        aCoder.encode(isSelected, forKey: "isSelected")
    }
}


// will be a struct ********
class University : NSObject {
    var Uid : String!
    var Name : String!
    var LogoUrl : String!
    var Motto : String!
    var Longitude : String!
    var Latitude : String!
    
    override init() { }
    
    init(uid:String,name:String) {
        self.Uid = uid
        self.Name = name
    }
}


// will be a struct ********
class Pregunta : NSObject {
    var QuestionID : String!
    var QuestionName : String!
    var Respuestas : [String] = []
}


// will be a struct ********
class Topic : NSObject, NSCoding {
    // Topic Variables
    var Topic : String!
    var TopicId : String!
    var Notes : String!
    var NotesA : [String] = []
    var ImagesUrl : [URL] = []
    var ImagesUrlString : [String] = []
    var ImagesToUpload : [UIImage] = []
    var SelectedVideosUrls : [URL] = []
    var SelectedVideosUrlString : [String] = []
    var SelectedVideosImages : [UIImage] = []
    var SelectedVideosImagesUrlString : [String] = []
    var SelectedVideosDuration : [String] = []
    var Questions : [Pregunta] = []
    
    override init() {}
    
    required init(T:String,N:String,I:[UIImage],SVU:[URL],SVI:[UIImage],SVD:[String]) {
        Topic = T
        Notes = N
        ImagesToUpload = I
        SelectedVideosUrls = SVU
        SelectedVideosImages = SVI
        SelectedVideosDuration = SVD
    }
    required init(coder aDecoder: NSCoder) {
        Topic = aDecoder.decodeObject(forKey: "Topic") as? String
        Notes = aDecoder.decodeObject(forKey: "Notes") as? String
        ImagesToUpload = (aDecoder.decodeObject(forKey: "ImagesToUpload") as? [UIImage])!
        SelectedVideosUrls = (aDecoder.decodeObject(forKey: "SelectedVideosUrls") as? [URL])!
        SelectedVideosImages = (aDecoder.decodeObject(forKey: "SelectedVideosImages") as? [UIImage])!
        SelectedVideosDuration = (aDecoder.decodeObject(forKey: "SelectedVideosDuration") as? [String])!
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(Topic, forKey: "Topic")
        aCoder.encode(Notes, forKey: "Notes")
        aCoder.encode(ImagesToUpload, forKey: "ImagesToUpload")
        aCoder.encode(SelectedVideosUrls, forKey: "SelectedVideosUrls")
        aCoder.encode(SelectedVideosImages, forKey: "SelectedVideosImages")
        aCoder.encode(SelectedVideosDuration, forKey: "SelectedVideosDuration")
    }
}
// It clas will contain the functions to save topic and load topic
class ArchiveUtiliesTopic {
    // Archive our array as NSData
    private static func archiveTopic(Topic : [Topic]) -> NSData {
        return NSKeyedArchiver.archivedData(withRootObject: Topic as NSArray) as NSData
    }
    static func loadTopic() -> [Topic]? {
        if let unarchivedObject = UserDefaults.standard.object(forKey: "Topics") as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? [Topic]
        }
        return nil
    }
    static func savePeople(top : [Topic]?) {
        let archivedObject = archiveTopic(Topic: top!)
        UserDefaults.standard.set(archivedObject, forKey: "Topics")
        UserDefaults.standard.synchronize()
    }
}
// It clas will contain the functions to save topic and load Members
class ArchiveUtiliesMembers {
    // Archive our array as NSData
    private static func archiveMember(Member : [User]) -> NSData {
        return NSKeyedArchiver.archivedData(withRootObject: Member as NSArray) as NSData
    }
    static func loadMembers() -> [User]? {
        if let unarchivedObject = UserDefaults.standard.object(forKey: "Members") as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? [User]
        }
        return nil
    }
    static func saveMembers(Mem : [User]?) {
        let archivedObject = archiveMember(Member: Mem!)
        UserDefaults.standard.set(archivedObject, forKey: "Members")
        UserDefaults.standard.synchronize()
    }
}



let imageCache = NSCache<NSString, AnyObject>()
extension UIImageView {
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        self.image = nil
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            //download hit an error so lets return out
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            })
        }).resume()
    }
}



extension InscriptionViewController: AVCaptureFileOutputRecordingDelegate {
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
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
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
extension PopUpAddClassViewController: AVCaptureFileOutputRecordingDelegate {
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


extension VideoPreviewViewController: AVCaptureFileOutputRecordingDelegate {
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

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}

extension RecordViewController: AVCaptureFileOutputRecordingDelegate
{
    func capture(_ output: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print(outputFileURL)
        let filemainurl = outputFileURL
        
        do
        {
            //            let asset = AVURLAsset(URL: filemainurl!, options: nil)
            let asset = AVURLAsset(url: filemainurl!, options: nil)
            print(asset)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            //            let uiImage = UIImage(CGImage: cgImage)
            let uiImage = UIImage(cgImage: cgImage)
            //            userreponsethumbimageData = NSData(contentsOfURL: filemainurl!)!
            do {
                userreponsethumbimageData = try NSData(contentsOf: filemainurl!)
                print(userreponsethumbimageData.length)
                print(uiImage)
                VideoImage = uiImage
            } catch {
                print(error)
            }
            // imageData = UIImageJPEGRepresentation(uiImage, 0.1)
        }
        catch let error as NSError
        {
            print(error)
            return
        }
        
        // SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Clear)
        
        
        //        let VideoFilePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("mergeVideo\(arc4random()%1000)d")!.URLByAppendingPathExtension("mp4")!.absoluteString
        let VideoFilePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("mergeVideo\(arc4random()%1000)d")!.appendingPathExtension("mp4").absoluteString
        
        if FileManager.default.fileExists(atPath: VideoFilePath)
            
        {
            do
                
            {
                try FileManager.default.removeItem(atPath: VideoFilePath)
            }
            catch { }
            
        }
        let tempfilemainurl =  NSURL(string: VideoFilePath)!
        let sourceAsset = AVURLAsset(url: filemainurl!, options: nil)
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: sourceAsset, presetName: AVAssetExportPresetMediumQuality)!
        assetExport.outputFileType = AVFileTypeQuickTimeMovie
        assetExport.outputURL = tempfilemainurl as URL
        assetExport.exportAsynchronously { () -> Void in
            switch assetExport.status
            {
            case AVAssetExportSessionStatus.completed:
                DispatchQueue.main.async(execute: {
                    do
                    {
                        //SVProgressHUD.dismiss()
                        self.userreponsevideoData = try NSData(contentsOf: tempfilemainurl as URL, options: NSData.ReadingOptions())
                        print("MB - \(self.userreponsevideoData.length) byte")
                        self.performSegue(withIdentifier: "ShowPreviewVideo", sender: nil)
                        
                    }
                    catch
                    {
                        // SVProgressHUD.dismiss()
                        print(error)
                    }
                })
            case  AVAssetExportSessionStatus.failed:
                print("failed \(String(describing: assetExport.error))")
            case AVAssetExportSessionStatus.cancelled:
                print("cancelled \(String(describing: assetExport.error))")
            default:
                print("complete")
                // SVProgressHUD .dismiss()
            }
            
        }
    }
    
    //    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: URL!, fromConnections connections: [AnyObject]!) {
    //        print(fileURL)
    //    }
    func capture(_ output: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        print("Lo que busco : \(fileURL)")
        VideoUrl = fileURL
        
    }
    
    //    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
    //        print(outputFileURL)
    //        let filemainurl = outputFileURL
    //
    //        do
    //        {
    //            let asset = AVURLAsset(URL: filemainurl, options: nil)
    //            print(asset)
    //            let imgGenerator = AVAssetImageGenerator(asset: asset)
    //            imgGenerator.appliesPreferredTrackTransform = true
    //            let cgImage = try imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
    //            let uiImage = UIImage(CGImage: cgImage)
    //            userreponsethumbimageData = NSData(contentsOfURL: filemainurl)!
    //            print(userreponsethumbimageData.length)
    //            print(uiImage)
    //            // imageData = UIImageJPEGRepresentation(uiImage, 0.1)
    //        }
    //        catch let error as NSError
    //        {
    //            print(error)
    //            return
    //        }
    //
    //        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Clear)
    //        let VideoFilePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("mergeVideo\(arc4random()%1000)d")!.URLByAppendingPathExtension("mp4")!.absoluteString
    //
    //        if NSFileManager.defaultManager().fileExistsAtPath(VideoFilePath!)
    //
    //        {
    //            do
    //
    //            {
    //                try NSFileManager.defaultManager().removeItemAtPath(VideoFilePath!)
    //            }
    //            catch { }
    //
    //        }
    //        let tempfilemainurl =  NSURL(string: VideoFilePath!)!
    //        let sourceAsset = AVURLAsset(URL: filemainurl!, options: nil)
    //        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: sourceAsset, presetName: AVAssetExportPresetMediumQuality)!
    //        assetExport.outputFileType = AVFileTypeQuickTimeMovie
    //        assetExport.outputURL = tempfilemainurl
    //        assetExport.exportAsynchronouslyWithCompletionHandler { () -> Void in
    //            switch assetExport.status
    //            {
    //            case AVAssetExportSessionStatus.Completed:
    //                dispatch_async(dispatch_get_main_queue(),
    //                               {
    //                                do
    //                                {
    //                                    SVProgressHUD .dismiss()
    //                                    self.userreponsevideoData = try NSData(contentsOfURL: tempfilemainurl, options: NSDataReadingOptions())
    //                                    print("MB - \(self.userreponsevideoData.length) byte")
    //
    //
    //                                }
    //                                catch
    //                                {
    //                                    SVProgressHUD .dismiss()
    //                                    print(error)
    //                                }
    //                })
    //            case  AVAssetExportSessionStatus.Failed:
    //                print("failed \(assetExport.error)")
    //            case AVAssetExportSessionStatus.Cancelled:
    //                print("cancelled \(assetExport.error)")
    //            default:
    //                print("complete")
    //                SVProgressHUD .dismiss()
    //            }
    //
    //        }
    //    }
    
}


