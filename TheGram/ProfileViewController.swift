//
//  ProfileViewController.swift
//  TheGram
//
//  Created by Brandon Sanchez on 2/21/16.
//  Copyright © 2016 Brandon Sanchez. All rights reserved.
//

import UIKit
import Parse
import ChameleonFramework

class ProfileViewController: UIViewController {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var hometownLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    var userProfileImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.TopToBottom, withFrame:self.view.bounds, andColors:[UIColor.flatRedColor(), UIColor.flatWhiteColor()])
        
        
        profileImage.clipsToBounds = true
        
        if userProfileImage != nil {
            self.profileImage.image = userProfileImage
        } else {
            self.profileImage.image = UIImage(named: "defaultProfileImage")
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        let user = PFUser.currentUser()
        
        if (user?.username != nil) {
            usernameLabel.text = user!.username
        }
        if (user?["hometown"] != nil) {
            hometownLabel.text = user!["location"] as? String
        }
        if (user?["age"] != nil) {
            ageLabel.text = user!["age"] as? String
        }
        if (user?["bio"] != nil) {
            bioLabel.text = user!["bio"] as? String
        }
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {
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
