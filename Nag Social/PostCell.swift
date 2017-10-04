//
//  PostCell.swift
//  Nag Social
//
//  Created by nag on 13/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!

    var post: Post!
    var likesRef: DatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        
        tapGesture.numberOfTapsRequired = 1
        
        likeImg.addGestureRecognizer(tapGesture)
        
        likeImg.isUserInteractionEnabled = true
    }

    func configureCell(post: Post, image: UIImage? = nil) {
        
        self.likeImg.image = UIImage(named: "empty-heart")
        
        likesRef = DataService.sharedDataService.REF_USER_CURRENT.child("likes").child(post.postKey)

        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        
        if image != nil {
            self.postImg.image = image
        } else {
            
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                if error != nil {
                    print("===NAG=== Unable to download image from Firebase storage")
                } else {
                    print("===NAG=== Image downloaded from Firebase storage")

                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
            
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
                
            } else {
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }
}

