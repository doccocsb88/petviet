//
//  CommentViewCell.swift
//  petviet
//
//  Created by Macintosh HD on 9/22/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class CommentViewCell: UITableViewCell {

    @IBOutlet weak var avatarButton: UIButton!
    
    @IBOutlet weak var displayNameLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    @IBOutlet weak var answerButton: UIButton!
    var didTappedAnswer:()->() = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateContent(_ comment:PetComment){
        displayNameLabel.text = comment.userDisplayName

        let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedStringKey.foregroundColor : UIColor.blue]
        
        let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedStringKey.foregroundColor : UIColor.black]
        let attributedString = NSMutableAttributedString(string: "")
        if comment.to_user.count > 0{
            let string = comment.to_user
            if let json = Utils.convertToDict(string){
                let userId = json["userId"] as? String ?? ""
                let displayName = json["displayName"] as? String ?? userId
                if displayName.count > 0{
                    let attributedString1 = NSMutableAttributedString(string: "@\(displayName) ", attributes:attrs1)
                    attributedString.append(attributedString1)
                }
            }

        }
        
        let attributedString2 = NSMutableAttributedString(string:comment.message, attributes:attrs2)
        
        attributedString.append(attributedString2)

        messageLabel.attributedText = attributedString
       
        let fromDate = Date(milliseconds: comment.created_date)
        caculateTimeToNow(fromDate)
        if let user = FirebaseServices.shared().currentUser(), user.uid == comment.userId{
            answerButton.isHidden = true
        }else{
            answerButton.isHidden = false
        }
        
    }
    func caculateTimeToNow(_ fromDate:Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        //        let stdate : String = "2018-06-02 10:11:12"
        //        let startDate = dateFormatter.date(from: stdate)!
        
        let differ = Date().millisecondsSince1970 -  fromDate.millisecondsSince1970
        NSLog("differ : %ld", differ)
        let seconds = differ /  1000
        let mins = seconds / 60
        let hours = mins / 60
        let days = hours / 24
        let weaks = days / 7
        let months = weaks / 4
        let years = months / 12
        if years > 0{
            createdLabel.text = "\(years) năm trước"

        }else if months > 0{
            createdLabel.text = "\(months) tháng trước"

        }else if weaks > 0{
            createdLabel.text = "\(weaks) tuần trước"

        }else if days > 0{
            createdLabel.text = "\(days) ngày trước"

        }else if hours > 0{
            createdLabel.text = "\(hours) giờ trước"

        }else if mins > 0{
            createdLabel.text = "\(mins) phút trước"

        }else if seconds > 0{
            createdLabel.text = "\(seconds) giây trước"

        }else {
            createdLabel.text = "Vừa xong"
        }
    }

    @IBAction func tappedAnswerButton(_ sender: Any) {
        didTappedAnswer()
    }
    
}
