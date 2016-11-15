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


    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureCell(post: Post, image: UIImage? = nil) {
        
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        
        if image != nil {
            self.postImg.image = image
        } else {
            
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
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
    }

}













