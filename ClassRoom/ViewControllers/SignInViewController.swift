//
//  SignInViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 16/8/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignInViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    //Outlets
    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var ProfileImage: UIImageView!
    //Variables
    var ProfileImageUrl : String?
    var mainRef : FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
                                                //BeforeView Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        email.delegate = self
        password.delegate = self
        ProfileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImagePicker)))
        ProfileImage.isUserInteractionEnabled = true
        ProfileImage.image = #imageLiteral(resourceName: "Profile-White")
    }

                                                // IBActions
    //Button "Registrarse" Action
    @IBAction func SignIn(_ sender: UIButton) {
        //Create User in Database
        FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
            //Check if the user exist
            if user != nil {
                //User created Sucessfully
                print("User Created Sucessfully")
                //Reference to Profile
                let profileRef = self.mainRef.child("Users").child((user?.uid)!).child("Profile")
                //Add Name and Email here, then the profileImage is uploaded
                profileRef.child("Name").setValue("\(self.name.text!)")
                profileRef.child("Email").setValue("\(self.email.text!)")
                //Reference to Storage
                let StorageRef = FIRStorage.storage().reference(forURL: "gs://classroom-19991.appspot.com/").child("Users_Profile_Image").child("\(self.randomAlphaNumericString(length: 10)).jpg")
                //We create a PNG Representation of the image to upload
                if let image = self.ProfileImage.image, let UploadData = UIImageJPEGRepresentation(image, 0.1) {
                    //Upload the image to the storage
                    StorageRef.put(UploadData, metadata: nil, completion: { (Metadata, error) in
                        if error != nil {
                            print(error!)
                        } else {
                                //Image Uploaded
                            //Get the download url of the image uploaded
                            if let ImageUploadedUrl = Metadata?.downloadURL()?.absoluteString {
                                //once the image is uploaded we upload the data again but with the imageUrl
                                let profileRef = self.mainRef.child("Users").child((user?.uid)!).child("Profile")
                                profileRef.child("Name").setValue("\(self.name.text!)")
                                profileRef.child("Email").setValue("\(self.email.text!)")
                                profileRef.child("ProfileImageUrl").setValue("\(ImageUploadedUrl)")
                            }
                        }
                    })
                }
                //Present LogInVC
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let LogInViewController = storyboard.instantiateViewController(withIdentifier: "LogIn")
                self.present(LogInViewController, animated: true, completion: nil)
            } else {
                if let myError = error?.localizedDescription {
                    print(myError)
                } else {
                    print("Error")
                }
            }
        })
    }
    //Button "Inicial Sesion Con Facebook" Action
    @IBAction func SignInFacebook(_ sender: UIButton) {
    }
    
                                    //DataSource and Delegate Functions
                                            //ImagePicker
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
            ProfileImage.layer.borderWidth = 1
            ProfileImage.layer.borderColor = UIColor.white.cgColor
            ProfileImage.layer.masksToBounds = false
            ProfileImage.layer.cornerRadius = ProfileImage.frame.height/2
            ProfileImage.clipsToBounds = true
            ProfileImage.contentMode = .scaleAspectFill
            ProfileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
                                    //Functions
    // Handler imagepicker
    func handleProfileImagePicker () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    //Return a random Alphanumeric Number With a length
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
    //Hide Keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        name.resignFirstResponder()
        email.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
}
