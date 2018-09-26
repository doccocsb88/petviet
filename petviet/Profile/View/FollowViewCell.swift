//
//  FollowViewCell.swift
//  petviet
//
//  Created by Hai Vu on 9/26/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class FollowViewCell: UITableViewCell {

    @IBOutlet weak var avatarButton: UIButton!
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var displayNameLabel: UILabel!
    var didTappedAvatar:()->() = {}
    var didTappedUnFollow:()->() = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupUI(){
        let avatarSize = avatarButton.frame.size.height
        avatarButton.addBorder(avatarSize / 2, 1, .lightGray)
        followButton.addBorder(2, 1, .lightGray)
    }
    func updateContent(_ follow:PetFollow, _ following:Bool){
//        if following = true = following
//        if following = false = followers
        if following{
            displayNameLabel.text = follow.toName
        }else{
            displayNameLabel.text = follow.fromName

        }

    }
    @IBAction func tappedAvatarButton(_ sender: Any) {
    }
    
    @IBAction func tappedFollowButton(_ sender: Any) {
        didTappedUnFollow()
    }
}
