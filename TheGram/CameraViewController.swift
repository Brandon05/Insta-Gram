//
//  CameraViewController.swift
//  TheGram
//
//  Created by Brandon Sanchez on 2/20/16.
//  Copyright © 2016 Brandon Sanchez. All rights reserved.
//

import UIKit
import imglyKit

class CameraViewController: IMGLYCameraViewController {
    
    let userMedia = UserMedia()
    var editedImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarVisible(!tabBarIsVisible(), animated: true)
       
        
        self.recordingModes
        self.tabBarController?.hidesBottomBarWhenPushed = true
        
        
        //cameraViewController.maximumVideoLength = 15
        //cameraViewController.squareMode = true
        
       // window = UIWindow(frame: UIScreen.mainScreen().bounds)
       // window?.rootViewController = cameraViewController
       // window?.makeKeyAndVisible()
       // return true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
                return
            }
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }
    
    func editorCompletionBlock(result: IMGLYEditorResult, image: UIImage?) {
        if let image = image where result == .Done {
            
            self.editedImage = image
            //UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
            
        }
        dismissViewControllerAnimated(true, completion: nil)
        performSegueWithIdentifier("CaptionEditorSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let captionEditorViewController = segue.destinationViewController as! CaptionEditorViewController
        captionEditorViewController.userImage = editedImage!
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
        editorViewController.completionBlock = editorCompletionBlock
        
        let navigationController = IMGLYNavigationController(rootViewController: editorViewController)
        navigationController.navigationBar.barStyle = .Black
        navigationController.navigationBar.translucent = false
        navigationController.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.whiteColor() ]
        //navigationController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "tappedDone")
        print("works")
        //performSegueWithIdentifier("CaptionEditorSegue", sender: self)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
//    private func configureNavigationItems() {
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "tappedDone:")
//    }
    
//    func tappedDone() {
//        // Subclasses must override this
//        print("works")
//        performSegueWithIdentifier("CaptionEditorSegue", sender: self)
//        dismissViewControllerAnimated(true, completion: nil)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

