//
//  SingleMemeViewController.swift
//  MemeMe
//
//  Created by Hardy, Taylor J on 5/20/16.
//  Copyright © 2016 Hardy, Taylor J. All rights reserved.
//

import UIKit

class SingleMemeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
  
    var meme: Meme?
    
    override func viewDidLoad() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        view.addGestureRecognizer(tapRecognizer)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteMemeAction:")
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMemeAction:"))
    }
    
    override func viewWillAppear(animated: Bool) {
        imageView.image = meme?.memedImage
        if let meme = meme {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            if !appDelegate.memes.contains(meme) {
                navigationController?.popViewControllerAnimated(true)
            }
        }
    }

    func deleteMemeAction(sender: AnyObject!) {
        if let meme  = meme {
            deleteMeme(meme)
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    func editMemeAction(sender: AnyObject) {
        performSegueWithIdentifier("MemeEditorSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let editorVC = segue.destinationViewController as? MemeEditorViewController {
            editorVC.meme = meme
        }
    }

    func handleTap(sender: UIGestureRecognizer) {
        if sender.state == .Ended {
            if let navBarState = navigationController?.navigationBarHidden {
                navigationController?.setNavigationBarHidden(!navBarState, animated:true)
                // animate background color change
                UIView.animateWithDuration(0.35,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: { self.toggleBackGroundColor(!navBarState) },
                    completion: nil)
            }
            if let tabBarController = tabBarController {
                UIView.transitionWithView(self.view,
                    duration: 0.35,
                    options: [UIViewAnimationOptions.LayoutSubviews, UIViewAnimationOptions.CurveEaseIn],
                    animations: { tabBarController.tabBar.hidden = !tabBarController.tabBar.hidden },
                    completion: nil)
            }
        }
    }
    func toggleBackGroundColor(state: Bool) {
        view.backgroundColor = state ? UIColor.blackColor() : UIColor.whiteColor()
    }
    
    private func deleteMeme(meme: Meme) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        if let index = appDelegate.memes.indexOf(meme) {
            appDelegate.memes.removeAtIndex(index)
        }
    }
    
}
