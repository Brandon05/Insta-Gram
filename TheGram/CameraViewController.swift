//
//  CameraViewController.swift
//  TheGram
//
//  Created by Brandon Sanchez on 2/20/16.
//  Copyright © 2016 Brandon Sanchez. All rights reserved.
//

import UIKit
import imglyKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


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
    
    func setTabBarVisible(_ visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:TimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animate(withDuration: duration, animations: {
                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                return
            }) 
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < self.view.frame.maxY
    }
    
    func editorCompletionBlock(_ result: IMGLYEditorResult, image: UIImage?) {
        if let image = image, result == .done {
            
            self.editedImage = image
            //UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
            
        }
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "CaptionEditorSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let captionEditorViewController = segue.destination as! CaptionEditorViewController
        captionEditorViewController.userImage = editedImage!
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
        editorViewController.completionBlock = editorCompletionBlock
        
        let navigationController = IMGLYNavigationController(rootViewController: editorViewController)
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.white ]
        //navigationController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "tappedDone")
        print("works")
        //performSegueWithIdentifier("CaptionEditorSegue", sender: self)
        self.present(navigationController, animated: true, completion: nil)
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

