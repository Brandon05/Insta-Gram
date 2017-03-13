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
    
    func CompletionBlock(_ result: IMGLYEditorResult, profileImage: UIImage?) {
        if let profileimage = profileImage, result == .done {
    
            self.profileImage = profileimage
            if self.profileImage != nil {
                print("working")
            }
            //UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
            
        }
        dismiss(animated: true, completion: nil)
        if (Thread.isMainThread) {
            print("yes")
        }
        DispatchQueue.main.async {
            [unowned self] in
            self.performSegue(withIdentifier: "unwindToEditProfile", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let editProfileViewController = segue.destination as! EditProfileViewController
        editProfileViewController.userProfileImage = profileImage!
        
    }
    
    internal override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismiss(animated: true, completion: {
            if let completionBlock = self.completionBlock {
                completionBlock(image, nil)
            } else {
                if let image = image {
                    self.showEditorNavigationControllerWithImage(image)
                }
            }
        })
    }
    
    fileprivate func showEditorNavigationControllerWithImage(_ image: UIImage) {
        let editorViewController = IMGLYMainEditorViewController()
        editorViewController.highResolutionImage = image
        if let cameraController = cameraController {
            editorViewController.initialFilterType = cameraController.effectFilter.filterType
            editorViewController.initialFilterIntensity = cameraController.effectFilter.inputIntensity
        }
        editorViewController.completionBlock = CompletionBlock
        
        let navigationController = IMGLYNavigationController(rootViewController: editorViewController)
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.white ]
        //navigationController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "tappedDone")
        print("works")
        //performSegueWithIdentifier("CaptionEditorSegue", sender: self)
        self.present(navigationController, animated: true, completion: nil)
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
