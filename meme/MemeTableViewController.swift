//
//  MemeTableViewController.swift
//  meme
//
//  Created by Ming Hu on 4/28/16.
//  Copyright © 2016 Ming Hu. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 

    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let vc: DetailedMemeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailedMeme") as! DetailedMemeViewController

        let meme: UIImage = memes[indexPath.row].memedImage
        vc.meme = meme
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("meme")!
        cell.textLabel?.text = memes[indexPath.row].topText! + memes[indexPath.row].bottomText!
        cell.imageView?.image = memes[indexPath.row].memedImage
        return cell
    }
}
