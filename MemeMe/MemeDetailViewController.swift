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
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = meme.memedImage
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first
        
        if touch?.phase == UITouchPhase.began {
            self.navigationController?.setNavigationBarHidden(shouldHideNavBar, animated: true)
            shouldHideNavBar = !shouldHideNavBar
        }
    }
}
