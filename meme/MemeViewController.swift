//
//  ViewController.swift
//  meme
//
//  Created by Ming Hu on 3/29/16.
//  Copyright © 2016 Ming Hu. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeCamera: UIBarButtonItem!

    @IBOutlet weak var shareMemeButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var topNavigationBar: UINavigationBar!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    var currentTextField: UITextField?
    
    // Set these state to true when the user first edited the image
    var topTextFieldEdited = false
    var bottomTextFieldEdited = false
    
    var memedImage: UIImage?

    // The final meme object that includes memedImage, and two text filed's text
    var meme: Meme?
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memeCamera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3
            
        ]
        initTextField(topTextField, memeTextAttributes: memeTextAttributes)
        initTextField(bottomTextField, memeTextAttributes: memeTextAttributes)
        
        disableMemeEditor()
    }

    @IBAction func shareMeme(sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        activityController.completionWithItemsHandler = shareMemeFinished
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        memeImage.image = nil
        disableMemeEditor()
    }
    
    
    @IBAction func selectAlbum(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        presentViewController(imagePicker, animated: false, completion: nil)
        imagePicker.delegate = self
    }

    @IBAction func selectCamera(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        presentViewController(imagePicker, animated: false, completion: nil)
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.delegate = self
        
    }
    
    func initTextField(textField: UITextField, memeTextAttributes: [String: AnyObject]) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.backgroundColor = UIColor.clearColor()
        textField.borderStyle = UITextBorderStyle.None
        textField.textAlignment = NSTextAlignment.Center
        textField.delegate = self

    }
    
    func disableMemeEditor() {
        topTextField.enabled = false
        topTextField.text = "TOP"
        
        bottomTextField.enabled = false
        bottomTextField.text = "BOTTOM"
        
        shareMemeButton.enabled = false
    }
    
    func enableMemeEditor() {
        topTextField.enabled = true
        bottomTextField.enabled = true
        
        shareMemeButton.enabled = true
    }
    
    func clearTextFieldIfFirstEdit(edited: Bool, textField: UITextField) {
        if !edited {
            textField.text = ""
        }
    }
    
    //
    // UIImagePickerController delegate methods
    //
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        memeImage.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        memeImage.contentMode = UIViewContentMode.ScaleAspectFit
        enableMemeEditor()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //
    //UITextField delegate methods
    //
    func textFieldDidBeginEditing(textField: UITextField) {

        if textField == topTextField {
            clearTextFieldIfFirstEdit(topTextFieldEdited, textField: textField)
            topTextFieldEdited = true
            currentTextField = topTextField
        } else if textField == bottomTextField {
            clearTextFieldIfFirstEdit(bottomTextFieldEdited, textField: textField)
            bottomTextFieldEdited = true
            currentTextField = bottomTextField
        }
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //
    // Keyboard notifications
    //
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if currentTextField == bottomTextField {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if currentTextField == bottomTextField {
            view.frame.origin.y += getKeyboardHeight(notification)            
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    
    //
    // share button related functions
    //
    
    func shareMemeFinished(activityType: String?, completed: Bool, returnedItems: [AnyObject]?, activityError: NSError?) -> Void {

        if completed {
            self.meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: self.memeImage.image!, memedImage: memedImage!)
//            self.memeImage.image = memedImage
        }
    }
    
    func generateMemedImage() -> UIImage {
        topNavigationBar.hidden = true
        bottomToolbar.hidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        topNavigationBar.hidden = false
        bottomToolbar.hidden = false

        return memedImage
    }
}

