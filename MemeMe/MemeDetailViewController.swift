//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Gaurav Saraf on 10/8/16.
//  Copyright © 2016 Gaurav Saraf. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    var shouldHideNavBar: Bool = true
    
    @IBOutlet weak var imageView: UIImageView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme.memedImage
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first
        
        if touch?.phase == UITouchPhase.began {
            navigationController?.setNavigationBarHidden(shouldHideNavBar, animated: true)
            shouldHideNavBar = !shouldHideNavBar
        }
    }
    
    @IBAction func editButtonPressed(_ sender: AnyObject) {
        let memeEditor = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        memeEditor.isEditingMeme = true
        memeEditor.imageToEdit = meme.originalImage
        navigationController?.setNavigationBarHidden(false, animated: true)
        present(memeEditor, animated: true, completion: nil)
    }
}
