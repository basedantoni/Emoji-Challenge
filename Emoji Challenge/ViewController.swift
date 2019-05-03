//
//  ViewController.swift
//  Emoji Challenge
//
//  Created by Anthony Mercado on 4/16/19.
//  Copyright © 2019 COSC 3326. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        
        let db = Firestore.firestore()
        //Querying for users with name == 'jared'
        db.collection("users").whereField("firstName", isEqualTo: "jared").getDocuments { (snapshot, error) in
            if(error != nil) {
                print("ERROR: \(error)")
            }
            else {
                for document in ((snapshot?.documents)!) {
                    
                    if let name = document.data()["name"] as? String {
                        print("NAME: \(name)")
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var downloadImage: UIImageView!
    
    let filename = "liluzi.jpg"
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    @IBAction func onUploadTapped() {
        guard let image = uploadImage.image else {return}
        guard let imageData = image.jpegData(compressionQuality: 0) else {return}
        
        let uploadImageReference = imageReference.child(filename)
        
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
    
    @IBAction func onDownloadTapped() {
        let downloadImageReference = imageReference.child(filename)
        
        let downloadTask = downloadImageReference.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                self.downloadImage.image = image
            }
            print(error ?? "NO ERROR")
        }
        
        downloadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO PROGRESS")
        }
        
        downloadTask.resume()
    }
}

