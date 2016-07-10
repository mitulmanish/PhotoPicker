//
//  DataAccess.swift
//  PhotoPicker
//
//  Created by Mitul Manish on 10/07/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataAccess {
    let managedObjectContext: NSManagedObjectContext?
    
    static let sharedInstance = DataAccess()
    private init() {
        managedObjectContext =  (UIApplication.sharedApplication().delegate as?
            AppDelegate)?.managedObjectContext
    } //This prevents others from using the default '()' initializer for this class.
    
    func saveNewMeme(topText: String?, bottomText: String?, rawImage: UIImage?, memedImage: UIImage?) {
        
        let memeEntity = NSEntityDescription.insertNewObjectForEntityForName("Meme", inManagedObjectContext: managedObjectContext!) as! Meme
        
        if let topText = topText {
            memeEntity.setValue(topText, forKey: "topText")
        }
        
        if let bottomText = bottomText {
            memeEntity.setValue(bottomText, forKey: "bottomText")
        }
        
        if let rawImage = rawImage {
            memeEntity.rawImage = UIImagePNGRepresentation(rawImage)
        }
        
        if let memedImage = memedImage {
            memeEntity.memedImage = UIImagePNGRepresentation(memedImage)
        }
        
        print("Saving Work")
        do{
            try managedObjectContext!.save()
        }
        catch{
            fatalError("Unable to save object")
        }
        print("Done Saving Meme")
    }
}
