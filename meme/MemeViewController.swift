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

    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    
    // Set these state to true when the user first edited the image
    var topTextFieldEdited = false
    var bottomTextFieldEdited = false

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memeCamera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        print("viewWillAppear")
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
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.backgroundColor = UIColor.clearColor()
        topTextField.borderStyle = UITextBorderStyle.None
        topTextField.textAlignment = NSTextAlignment.Center
        topTextField.delegate = self

        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.backgroundColor = UIColor.clearColor()
        bottomTextField.borderStyle = UITextBorderStyle.None
        bottomTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.delegate = self
        
        disableMemeEditor()
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
    
    func disableMemeEditor() {
        topTextField.enabled = false
        topTextField.text = "TOP"
        
        bottomTextField.enabled = false
        bottomTextField.text = "BOTTOM"
    }
    
    func enableMemeEditor() {
        topTextField.enabled = true
        bottomTextField.enabled = true
    }
    
    func clearTextFieldIfFirstEdit(edited: Bool, textField: UITextField) {
        if !edited {
            textField.text = ""
        }
    }
    
    // UIImagePickerController delegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        memeImage.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        memeImage.contentMode = UIViewContentMode.ScaleAspectFit
        enableMemeEditor()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //UITextField delegate methods
    func textFieldDidBeginEditing(textField: UITextField) {

        if textField == topTextField {
            clearTextFieldIfFirstEdit(topTextFieldEdited, textField: textField)
            topTextFieldEdited = true
        } else if textField == bottomTextField {
            clearTextFieldIfFirstEdit(bottomTextFieldEdited, textField: textField)
            bottomTextFieldEdited = true
        }
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

