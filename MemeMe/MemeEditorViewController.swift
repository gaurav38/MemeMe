//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Gaurav Saraf on 10/7/16.
//  Copyright © 2016 Gaurav Saraf. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var TopTextFieldVerticalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var BottomTextFieldVerticalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let defaultTopTextFieldText = "TOP"
    let defaultBottomTextFieldText = "BOTTOM"
    var pickerViewData = ["HelveticaNeue-CondensedBlack"]
    
    var isEditingMeme = false
    var imageToEdit: UIImage!
    var screenScrolledUp = false
    var memedImage:UIImage!
    var isShowingFontPicker = false
    
    var memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name : "HelveticaNeue-CondensedBlack", size : 40)!,
        NSStrokeWidthAttributeName : -3.6] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextFieldsAppearances(textField: topTextField)
        updateTextFieldsAppearances(textField: bottomTextField)
        if isEditingMeme {
            imageView.image = imageToEdit
            navigationBar.isHidden = false
        }
        pickerView.delegate = self
        pickerView.dataSource = self
        for familyName in UIFont.familyNames as [String] {
            for fontName in UIFont.fontNames(forFamilyName: familyName) as [String] {
                pickerViewData.append(fontName)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateConstraintsBasedOnOrientation()
        subscribeToNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        shareButton.isEnabled = imageView.image != nil
        pickerView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromNotifications()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func updateTextFieldsAppearances(textField: UITextField)
    {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.borderStyle = UITextBorderStyle(rawValue: 0)!
        resetTextFields()
    }
    
    func resetTextFields() {
        topTextField.text = defaultTopTextFieldText
        bottomTextField.text = defaultBottomTextFieldText
    }
    
    // MARK: Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first
        if touch?.phase == UITouchPhase.began {
            if topTextField.isFirstResponder {
                topTextField.resignFirstResponder()
            } else if bottomTextField.isFirstResponder {
                bottomTextField.resignFirstResponder()
            }
        }
    }
    
    // MARK: UIImagePickerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == defaultTopTextFieldText || textField.text == defaultBottomTextFieldText {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Pick image IBActions
    
    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        pickImageFromSource(sourceType: UIImagePickerControllerSourceType.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {
        pickImageFromSource(sourceType: UIImagePickerControllerSourceType.camera)
        
    }
    
    func pickImageFromSource(sourceType: UIImagePickerControllerSourceType)
    {
        resetTextFields()
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: AnyObject) {
        generateMemedImage()
        let activityViewContoller: UIActivityViewController
        activityViewContoller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewContoller.completionWithItemsHandler = {
            activity, success, items, error in
            if success {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityViewContoller, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // Move the view when the keyboard covers the text field
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isEditing {
            self.view.frame.origin.y = getKeyboardHeight(notification: notification) * (-1)
            screenScrolledUp = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if screenScrolledUp {
            self.view.frame.origin.y = 0
            screenScrolledUp = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func updateConstraintsBasedOnOrientation()
    {
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            TopTextFieldVerticalSpacingConstraint.constant = 55
            BottomTextFieldVerticalSpacingConstraint.constant = 55
        }
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            TopTextFieldVerticalSpacingConstraint.constant = 25
            BottomTextFieldVerticalSpacingConstraint.constant = 25
        }
    }
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateConstraintsBasedOnOrientation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func generateMemedImage() {
        toolBar.isHidden = true
        navigationBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        navigationBar.isHidden = false
        toolBar.isHidden = false
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: self.memedImage)
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    // MARK: UIPickerView delegates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let fontName = pickerViewData[row]
        let myTitle = NSAttributedString(string: fontName, attributes: [NSFontAttributeName:UIFont(name: fontName, size: 15.0)!,NSForegroundColorAttributeName:UIColor.blue])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        memeTextAttributes[NSFontAttributeName] = UIFont(name: pickerViewData[row], size: 40)
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.center
        bottomTextField.textAlignment = NSTextAlignment.center
    }
    
    @IBAction func selectFontButtonPressed(_ sender: AnyObject) {
        if isShowingFontPicker {
            pickerView.isHidden = true
            topTextField.isHidden = false
            imageView.isHidden = false
            bottomTextField.isHidden = false
        } else {
            pickerView.isHidden = false
            topTextField.isHidden = true
            imageView.isHidden = true
            bottomTextField.isHidden = true
        }
        isShowingFontPicker = !isShowingFontPicker
    }
    

}

