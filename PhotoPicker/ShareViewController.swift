//
//  ShareViewController.swift
//  PhotoPicker
//
//  Created by Mitul Manish on 7/07/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    @IBOutlet weak var memedImageView: UIImageView!
    var sharableMeme: MemeObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memedImageView.clipsToBounds = true
        
        if let memeObject = sharableMeme {
            memedImageView.image = memeObject.memedImage
        } else {
            memedImageView.image = UIImage(named: "dog")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shareImage() {
        let activityItem: [AnyObject] = [self.sharableMeme?.memedImage as! AnyObject]
        
        let activityViewController = UIActivityViewController(activityItems: activityItem, applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func saveMeme() {
        
        if let meme = self.sharableMeme {
            DataAccess.sharedInstance.saveNewMeme(meme.topText, bottomText: meme.BottomText, rawImage: meme.rawImage, memedImage: meme.memedImage)
        }
        
        shareImage()
    }
    
    @IBAction func backToMaster() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
