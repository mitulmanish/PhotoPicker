//
//  ViewController.swift
//  PhotoPicker
//
//  Created by Mitul Manish on 6/07/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class PickImageViewController: UIViewController, UITextFieldDelegate,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    let defaultText = "TEXT AREA"
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myToolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var userTextFieldTop: UITextField!
    @IBOutlet weak var userTextFieldBottom: UITextField!
    
    
    let picker = UIImagePickerController()
    
    func cameraNotAvailable() {
        let alertViewController = UIAlertController(title: "Camera Not Supported",
                                                    message: "This device does not have a camera",preferredStyle: .ActionSheet)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alertViewController.addAction(okAction)
        presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    //get a photo from the library. We present as a popover on iPad, and fullscreen on smaller devices.
    @IBAction func photoFromLibrary(sender: UIBarButtonItem) {
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        picker.modalPresentationStyle = .Popover
        presentViewController(picker, animated: true, completion: nil)//4
        picker.popoverPresentationController?.barButtonItem = sender
    }
    
    //take a picture, check if we have a camera first.
    @IBAction func shootPhoto(sender: UIBarButtonItem) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            picker.modalPresentationStyle = .FullScreen
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Mimifier"
        picker.delegate = self   //the required delegate to get a photo back to the app.
        configureTextFields()
    }
    
    func configureTextFields() {
        let memeTextAttributes = [NSStrokeWidthAttributeName: -3,
                                  NSStrokeColorAttributeName: UIColor.darkGrayColor(),
                                  NSForegroundColorAttributeName: UIColor.whiteColor(),
                                  NSFontAttributeName: UIFont(name: "Arial", size: 35.0)! ]
        
        [userTextFieldTop, userTextFieldBottom].forEach { (textField) in
            textField.defaultTextAttributes = memeTextAttributes
            textField.delegate = self
            textField.textAlignment = .Center
            textField.text = defaultText
            textField.borderStyle = .None
            textField.backgroundColor = UIColor.clearColor()
        }
    }
    
    
    //MARK: - Delegates
    // if the user select a photo or click a picture and wants to use it ,
    // set the selected image to the
    // image view and go back to the root view
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        myImageView.contentMode = .ScaleAspectFill
        myImageView.clipsToBounds = true
        myImageView.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        switch (textField.tag) {
        case 1:
            let oldText = textField.text! as NSString
            let newText = oldText.stringByReplacingCharactersInRange(range, withString: string)
            userTextFieldTop.text = String(newText)
        case 2:
            let oldText = textField.text! as NSString
            let newText = oldText.stringByReplacingCharactersInRange(range, withString: string)
            userTextFieldBottom.text = String(newText)
        default: break
            
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        switch (textField.tag) {
        case 1:
            clearTextField(textField)
        case 2:
            clearTextField(textField)
        default: break
            
        }
    }
    
    func clearTextField(selectedTextField: UITextField) {
        if selectedTextField.text == defaultText {
            selectedTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) ? true : false
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PickImageViewController.keyboardWillShow(_:))    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PickImageViewController.keyboardWillHide(_:))    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        if (userTextFieldBottom.editing) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "share" {
            let destinationController = segue.destinationViewController as! ShareViewController
            if myImageView.image != nil {
                destinationController.sharableMeme = memeCreator()
            }
        }
    }
    
    func memeCreator() -> MemeObject {
        return MemeObject(rawImage: myImageView.image!, topText: userTextFieldTop.text!, BottomText: userTextFieldBottom.text!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        hideExtras()
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        showExtras()
        
        return memedImage
    }
    
    func hideExtras() {
        self.myToolBar.hidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showExtras() {
        self.myToolBar.hidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
}

struct MemeObject {
    var rawImage: UIImage
    var topText: String
    var BottomText: String
    var memedImage: UIImage
}

