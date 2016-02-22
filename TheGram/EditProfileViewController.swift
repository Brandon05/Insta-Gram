//
//  EditProfileViewController.swift
//  TheGram
//
//  Created by Brandon Sanchez on 2/21/16.
//  Copyright © 2016 Brandon Sanchez. All rights reserved.
//

import UIKit
import Parse
import ChameleonFramework

class EditProfileViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var editBioTextView: UITextView!
    @IBOutlet var editAgeTextView: UITextView!
    @IBOutlet var editHometownTextView: UITextView!
    let userMedia = UserMedia()
    var userProfileImage: UIImage!
    var bioPlaceholderLabel: UILabel!
    var agePlaceholderLabel: UILabel!
    var hometownPlaceholderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.TopToBottom, withFrame:self.view.bounds, andColors:[UIColor.flatGrayColorDark(), UIColor.flatWhiteColor()])
        
        editBioTextView.delegate = self
        editAgeTextView.delegate = self
        editHometownTextView.delegate = self
        bioPlaceholderLabel = UILabel()
        agePlaceholderLabel = UILabel()
        hometownPlaceholderLabel = UILabel()
        agePlaceholderLabel.text = ""
        bioPlaceholderLabel.text = "Enter Caption :)"
        hometownPlaceholderLabel.text = ""
        bioPlaceholderLabel.font = UIFont.italicSystemFontOfSize(editBioTextView.font!.pointSize)
        agePlaceholderLabel.font = UIFont.italicSystemFontOfSize(editAgeTextView.font!.pointSize)
        hometownPlaceholderLabel.font = UIFont.italicSystemFontOfSize(editHometownTextView.font!.pointSize)
        bioPlaceholderLabel.sizeToFit()
        agePlaceholderLabel.sizeToFit()
        hometownPlaceholderLabel.sizeToFit()
        editBioTextView.addSubview(bioPlaceholderLabel)
        editAgeTextView.addSubview(agePlaceholderLabel)
        editHometownTextView.addSubview(hometownPlaceholderLabel)
        bioPlaceholderLabel.frame.origin = CGPointMake(5, editBioTextView.font!.pointSize / 2)
        agePlaceholderLabel.frame.origin = CGPointMake(5, editAgeTextView.font!.pointSize / 2)
        bioPlaceholderLabel.frame.origin = CGPointMake(5, editHometownTextView.font!.pointSize / 2)
        hometownPlaceholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        bioPlaceholderLabel.hidden = !editBioTextView.text.isEmpty
        agePlaceholderLabel.hidden = !editAgeTextView.text.isEmpty
        hometownPlaceholderLabel.hidden = !editHometownTextView.text.isEmpty
        
        let user = PFUser.currentUser()
        if (user?["profileImage"] != nil) {
            let userImageFile = user?["profileImage"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    let image = UIImage(data: imageData!)
                    self.profileImage.image = image
                }
            })
        }
        

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        if userProfileImage != nil {
            self.profileImage.image = userProfileImage
        }
        
        let user = PFUser.currentUser()
        
        if (user?["hometown"] != nil) {
            editHometownTextView.text = user!["hometown"] as? String
        }
        if (user?["age"] != nil) {
            editAgeTextView.text = user!["age"] as? String
        }
        if (user?["bio"] != nil) {
            editBioTextView.text = user!["bio"] as? String
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func textViewDidChange(editBioTextView: UITextView, editAgeTextView: UITextView, editHometownTextView: UITextView) {
//        bioPlaceholderLabel.hidden = !editBioTextView.text.isEmpty
//        agePlaceholderLabel.hidden = !editAgeTextView.text.isEmpty
//        hometownPlaceholderLabel.hidden = !editHometownTextView.text.isEmpty
//    }
    
    func textViewDidChange(editBioTextView: UITextView) {
        bioPlaceholderLabel.hidden = !editBioTextView.text.isEmpty
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

    
    @IBAction func onDone(sender: AnyObject) {
        
        let user = PFUser.currentUser()
        self.profileImage.image = resize(userProfileImage, newSize: CGSizeMake(100, 100))
        if (profileImage.image != nil) {
            user!["profileImage"] = getPFFileFromImage(profileImage.image!)
        }
        if (editHometownTextView.text != "" && editHometownTextView.text != nil) {
            user!["hometown"] = editHometownTextView.text!
        }
        if (editAgeTextView.text != "" && editAgeTextView.text != nil) {
            user!["age"] = editAgeTextView.text!
        }
        if (editBioTextView.text != "" && editBioTextView.text != nil) {
            user!["bio"] = editBioTextView.text!
        }
        
        user?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print("Update user failed")
                print(error.localizedDescription)
            } else {
                print("Updated user successfully")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
             })

        
//        self.profileImage.image = resize(userProfileImage, newSize: CGSizeMake(100, 100))
//        userMedia.postUserProfileImage(profileImage.image!, withHometown: editHometownTextView.text!, withAge: editAgeTextView.text!, withBio: editBioTextView.text!, withCompletion: { (success: Bool, error: NSError?) -> Void in
//        if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("Posted Image Successfully")
//                //NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
//            }
//        })
        performSegueWithIdentifier("unwindToProfile", sender: self)
    }
    
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "unwindToProfile") {
        let profileViewController = segue.destinationViewController as! ProfileViewController
        profileViewController.profileImage.image = profileImage.image
        profileViewController.bioLabel.text = editBioTextView.text
        profileViewController.ageLabel.text = editAgeTextView.text
        profileViewController.hometownLabel.text = editHometownTextView.text
        } else {
            let ProfileImageViewController = segue.destinationViewController as! profileImageViewController
        }
    }
    
    @IBAction func unwindToEditProfile(segue: UIStoryboardSegue) {
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
