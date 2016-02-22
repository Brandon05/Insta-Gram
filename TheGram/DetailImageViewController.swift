//
//  DetailImageViewController.swift
//  TheGram
//
//  Created by Brandon Sanchez on 2/22/16.
//  Copyright © 2016 Brandon Sanchez. All rights reserved.
//

import UIKit

class DetailImageViewController: UIViewController {

    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var userImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.flatBlueColor()
        self.backgroundImage.image = UIImage(named: "background")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
