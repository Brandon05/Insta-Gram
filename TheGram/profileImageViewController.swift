//
//  profileImageViewController.swift
//  TheGram
//
//  Created by Brandon Sanchez on 2/21/16.
//  Copyright © 2016 Brandon Sanchez. All rights reserved.
//

import UIKit
import imglyKit

class profileImageViewController: IMGLYCameraViewController {
    
    var profileImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recordingModes
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CompletionBlock(result: IMGLYEditorResult, profileImage: UIImage?) {
        if let profileimage = profileImage where result == .Done {
    
            self.profileImage = profileimage
            if self.profileImage != nil {
                print("working")
            }
            //UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
            
        }
        dismissViewControllerAnimated(true, completion: nil)
        if (NSThread.isMainThread()) {
            print("yes")
        }
        dispatch_async(dispatch_get_main_queue()) {
            [unowned self] in
            self.performSegueWithIdentifier("unwindToEditProfile", sender: self)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let editProfileViewController = segue.destinationViewController as! EditProfileViewController
        editProfileViewController.userProfileImage = profileImage!
        
    }
    
    internal override func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: {
            if let completionBlock = self.completionBlock {
                completionBlock(image, nil)
            } else {
                if let image = image {
                    self.showEditorNavigationControllerWithImage(image)
                }
            }
        })
    }
    
    private func showEditorNavigationControllerWithImage(image: UIImage) {
        let editorViewController = IMGLYMainEditorViewController()
        editorViewController.highResolutionImage = image
        if let cameraController = cameraController {
            editorViewController.initialFilterType = cameraController.effectFilter.filterType
            editorViewController.initialFilterIntensity = cameraController.effectFilter.inputIntensity
        }
        editorViewController.completionBlock = CompletionBlock
        
        let navigationController = IMGLYNavigationController(rootViewController: editorViewController)
        navigationController.navigationBar.barStyle = .Black
        navigationController.navigationBar.translucent = false
        navigationController.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.whiteColor() ]
        //navigationController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "tappedDone")
        print("works")
        //performSegueWithIdentifier("CaptionEditorSegue", sender: self)
        self.presentViewController(navigationController, animated: true, completion: nil)
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
