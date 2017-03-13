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
            editedImage.layer.borderColor = UIColor.black.cgColor
            editedImage.clipsToBounds = true
        }
        
        captionTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter Caption :)"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: captionTextView.font!.pointSize)
        placeholderLabel.sizeToFit()
        captionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: captionTextView.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.isHidden = !captionTextView.text.isEmpty
        
        let captionToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        captionToolbar.barStyle = UIBarStyle.default
        
        captionToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CaptionEditorViewController.keyboardCancelButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CaptionEditorViewController.keyboardPostButtonTapped)),
            //UIBarButtonItem(customView: self.customView)
        ]
        
        captionToolbar.sizeToFit()
        captionTextView.inputAccessoryView = captionToolbar
        
        captionTextView.becomeFirstResponder()
        captionTextView.returnKeyType = UIReturnKeyType.send
    
   

        // Do any additional setup after loading the view.
    }
    
    func textViewDidChange(_ captionTextView: UITextView) {
        placeholderLabel.isHidden = !captionTextView.text.isEmpty
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardCancelButtonTapped() {
        captionTextView.resignFirstResponder()
    }
    
    func resize(_ userImage: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 8, y: 38, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = userImage
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //editedImage.image = newImage
        return newImage!
    }

    func keyboardPostButtonTapped() {
//        let imageData = UIImageJPEGRepresentation(self.editedImage.image!, 1.0)
//        let imageFile = PFFile(name:"image.png", data:imageData!)
        
        self.editedImage.image = resize(userImage, newSize: CGSize(width: 359, height: 350))
        userMedia.postUserImage(editedImage.image!, withCaption: captionTextView.text!, withCompletion: { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Posted Image Successfully")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
            }
        })
        
        performSegue(withIdentifier: "postPressed", sender: captionTextView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let timelineViewController = segue.destination as! TimelineViewController
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
