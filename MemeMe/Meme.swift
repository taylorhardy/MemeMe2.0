//
//  Meme.swift
//  MemeMe
//
//  Created by Hardy, Taylor J on 5/20/16.
//  Copyright © 2016 Hardy, Taylor J. All rights reserved.
//

import UIKit

class Meme: NSObject {
    var topText: String
    var bottomText: String
    var image: UIImage
    var memedImage: UIImage?
    var scaledAndCroppedImage: UIImage?
    
    init(topText: String, bottomText: String, image: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = image
    }
}