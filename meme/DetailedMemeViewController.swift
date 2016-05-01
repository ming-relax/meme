//
//  DetailedMemeViewController.swift
//  meme
//
//  Created by Ming Hu on 5/1/16.
//  Copyright © 2016 Ming Hu. All rights reserved.
//

import Foundation
import UIKit
class DetailedMemeViewController: UIViewController {

    var meme: UIImage?
    
    @IBOutlet var memeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.contentMode = .ScaleAspectFit
        memeImage.image = meme
    }
    
}