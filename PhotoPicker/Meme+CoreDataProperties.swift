//
//  Meme+CoreDataProperties.swift
//  PhotoPicker
//
//  Created by Mitul Manish on 10/07/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Meme {

    @NSManaged var memedImage: NSData?
    @NSManaged var rawImage: NSData?
    @NSManaged var topText: String?
    @NSManaged var bottomText: String?

}
