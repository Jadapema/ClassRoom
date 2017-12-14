//
//  Controllers.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 13/12/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class FirebaseController {
    
    var UtilitiesRef = Utilities()
    
    // Main Reference to Firebase Database
    var mainDbRef : FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    // Main reference to Firebase Storage
    var mainStRef : FIRStorageReference {
        return FIRStorage.storage().reference(forURL: "gs://classroom-19991.appspot.com/")
    }
    
    // Login with a Email, Password and a CompletionHandler
    public func Login (email : String, password : String, completion : @escaping () -> Void)  {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            //Check if the User Exist
            if user != nil {
                // Login Successfully
                completion()
                
            } else {
                if let myError = error?.localizedDescription {
                    print(myError)
                } else {
                    print("Error in Auth Section")
                }
            }
        })
    }
    
    // Register a user in Firebase Auth and save the data in the database
    public func Signin (name: String, email : String, password: String, profileImg : UIImage, completion : @escaping () -> Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password , completion: { (user, error) in
            //Check if the user exist
            if user != nil {
                //User created Sucessfully
                print("User Created Sucessfully")
                //Reference to Profile
                let profileRef = self.mainDbRef.child("Users").child((user?.uid)!).child("Profile")
                //Add Name and Email here, then the profileImage is uploaded
                profileRef.child("Name").setValue("\(name)")
                profileRef.child("Email").setValue("\(email)")
                // Reference to random image url Storage
                let imgStRef = self.mainStRef.child("Users_Profile_Image").child("\(self.UtilitiesRef.randomAlphaNumericString(length: 10)).jpg")
                //We create a PNG Representation of the image to upload
                if let UploadData = UIImageJPEGRepresentation(profileImg, 0.1) {
                    //Upload the image to the storage
                    imgStRef.put(UploadData, metadata: nil, completion: { (Metadata, error) in
                        // Check for any error
                        if error != nil {
                            print(error!)
                        } else {
                            //Image Uploaded
                            //Get the download url of the image uploaded
                            if let ImageUploadedUrl = Metadata?.downloadURL()?.absoluteString {
                                //once the image is uploaded we upload the data again but with the imageUrl
                                profileRef.child("Name").setValue("\(name)")
                                profileRef.child("Email").setValue("\(email)")
                                profileRef.child("ProfileImageUrl").setValue("\(ImageUploadedUrl)")
                            }
                        }
                    })
                }
                completion()
            } else {
                if let myError = error?.localizedDescription {
                    print(myError)
                } else {
                    print("Error")
                }
            }
        })
    }
    
    
    
}


class Utilities {
    
    //Return a random Alphanumeric Number With a length
    public func randomAlphaNumericString(length: Int) -> String {
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
