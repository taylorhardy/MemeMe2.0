//
//  MemeItemsViewController.swift
//  MemeMe
//
//  Created by Hardy, Taylor J on 5/20/16.
//  Copyright © 2016 Hardy, Taylor J. All rights reserved.
//

import UIKit

class MemeItemsViewController: UIViewController {
    
    let CollectionCellsPerRowLandscape = 5
    let CollectionCellsPerRowPortrait = 3

    let CollectionCellSpacing = 2

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var collectionView: UICollectionView?
    
    var memes: [Meme]?

    var shouldSegueToEditor = false
    
    var editMode: Bool = false {
        didSet {
            editModeChanged()
        }
    }
    
    var defaultCount: Int?
    var collectionCellCountPerRow: Int {
        let orientation = UIDevice.currentDevice().orientation
        switch orientation {
        case .LandscapeLeft, .LandscapeRight:
            defaultCount = CollectionCellsPerRowLandscape
            return CollectionCellsPerRowLandscape
        case .Portrait:
            defaultCount = CollectionCellsPerRowPortrait
            return CollectionCellsPerRowPortrait
        default:
            return defaultCount ?? CollectionCellsPerRowPortrait
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = produceEditButton()
        navigationItem.rightBarButtonItem = produceAddMemeButton()
        
        reloadMemesFromSource()
        
        if let count = memes?.count where count == 0 {
                shouldSegueToEditor = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        if editMode {
            disableEditModeAction(self)
        }
        
        reloadMemesFromSource()
        refreshMemesDisplay()
        
        navigationItem.leftBarButtonItem?.enabled = memes?.count > 0
    }
    
    override func viewDidAppear(animated: Bool) {
            if shouldSegueToEditor {
            shouldSegueToEditor = false
            performSegueWithIdentifier("MemeEditorSegue", sender: self)
        }
    }
    
    override func viewWillLayoutSubviews() {
        calculateCollectionCellSize()
    }
    
     func calculateCollectionCellSize() {
        if let collectionView = collectionView {
            let width = collectionView.frame.width / CGFloat(collectionCellCountPerRow) - CGFloat(CollectionCellSpacing)
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.itemSize = CGSize(width: width, height: width)
        }
    }
    
    func addMemeAction(sender: AnyObject!) {
        performSegueWithIdentifier("MemeEditorSegue", sender: self)
    }
    
    func enableEditModeAction(sender: AnyObject!) {
        editMode = true
        navigationItem.leftBarButtonItem = produceCancelButton()
        navigationItem.rightBarButtonItem = produceDeleteButton()
        navigationItem.rightBarButtonItem?.enabled = false
        editModeChanged()
    }
    
    func disableEditModeAction(sender: AnyObject!) {
        editMode = false
        navigationItem.leftBarButtonItem = produceEditButton()
        navigationItem.rightBarButtonItem = produceAddMemeButton()
        editModeChanged()
    }

    func deleteSelectedMemesAction(sender: AnyObject!) {
        let selected = selectedMemes()
        if let newMemes = memes?.filter({ !selected.contains($0) }) {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes = newMemes
            memes = appDelegate.memes
            disableEditModeAction(self)
            refreshMemesDisplay()
        }
    }
    
    func reloadMemesFromSource() {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    func deleteSingleMemeAtIndex(index: Int) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(index)
        memes = appDelegate.memes
        refreshMemesDisplay()
    }
    
    func memesAtPaths(indexPaths: [NSIndexPath]?) -> [Meme] {
        var result: [Meme] = [Meme]()
        if let indexPaths = indexPaths, memes = memes {
            result = indexPaths.map() { memes[$0.item] }
        }
        return result
    }
    
    
    func handleSelectionEventForMemeAtIndex(index: Int) {
        if let memes = memes where !editMode && index < memes.count {
            let meme = memes[index]
            let singleMemeViewer = storyboard?.instantiateViewControllerWithIdentifier("MemeStaticViewer") as! SingleMemeViewController
            singleMemeViewer.meme = meme
            navigationController?.pushViewController(singleMemeViewer, animated: true)
        } else {
            selectionChanged()
        }
        
    }
    
    func handleDeselectionEventForMemeAtIndex(index: Int) {
        selectionChanged()
    }
    
    func selectionChanged() {
        if (editMode) {
            navigationItem.rightBarButtonItem?.enabled = selectedMemes().count > 0
        }
    }
    
    func produceAddMemeButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addMemeAction:")
    }
    
    func produceEditButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "enableEditModeAction:")
    }
    
    func produceCancelButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "disableEditModeAction:")
    }
    
    func produceDeleteButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteSelectedMemesAction:")
    }
    
    
    func refreshMemesDisplay() {
        tableView?.reloadData()
        collectionView?.reloadData()
    }
    
    func editModeChanged() {
        if let tableView = tableView {
            tableView.allowsMultipleSelection = editMode
            tableView.editing = editMode
        } else if let collectionView = collectionView {
            collectionView.allowsMultipleSelection = editMode
            if (!editMode) {
                if let indexPaths = collectionView.indexPathsForSelectedItems() {
                    for indexPath in indexPaths {
                        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
                    }
                }
            }
        }
    }
    
    func selectedMemes() -> [Meme] {
        if let tableView = tableView,
            indexPaths = tableView.indexPathsForSelectedRows {
            return memesAtPaths(indexPaths)
        } else if let collectionView = collectionView,
            indexPaths = collectionView.indexPathsForSelectedItems() {
            return memesAtPaths(indexPaths)
        } else {
            return [Meme]()
        }
    }
}

extension MemeItemsViewController: UITableViewDelegate {

    // On row selection, displays the static meme viewer containing the memed image.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        handleSelectionEventForMemeAtIndex(indexPath.item)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        handleDeselectionEventForMemeAtIndex(indexPath.item)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            deleteSingleMemeAtIndex(indexPath.item)
        }
    }
}

extension MemeItemsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let meme = memes?[indexPath.item]
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableItem", forIndexPath: indexPath) as! MemeTableViewCell
        cell.meme = meme
        return cell
    }
}

extension MemeItemsViewController: UICollectionViewDelegate {
    // On cell selection displays the static meme viewer.
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        handleSelectionEventForMemeAtIndex(indexPath.item)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        handleDeselectionEventForMemeAtIndex(indexPath.item)
    }
}


extension MemeItemsViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionItem", forIndexPath: indexPath) as! MemeCollectionViewCell
            cell.meme = memes?[indexPath.item]
            return cell
    }
}




