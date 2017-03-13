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
        NotificationCenter.default.addObserver(self, selector: #selector(TimelineViewController.loadFeed(_:)),name:NSNotification.Name(rawValue: "load"), object: nil)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TimelineViewController.onRefresh), for: UIControlEvents.valueChanged)
        timeline.insertSubview(refreshControl, at: 0)
        refreshControl.backgroundColor = UIColor.blue
        refreshControl.tintColor = UIColor.white
        
        
        fetchData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
        self.timeline.reloadData()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFeed(_ notification: Notification) {
        fetchData()
        self.timeline.reloadData()
    }

    @IBAction func onSignOut(_ sender: AnyObject) {
        PFUser.logOut()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userMedia != nil {
          return userMedia!.count
        } else {
        return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell") as! PhotoTableViewCell
        

        
        if (userMedia?[indexPath.row]["media"] != nil) {
            let userPicture = userMedia?[indexPath.row]["media"] as! PFFile
            userPicture.getDataInBackground(block: { (imageData: Data?, error: NSError?) -> Void in
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
        if ((userMedia?[indexPath.row]["author"] as AnyObject).username != nil) {
            
            cell.usernameButton.setTitle(userMedia![indexPath.row]["author"].username, for: UIControlState()) 
        }
        if (userMedia?[indexPath.row].createdAt != nil) {
            var createdAt: String?
            let elapsedTime = Date().timeIntervalSince((userMedia?[indexPath.row].createdAt)!)
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
        
        if (userMedia?[indexPath.row]["caption"] != nil && (userMedia?[indexPath.row]["author"] as AnyObject).username != nil) {
            let username = (userMedia![indexPath.row]["author"] as AnyObject).username!
            
            cell.captionLabel.text = ("\(username!)" + " " + "\(userMedia![indexPath.row]["caption"])")
            cell.captionLabel.delegate = self
            let str = cell.captionLabel.text! as NSString
            let stringColor = NSMutableAttributedString(string: str as String)
            let range : NSRange = str.range(of: username!)
            stringColor.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue , range: range)
            let linkAttributes = [ NSForegroundColorAttributeName: UIColor.blue ]
            cell.captionLabel.linkAttributes = linkAttributes
            
            cell.captionLabel.addLink(to: URL(string: "http://github.com/brandon05/")!, with: range)
            
            cell.captionLabel.attributedText = stringColor
            
        }
        
        if (userMedia?[indexPath.row]["profileImage"] != nil) {
            let userPicture = userMedia![indexPath.row]["profileImage"] as! PFFile
            userPicture.getDataInBackground(block: { (image: Data?, error: NSError?) -> Void in
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
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        performSegue(withIdentifier: "profileSegue", sender: self)
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
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
    
        // fetch data asynchronously
        query.findObjectsInBackground { (media: [PFObject]?, error: NSError?) -> Void in
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
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    // refresh func
    func onRefresh() {
        fetchData()
        
        delay(1.5, closure: {
            self.timeline.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let profilePic = sender as? UIButton {
            if let superview = profilePic.superview {
                if let cell = superview.superview as? PhotoTableViewCell {
                    let indexPath = timeline.indexPath(for: cell)
                    
                    let userPicture = userMedia?[indexPath!.row]["media"] as! PFFile
                    userPicture.getDataInBackground(block: { (imageData: Data?, error: NSError?) -> Void in
                        if let error = error {
                            print("error")
                            print(error.localizedDescription)
                        }
                    

                    
                    let detailView = segue.destination as! DetailImageViewController
                    let image = UIImage(data: imageData!)
                    detailView.userImage.clipsToBounds = true
                    detailView.userImage.image = image
                        
                    })
                }
            }
        }

        
    }


}

