//
//  CircleView.swift
//  Nag Social
//
//  Created by Anton Novoselov on 13/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
