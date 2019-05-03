//
//  HomeViewController.swift
//  Emoji Challenge
//
//  Created by Anthony Mercado on 4/25/19.
//  Copyright © 2019 COSC 3326. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class imageCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblEmoji: UILabel!
    
    @IBOutlet weak var imgPost: UIImageView!
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts: [Post] = []
    let ref = Database.database().reference()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.child("posts").observe(.value, with: { snapshot in
            var newPosts: [Post] = []
            for child in snapshot.children {
                print(child)
                if let snapshot = child as? DataSnapshot,
                    let post = Post(snapshot: snapshot) {
                    newPosts.append(post)
                }
            }
            self.posts = newPosts
            self.tableView.reloadData()
        })
    } // End of viewDidLoad
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! imageCell
        
        let post = posts[indexPath.row]
        
        var imageReference: StorageReference {
            return Storage.storage().reference().child("images")
        }
        
        let downloadImageRef = imageReference.child("\(post.getTitle()).jpg")
        
        let downloadTask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                cell.imgPost.image = image
            }
            print(error ?? "NO ERROR")
        }

        cell.lblTitle.text = post.title

        cell.lblEmoji.text = decode(post.emoji)

        return cell
    }
    
    func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    
    func getPhoto(title: String) -> UIImage {
        
        var imageReference: StorageReference {
            return Storage.storage().reference().child("images")
        }
        
        let downloadImageRef = imageReference.child("\(title).jpg")
        var returnImg = UIImage()
        
        let downloadTask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                returnImg = image!
            }
            print(error ?? "NO ERROR")
        }
        return returnImg
    }
    
}

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self as? UITabBarControllerDelegate
        
        tabBar.unselectedItemTintColor = .black
    }
    
}
