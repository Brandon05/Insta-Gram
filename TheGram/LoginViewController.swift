//
//  LoginViewController.swift
//  TheGram
//
//  Created by Brandon Sanchez on 2/16/16.
//  Copyright © 2016 Brandon Sanchez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signInTouched(sender: AnyObject) {
//        if usernameTextField.text && != nil {
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("Successfully Logged In")
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
        }
//        } else {
//            print("username is nil")
//        }
    }
   

    @IBAction func signUpTouched(sender: AnyObject) {
        
        if usernameTextField.text != "" && passwordTextField.text != "" {
        let newUser = PFUser()
        
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        
            
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
               print("createdUser")
               self.performSegueWithIdentifier("loginSegue", sender: nil)
            } else {
               print(error?.localizedDescription)
                if error?.code == 202 {
                    print("This User name is already taken")
                }
            }
        }
            
        } else {
            print("no username or password")
        }
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
