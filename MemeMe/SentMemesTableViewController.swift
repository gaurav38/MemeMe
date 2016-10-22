//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Gaurav Saraf on 10/8/16.
//  Copyright © 2016 Gaurav Saraf. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return appDelegate.memes
    }
    @IBOutlet weak var editButton: UIBarButtonItem!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if memes.count == 0 {
            createNewMeme()
        } else {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.setEditing(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")! as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        cell.tableViewCellImageView.image = meme.originalImage
        cell.tableViewCellTopText.text = meme.topText
        cell.tableViewCellBottomText.text = meme.bottomText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailsViewController.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.editButton.title = "Edit"
        }
    }
    
    @IBAction func createNewMeme() {
        let memeEditor = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        self.present(memeEditor, animated: true, completion: nil)
    }
    
    @IBAction func editButtonPressed() {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        self.editButton.title = self.tableView.isEditing ? "Cancel" : "Edit"
    }
}
