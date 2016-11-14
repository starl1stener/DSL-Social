//
//  PostCell.swift
//  Nag Social
//
//  Created by nag on 13/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

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

    func configureCell(post: Post) {
        
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
    }

}
