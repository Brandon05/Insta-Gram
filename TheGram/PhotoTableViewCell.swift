//
//  PhotoTableViewCell.swift
//  TheGram
//
//  Created by Brandon Sanchez on 2/19/16.
//  Copyright © 2016 Brandon Sanchez. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class PhotoTableViewCell: UITableViewCell, TTTAttributedLabelDelegate {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var usernameButton: UIButton!
    @IBOutlet var timeStamp: UILabel!
    @IBOutlet var captionLabel: TTTAttributedLabel!
    
    //var userMedia = UserMedia?.self
    

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.clipsToBounds = true
        profileImage.clipsToBounds = true
        
        //captionLabel.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
  
    

    
    

}
