//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Hardy, Taylor J on 5/20/16.
//  Copyright © 2016 Hardy, Taylor J. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeLabel: UILabel?
    @IBOutlet weak var memeImageView: UIImageView? {
        didSet {
            if storeColorChange {
                originallyConfiguredColor = memeImageView?.backgroundColor
            }
        }
    }
    
    var originallyConfiguredColor: UIColor? {
        didSet {
            storeColorChange = false
        }
    }
    
    var storeColorChange = true
    
    var meme: Meme? {
        didSet {
            if let meme = meme {
                memeImageView?.image = meme.memedImage
                memeLabel?.text = "\(meme.topText) \(meme.bottomText)"
            }
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            memeImageView?.backgroundColor = originallyConfiguredColor
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            memeImageView?.backgroundColor = originallyConfiguredColor
        }
    }
}
