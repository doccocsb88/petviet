//
//  HomeViewCell.swift
//  petviet
//
//  Created by Macintosh HD on 9/22/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit
import Kingfisher
class HomeViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var displaynameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var likedByLabel: UILabel!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    //
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var storyPhotoImageView: UIImageView!
    var didTappedLike:()->() = {}
    var didTappedComment:()->() = {}

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
        let avatarSize = self.avatarImageView.frame.height
        self.avatarImageView.addBorder(avatarSize / 2, 0.5, UIColor.lightGray)
        
    }
    
    func updateContent(_ post:PostDetail){
        captionLabel.text = post.story
        if let imagePath = post.imagePath , imagePath.count > 0{
            storyPhotoImageView.kf.setImage(with: URL(string: imagePath))
        }else{
            storyPhotoImageView.image = UIImage(named: "ic_default_photo")
        }
        displaynameLabel.text = post.userName
        if let userId = FirebaseServices.shared().userId(){
            likeButton.isSelected = post.isLiked(userId)
        }
        if post.likes.count == 0{
            likedByLabel.text = "Không ai thích sen cả."

        }else{
            likedByLabel.text = "\(post.likes.count) người đã thích bài viết này."
        }
        
    }
    @IBAction func tappedLikeButton(_ sender: Any) {
        didTappedLike()
    }
    
    @IBAction func tappedCommentButton(_ sender: Any) {
        didTappedComment()
    }
}
