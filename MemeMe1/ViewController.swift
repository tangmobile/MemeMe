//
//  ViewController.swift
//  MemeMe1
//
//  Created by Lee Tang on 9/30/15.
//  Copyright © 2015 Lee Tang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    
    struct Meme {
        
        var topField: String
        var bottomField: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        topTextField.placeholder = "TOP"
        bottomTextField.textAlignment = .Center
        bottomTextField.placeholder = "BOTTOM"
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        shareButton.enabled = false
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
        self.subscribeToKeyboardHideNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.unsubscribeFromKeyboardNotifications()
        self.unsubscribeFromKeyboardHideNotifications()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.contentMode = .ScaleAspectFit
            self.imagePickerView.image = image
            shareButton.enabled = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // Text Field Delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        return true
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        topTextField.placeholder = nil
        bottomTextField.placeholder = nil
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 3
    ]
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
    }
    
    
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    
    
    func subscribeToKeyboardHideNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    
    func unsubscribeFromKeyboardHideNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
        print(getKeyboardHeight(notification))
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
        print(getKeyboardHeight(notification))
        
    }
    
    
    
//    func save(memedImage: UIImage) {
//        
//        //create the meme
//        Meme(topField: topTextField.text!, bottomField: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
//        
//    }
    
    
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        // TODO:  Show toolbar and navbar
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        return memedImage
        
    }
    
    
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        let memedImage = [self.generateMemedImage()]
        let activityVC = UIActivityViewController(activityItems: memedImage, applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
        
    }
    
    
}


