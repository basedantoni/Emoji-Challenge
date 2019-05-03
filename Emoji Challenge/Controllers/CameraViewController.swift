//
//  CameraViewController.swift
//  Emoji Challenge
//
//  Created by Anthony Mercado on 4/25/19.
//  Copyright © 2019 COSC 3326. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class CameraViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtEmoji: UITextField!
    
    // Taking Picture
    var imagePicker: UIImagePickerController!
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        uploadImage.image = info[.originalImage] as? UIImage
    }
    // Upload Photo
    @IBOutlet weak var uploadImage: UIImageView!
    
    // Firebase storage reference to images folder
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    // Uploads image to the firebase storage
    @IBAction func btnUploadPhoto(_ sender: UIButton) {
        guard let image = uploadImage.image else {return}
        guard let imageData = image.jpegData(compressionQuality: 0) else {return}
        
        let filename: String = image.accessibilityIdentifier ?? txtTitle.text!

        let uploadImageReference = imageReference.child("\(filename).jpg")

        let uploadTask = uploadImageReference.putData(imageData, metadata: nil) { (metadata, error) in
            print("UPLOAD TASK FINISHED")
            print(metadata ?? "NO METADATA")
            print(error ?? "NO ERROR")
        }

        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO PROGRESS")
        }

        uploadTask.resume()
    }
    
    let ref = Database.database().reference(withPath: "posts")
    
    @IBAction func btnUploadToDatabase(_ sender: UIButton) {
        let title = txtTitle.text!
        let emoji = txtEmoji.text!
        let path = "images/\(title).jpg"
        let encoded = encode(emoji)
        
        let post = Post(postEmoji: encoded, postPath: path, postTitle: title)
        
        let postRef = ref.child(title.lowercased())
        
        postRef.setValue(post.toAnyObject())
    }
    
    func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
