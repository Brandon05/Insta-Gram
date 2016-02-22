//
//  ViewController.swift
//  TheGram
//
//  Created by Brandon Sanchez on 2/16/16.
//  Copyright © 2016 Brandon Sanchez. All rights reserved.
//

import UIKit
import Parse
import TTTAttributedLabel

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate {

    @IBOutlet var signOut: UIButton!
    @IBOutlet var timeline: UITableView!
    var userMedia: [PFObject]?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeline.delegate = self
        timeline.dataSource = self
        timeline.rowHeight = UITableViewAutomaticDimension
        timeline.estimatedRowHeight = 120
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadFeed:",name:"load", object: nil)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        timeline.insertSubview(refreshControl, atIndex: 0)
        refreshControl.backgroundColor = UIColor.blueColor()
        refreshControl.tintColor = UIColor.whiteColor()
        
        
        fetchData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        fetchData()
        self.timeline.reloadData()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFeed(notification: NSNotification) {
        fetchData()
        self.timeline.reloadData()
    }

    @IBAction func onSignOut(sender: AnyObject) {
        PFUser.logOut()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userMedia != nil {
          return userMedia!.count
        } else {
        return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoTableViewCell") as! PhotoTableViewCell
        

        
        if (userMedia?[indexPath.row]["media"] != nil) {
            let userPicture = userMedia?[indexPath.row]["media"] as! PFFile
            userPicture.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if let error = error {
                    print("error")
                    print(error.localizedDescription)
                }
                else {
                    let image = UIImage(data: imageData!)
                    cell.userImageView!.clipsToBounds = true
                    cell.userImageView!.image = image
                    
                }
            })
        }
        if (userMedia?[indexPath.row]["author"].username != nil) {
            
            cell.usernameButton.setTitle(userMedia![indexPath.row]["author"].username, forState: UIControlState.Normal) 
        }
        if (userMedia?[indexPath.row].createdAt != nil) {
            var createdAt: String?
            let elapsedTime = NSDate().timeIntervalSinceDate((userMedia?[indexPath.row].createdAt)!)
            let duration = Int(elapsedTime)
            
            if duration / 86400 >= 1 {
                createdAt = String(duration / (360 * 24)) + "d"
            }
            else if duration / 3600 >= 1 {
                createdAt = String(duration / 360) + "h"
                
            }
            else if duration / 60 >= 1 {
                createdAt = String(duration / 60) + "min"
            }
            else {
                createdAt = String(duration) + "s"
            }

            cell.timeStamp.text = createdAt
        }
        
        if (userMedia?[indexPath.row]["caption"] != nil && userMedia?[indexPath.row]["author"].username != nil) {
            let username = userMedia![indexPath.row]["author"].username!
            
            cell.captionLabel.text = ("\(username!)" + " " + "\(userMedia![indexPath.row]["caption"])")
            cell.captionLabel.delegate = self
            let str = cell.captionLabel.text! as NSString
            let stringColor = NSMutableAttributedString(string: str as String)
            let range : NSRange = str.rangeOfString(username!)
            stringColor.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor() , range: range)
            let linkAttributes = [ NSForegroundColorAttributeName: UIColor.blueColor() ]
            cell.captionLabel.linkAttributes = linkAttributes
            
            cell.captionLabel.addLinkToURL(NSURL(string: "http://github.com/brandon05/")!, withRange: range)
            
            cell.captionLabel.attributedText = stringColor
            
        }
        
        if (userMedia?[indexPath.row]["profileImage"] != nil) {
            let userPicture = userMedia![indexPath.row]["profileImage"] as! PFFile
            userPicture.getDataInBackgroundWithBlock({ (image: NSData?, error: NSError?) -> Void in
                if let error = error {
                    print("error")
                    print(error.localizedDescription)
                }
                else {
                    let profileImage = UIImage(data: image!)
                    cell.profileImage!.clipsToBounds = true
                    cell.profileImage!.image = profileImage
                    
                }
            })

        } else {
            cell.profileImage.image = UIImage(named: "profileImage")
        }
        
        
        return cell
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        performSegueWithIdentifier("profileSegue", sender: self)
        print("works!!")
        
    }
    
//    func timeline(timeline: UITableView,
//        viewForHeaderInSection section: Int) -> UIView? {
//
//            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: timeline.frame.size.height))
//            headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
//            
//            let profileView = UIImageView(frame: CGRect(x: 10, y: 2, width: 25, height: 25))
//            profileView.clipsToBounds = true
//            profileView.layer.cornerRadius = 15;
//            profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
//            profileView.layer.borderWidth = 1;
//            
//            // Use the section number to get the right URL
//            // profileView.setImageWithURL(...)
//            
//            //let profile = photos![section]
//            
//            //profileView.setImageWithURL(NSURL(string: profile["user"]!["profile_picture"] as! String)!)
//            
//            
//            headerView.addSubview(profileView)
//            
//            
//            
//            let usernamelabel = UILabel(frame: CGRect(x: 60, y: 2, width: 200, height: 25))
//            usernamelabel.clipsToBounds = true
//            if (userMedia?[section]["author"].username != nil) {
//                usernamelabel.text = userMedia![section]["author"].username
//                usernamelabel.userInteractionEnabled = true
//                let aSelector : Selector = "profileSegue"
//                let tapGesture = UITapGestureRecognizer(target:self, action: aSelector)
//                usernamelabel.addGestureRecognizer(tapGesture)
//                
//            }
////            if (userMedia?[section]["author"]["profile_image"] != nil) {
////                let userImageFile = userMedia![section]["author"]["profile_image"] as! PFFile
////                userImageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
////                    if let error = error {
////                        print(error.localizedDescription)
////                    }
////                    else {
////                        let image = UIImage(data: imageData!)
////                        profileView.image = image
////                    }
////                })
////            }
//            usernamelabel.textColor = UIColor(red: 8/255.0, green: 64/255.0, blue: 180/255.0, alpha: 1)
//            headerView.addSubview(usernamelabel)
//            
//            return headerView
//            
//            
//            
//    }
//    
//    func timeline(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
    
    func fetchData() {
        // construct PFQuery
        let query = PFQuery(className: "UserMedia")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
    
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
        if let media = media {
            // do something with the data fetched
            self.userMedia = media
            self.timeline.reloadData()
        } else {
                // handle error
            }
        }
    }
    
    
    // refresh delay func
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    // refresh func
    func onRefresh() {
        fetchData()
        
        delay(1.5, closure: {
            self.timeline.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let profilePic = sender as? UIButton {
            if let superview = profilePic.superview {
                if let cell = superview.superview as? PhotoTableViewCell {
                    let indexPath = timeline.indexPathForCell(cell)
                    
                    let userPicture = userMedia?[indexPath!.row]["media"] as! PFFile
                    userPicture.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                        if let error = error {
                            print("error")
                            print(error.localizedDescription)
                        }
                    

                    
                    let detailView = segue.destinationViewController as! DetailImageViewController
                    let image = UIImage(data: imageData!)
                    detailView.userImage.clipsToBounds = true
                    detailView.userImage.image = image
                        
                    })
                }
            }
        }

        
    }


}

