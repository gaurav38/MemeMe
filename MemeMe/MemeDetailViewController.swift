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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = meme.originalImage
        topText.text = meme.topText
        bottomText.text = meme.bottomText
    }
}
