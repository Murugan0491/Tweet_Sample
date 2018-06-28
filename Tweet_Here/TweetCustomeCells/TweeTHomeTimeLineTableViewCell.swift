//
//  TweeTHomeTimeLineTableViewCell.swift
//  Tweet_Here
//
//  Created by murugan on 29/06/18.
//  Copyright © 2018 murugan. All rights reserved.
//

import UIKit
import TwitterKit

class TweeTHomeTimeLineTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetView: TWTRTweetView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
