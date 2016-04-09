//
//  ViewController.swift
//  meme
//
//  Created by Ming Hu on 3/29/16.
//  Copyright © 2016 Ming Hu. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeCamera: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memeCamera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        memeImage.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        memeImage.contentMode = UIViewContentMode.ScaleAspectFit
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

