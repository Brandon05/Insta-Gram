//
//  CaptionEditorViewController.swift
//  TheGram
//
//  Created by Brandon Sanchez on 2/20/16.
//  Copyright © 2016 Brandon Sanchez. All rights reserved.
//

import UIKit
import Parse

class CaptionEditorViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var captionTextView: UITextView!
    @IBOutlet var editedImage: UIImageView!
    var userImage: UIImage!
    var placeholderLabel: UILabel!
    let userMedia = UserMedia()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userImage != nil {
            self.editedImage.image = userImage
            editedImage.layer.borderWidth = 5
            editedImage.layer.borderColor = UIColor.blackColor().CGColor
            editedImage.clipsToBounds = true
        }
        
        captionTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter Caption :)"
        placeholderLabel.font = UIFont.italicSystemFontOfSize(captionTextView.font!.pointSize)
        placeholderLabel.sizeToFit()
        captionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPointMake(5, captionTextView.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.hidden = !captionTextView.text.isEmpty
        
        let captionToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        captionToolbar.barStyle = UIBarStyle.Default
        
        captionToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "keyboardCancelButtonTapped"),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Plain, target: self, action: "keyboardPostButtonTapped"),
            //UIBarButtonItem(customView: self.customView)
        ]
        
        captionToolbar.sizeToFit()
        captionTextView.inputAccessoryView = captionToolbar
        
        captionTextView.becomeFirstResponder()
        captionTextView.returnKeyType = UIReturnKeyType.Send
    
   

        // Do any additional setup after loading the view.
    }
    
    func textViewDidChange(captionTextView: UITextView) {
        placeholderLabel.hidden = !captionTextView.text.isEmpty
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardCancelButtonTapped() {
        captionTextView.resignFirstResponder()
    }
    
    func resize(userImage: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(8, 38, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = userImage
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //editedImage.image = newImage
        return newImage
    }

    func keyboardPostButtonTapped() {
//        let imageData = UIImageJPEGRepresentation(self.editedImage.image!, 1.0)
//        let imageFile = PFFile(name:"image.png", data:imageData!)
        
        self.editedImage.image = resize(userImage, newSize: CGSizeMake(359, 350))
        userMedia.postUserImage(editedImage.image!, withCaption: captionTextView.text!, withCompletion: { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Posted Image Successfully")
            NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
            }
        })
        performSegueWithIdentifier("postPressed", sender: captionTextView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let timelineViewController = segue.destinationViewController as! TimelineViewController
        //timelineVieController.timeline.reloadData()
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
