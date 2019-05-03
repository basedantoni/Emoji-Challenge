//
//  Post.swift
//  Emoji Challenge
//
//  Created by Anthony Mercado on 5/3/19.
//  Copyright © 2019 COSC 3326. All rights reserved.
//

import Foundation
import Firebase

struct Post {
    
    let emoji: String
    let path: String
    let title: String
    
    init() {
        emoji = "\u{1F603}"
        path = "images/default.jpg"
        title = "default"
    }
    
    init(postEmoji: String, postPath: String, postTitle: String) {
        emoji = postEmoji
        path = postPath
        title = postTitle
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let emoji = value["emoji"] as? String,
            let path = value["path"] as? String,
            let title = value["title"] as? String else {
                return nil
        }
        self.emoji = emoji
        self.path = path
        self.title = title
    }
    
    func toAnyObject() -> NSDictionary {
        let dict: NSDictionary = ["emoji" : emoji, "path" : path, "title" : title]
        
        return dict
    }
    
    func getPath() -> String {
        return path
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getEmoji() -> String {
        return emoji
    }
}
