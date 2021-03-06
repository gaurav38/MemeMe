//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Gaurav Saraf on 10/7/16.
//  Copyright © 2016 Gaurav Saraf. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {

    var memes = [Meme]()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var selectedMemeIndex = 0
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memes = appDelegate.memes
        updateItemSizeBasedOnOrientation()
        subscribeToOrientationChangeNotification()
        collectionView?.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToOrientationChangeNotification()
    }
    
    func updateItemSizeBasedOnOrientation()
    {
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        let space: CGFloat = 3.0
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            width = (view.frame.size.width - (2 * space)) / 3.0
            height = (view.frame.size.height - (4 * space)) / 5.0
        } else if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            width = (view.frame.size.width - (4 * space)) / 5.0
            height = (view.frame.size.height - (2 * space)) / 3.0
        }
        if height > 0 && width > 0 {
            var itemSize: CGSize = CGSize()
            itemSize.height = height
            itemSize.width = width
        
            flowLayout.minimumInteritemSpacing = space
            flowLayout.itemSize = itemSize
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemesCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.imageView.image = meme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailsViewController.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func subscribeToOrientationChangeNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(updateItemSizeBasedOnOrientation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func unsubscribeToOrientationChangeNotification()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @IBAction func createNewMeme(_ sender: AnyObject) {
        let memeEditor = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        present(memeEditor, animated: true, completion: nil)
    }
}
