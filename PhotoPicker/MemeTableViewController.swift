//
//  MemeTableViewController.swift
//  PhotoPicker
//
//  Created by Mitul Manish on 10/07/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import CoreData

class MemeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultController:NSFetchedResultsController!
    var memes: [Meme] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Saved Memes"
        fetch()
    }
    
    func fetch() {
        
        let fetchRequest = NSFetchRequest(entityName: "Meme")
        let sortDescriptor = NSSortDescriptor(key: "bottomText", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ((UIApplication.sharedApplication().delegate as?
            AppDelegate)?.managedObjectContext)!, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            memes = (fetchResultController.fetchedObjects as? [Meme])!
            print(memes.count)
        } catch {
            print(error)
        }
        print(memes.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let meme = memes[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MemeTableViewCell
        
        cell.memeImage.layer.borderColor = UIColor.whiteColor().CGColor
        cell.memeImage.image = UIImage(data: meme.memedImage!)
        
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) in
            let managedObjectContext = ((UIApplication.sharedApplication().delegate as?
                AppDelegate)?.managedObjectContext)!
            let itemToBeDeleted = self.fetchResultController.objectAtIndexPath(indexPath) as! Meme
            managedObjectContext.deleteObject(itemToBeDeleted)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
        
        deleteAction.backgroundColor = UIColor(red: 207.0/255.0, green: 0.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        
        let imageShareAction = UITableViewRowAction(style: .Normal, title: "Share Meme") { (action, indexPath) in
            
            let memeToBeShared = self.fetchResultController.objectAtIndexPath(indexPath) as! Meme
            let memedImage = UIImage(data: memeToBeShared.memedImage!)
            let activityController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
            self.presentViewController(activityController, animated: true, completion: nil)
        }
        
        
        deleteAction.backgroundColor = UIColor(red: 207.0/255.0, green: 0.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        
        imageShareAction.backgroundColor = UIColor(red: 135.0/255.0, green: 211.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        
        return [deleteAction, imageShareAction]
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            if let _newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
            }
        case .Delete:
            if let _indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
        case .Update:
            if let _indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
            
        default:
            tableView.reloadData()
        }
        
        memes = (controller.fetchedObjects as? [Meme])!
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
}
