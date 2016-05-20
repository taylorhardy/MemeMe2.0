//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Hardy, Taylor J on 5/20/16.
//  Copyright © 2016 Hardy, Taylor J. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var topLabel: UILabel?
    @IBOutlet weak var bottomLabel: UILabel?
    @IBOutlet weak var selectionImage: UIImageView?
    
    var meme: Meme? {
        didSet {
            if let meme = meme {
                imageView?.image = meme.scaledAndCroppedImage ?? meme.image
                topLabel?.text = meme.topText
                bottomLabel?.text = meme.bottomText
            }
        }
    }
    
    override var selected: Bool {
        didSet {
            selectionImage?.hidden = !selected
        }
    }
        
}
